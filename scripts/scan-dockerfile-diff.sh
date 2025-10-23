#!/usr/bin/env bash

set -euo pipefail

show_help() {
  cat <<'EOF'
Usage: scan-dockerfile-diff.sh [--base <sha>] [--head <sha>] [--summary <file>]

Scans Dockerfile FROM line changes between two git refs and reports CVE deltas.
Defaults: --base BASE_SHA env, --head HEAD_SHA env, --summary SUMMARY_FILE env.
EOF
}

BASE_REF="${BASE_SHA:-}"
HEAD_REF="${HEAD_SHA:-}"
SUMMARY_FILE="${SUMMARY_FILE:-${GITHUB_STEP_SUMMARY:-}}"

while [ "$#" -gt 0 ]; do
  case "$1" in
    --base)
      BASE_REF="$2"
      shift 2
      ;;
    --head)
      HEAD_REF="$2"
      shift 2
      ;;
    --summary)
      SUMMARY_FILE="$2"
      shift 2
      ;;
    -h|--help)
      show_help
      exit 0
      ;;
    *)
      echo "Unknown argument: $1" >&2
      show_help
      exit 1
      ;;
  esac
done

if [ -z "${BASE_REF}" ] || [ -z "${HEAD_REF}" ]; then
  echo "Error: both base and head references are required." >&2
  show_help
  exit 1
fi

if ! git rev-parse --verify "${BASE_REF}" >/dev/null 2>&1; then
  echo "Error: base ref ${BASE_REF} is not a valid git reference." >&2
  exit 1
fi

if ! git rev-parse --verify "${HEAD_REF}" >/dev/null 2>&1; then
  echo "Error: head ref ${HEAD_REF} is not a valid git reference." >&2
  exit 1
fi

if [ ! -d .git ]; then
  echo "Error: script must be run inside a git repository." >&2
  exit 1
fi

output() {
  local line="${1:-}"
  echo "${line}"
  if [ -n "${SUMMARY_FILE:-}" ]; then
    echo "${line}" >> "${SUMMARY_FILE}"
  fi
}

log_cmd() {
  echo "+ $*" >&2
}

log_cmd git fetch --no-tags --depth=1 origin "${BASE_REF}"
git fetch --no-tags --depth=1 origin "${BASE_REF}" >/dev/null 2>&1 || true

log_cmd git diff --name-only --diff-filter=M "${BASE_REF}" "${HEAD_REF}"
CHANGED_FILES=$(git diff --name-only --diff-filter=M "${BASE_REF}" "${HEAD_REF}" | grep -E '(Dockerfile|\.Dockerfile)$' || true)

output "# 🔍 Dockerfile Diff CVE Scan"
output ""
output "- Comparing \`${BASE_REF}\` → \`${HEAD_REF}\`"
output ""

if [ -z "${CHANGED_FILES}" ]; then
  output "ℹ️ No Dockerfile changes detected in this comparison."
  exit 0
fi

output "## 📦 Changed Dockerfiles"
output ""
output '```'
output "${CHANGED_FILES}"
output '```'
output ""

if ! command -v grype >/dev/null 2>&1; then
  mkdir -p "${HOME}/.local/bin"
  curl -sSfL https://raw.githubusercontent.com/anchore/grype/main/install.sh | sh -s -- -b "${HOME}/.local/bin"
  export PATH="${HOME}/.local/bin:${PATH}"
fi

export PATH="${HOME}/.local/bin:${PATH}"

extract_image_ref() {
  local from_line="${1:-}"
  from_line="$(echo "${from_line}" | sed 's/^ *//;s/ *$//')"
  if [ -z "${from_line}" ]; then
    echo ""
    return
  fi

  # shellcheck disable=SC2086
  set -- $from_line

  if [ "$#" -eq 0 ]; then
    echo ""
    return
  fi

  if [ "$1" = "--platform" ]; then
    shift
    if [ "$#" -eq 0 ]; then
      echo ""
      return
    fi
    shift || true
  elif [[ "$1" == --platform=* ]]; then
    shift
  fi

  if [ "$#" -eq 0 ]; then
    echo ""
    return
  fi

  echo "$1"
}

describe_image_row() {
  local label="$1"
  local ref="${2:-}"

  if [ -z "${ref}" ]; then
    output "| ${label} | _(none)_ | _(none)_ | _(none)_ |"
    return
  fi

  local repo="(unknown)"
  local tag="(unknown)"
  local digest="(unknown)"

  if docker image inspect "${ref}" >/dev/null 2>&1; then
    local repo_tag
    repo_tag=$(docker image inspect "${ref}" --format '{{if .RepoTags}}{{index .RepoTags 0}}{{end}}' 2>/dev/null || true)
    if [ -n "${repo_tag}" ]; then
      local last_segment="${repo_tag##*/}"
      if [[ "${last_segment}" == *:* ]]; then
        tag="${last_segment##*:}"
        repo="${repo_tag%:*}"
      else
        repo="${repo_tag}"
        tag="latest"
      fi
    else
      repo="${ref}"
      tag="(none)"
    fi

    local repo_digest
    repo_digest=$(docker image inspect "${ref}" --format '{{if .RepoDigests}}{{index .RepoDigests 0}}{{end}}' 2>/dev/null || true)
    if [ -n "${repo_digest}" ]; then
      digest="${repo_digest}"
    fi
  else
    repo="${ref}"
  fi

  output "| ${label} | \`${repo}\` | \`${tag}\` | \`${digest}\` |"
}

format_diff() {
  local old_value="${1:-0}"
  local new_value="${2:-0}"
  local old_int=$((old_value))
  local new_int=$((new_value))
  local diff=$((new_int - old_int))
  if [ "${diff}" -gt 0 ]; then
    echo "${old_int} → ${new_int} 🔴 (+${diff})"
  elif [ "${diff}" -lt 0 ]; then
    echo "${old_int} → ${new_int} 🟢 (${diff})"
  else
    echo "${old_int} → ${new_int} ⚪ (0)"
  fi
}

grype_scan() {
  local ref="${1:-}"
  if [ -z "${ref}" ]; then
    echo ""
    return
  fi
  log_cmd grype "${ref}" -q -o template -t summary.tmpl
  grype "${ref}" -q -o template -t summary.tmpl 2>/dev/null || echo ""
}

summary_value() {
  local payload="${1:-}"
  local key="${2:-}"
  if [ -z "${payload}" ] || [ -z "${key}" ]; then
    echo "0"
    return
  fi
  local value
  if ! value=$(printf '%s\n' "${payload}" | jq -r --arg key "${key}" 'try (.[ $key ] // 0) catch 0' 2>/dev/null); then
    echo "0"
    return
  fi
  if [ -z "${value}" ] || [ "${value}" = "null" ]; then
    echo "0"
  else
    echo "${value}"
  fi
}

while IFS= read -r dockerfile; do
  [ -n "${dockerfile}" ] || continue

  output "### ${dockerfile}"
  output ""

  log_cmd git cat-file -e "${BASE_REF}:${dockerfile}"
  if ! git cat-file -e "${BASE_REF}:${dockerfile}" >/dev/null 2>&1; then
    output "ℹ️ ${dockerfile} added in this comparison; skipping baseline scan."
    output ""
    continue
  fi

  log_cmd git diff "${BASE_REF}" "${HEAD_REF}" -- "${dockerfile}"
  mapfile -t old_from_lines < <(git diff "${BASE_REF}" "${HEAD_REF}" -- "${dockerfile}" | sed -n '/^-FROM /s/^-FROM //p')
  mapfile -t new_from_lines < <(git diff "${BASE_REF}" "${HEAD_REF}" -- "${dockerfile}" | sed -n '/^+FROM /s/^+FROM //p')

  if [ "${#old_from_lines[@]}" -eq 0 ] && [ "${#new_from_lines[@]}" -eq 0 ]; then
    output "ℹ️ No FROM statement changes detected."
    output ""
    continue
  fi

  count="${#old_from_lines[@]}"
  if [ "${#new_from_lines[@]}" -gt "${count}" ]; then
    count="${#new_from_lines[@]}"
  fi

  for ((idx=0; idx<count; idx++)); do
    old_line="${old_from_lines[$idx]-}"
    new_line="${new_from_lines[$idx]-}"

    output "#### Change $((idx + 1))"
    if [ -n "${old_line}" ]; then
      output "- **Before:** \`FROM ${old_line}\`"
    else
      output "- **Before:** _(not present)_"
    fi

    if [ -n "${new_line}" ]; then
      output "- **After:** \`FROM ${new_line}\`"
    else
      output "- **After:** _(removed)_"
    fi
    output ""

    old_ref="$(extract_image_ref "${old_line}")"
    new_ref="$(extract_image_ref "${new_line}")"

    if [ -n "${old_ref}" ]; then
      log_cmd docker pull "${old_ref}"
      if ! docker pull "${old_ref}" >/dev/null 2>&1; then
        output "❌ Failed to pull \`${old_ref}\`"
        old_ref=""
      fi
    fi

    if [ -n "${new_ref}" ]; then
      log_cmd docker pull "${new_ref}"
      if ! docker pull "${new_ref}" >/dev/null 2>&1; then
        output "❌ Failed to pull \`${new_ref}\`"
        new_ref=""
      fi
    fi

    output "| Version | Image | Tag | Digest |"
    output "|---------|-------|-----|--------|"
    describe_image_row "Before" "${old_ref}"
    describe_image_row "After" "${new_ref}"
    output ""

    old_scan="$(grype_scan "${old_ref}")"
    new_scan="$(grype_scan "${new_ref}")"

    if [ -n "${SCAN_DEBUG_DIR:-}" ]; then
      mkdir -p "${SCAN_DEBUG_DIR}"
      if [ -n "${old_scan}" ]; then
        printf '%s\n' "${old_scan}" >"${SCAN_DEBUG_DIR}/$(basename "${dockerfile}")_change$((idx + 1))_before.json"
      fi
      if [ -n "${new_scan}" ]; then
        printf '%s\n' "${new_scan}" >"${SCAN_DEBUG_DIR}/$(basename "${dockerfile}")_change$((idx + 1))_after.json"
      fi
    fi

    OLD_TOTAL="$(summary_value "${old_scan}" "total")"
    OLD_NEGLIGIBLE="$(summary_value "${old_scan}" "negligible")"
    OLD_LOW="$(summary_value "${old_scan}" "low")"
    OLD_MEDIUM="$(summary_value "${old_scan}" "medium")"
    OLD_HIGH="$(summary_value "${old_scan}" "high")"
    OLD_CRITICAL="$(summary_value "${old_scan}" "critical")"
    OLD_UNKNOWN="$(summary_value "${old_scan}" "unknown")"

    NEW_TOTAL="$(summary_value "${new_scan}" "total")"
    NEW_NEGLIGIBLE="$(summary_value "${new_scan}" "negligible")"
    NEW_LOW="$(summary_value "${new_scan}" "low")"
    NEW_MEDIUM="$(summary_value "${new_scan}" "medium")"
    NEW_HIGH="$(summary_value "${new_scan}" "high")"
    NEW_CRITICAL="$(summary_value "${new_scan}" "critical")"
    NEW_UNKNOWN="$(summary_value "${new_scan}" "unknown")"

    if [ -z "${old_scan}" ] && [ -n "${old_ref}" ]; then
      output "⚠️ No scan results captured for \`${old_ref}\`; grype returned no payload."
    fi
    if [ -z "${new_scan}" ] && [ -n "${new_ref}" ]; then
      output "⚠️ No scan results captured for \`${new_ref}\`; grype returned no payload."
    fi

    output "- Before totals: Total ${OLD_TOTAL}, Critical ${OLD_CRITICAL}, High ${OLD_HIGH}, Medium ${OLD_MEDIUM}, Low ${OLD_LOW}, Negligible ${OLD_NEGLIGIBLE}, Unknown ${OLD_UNKNOWN}"
    output "- After totals: Total ${NEW_TOTAL}, Critical ${NEW_CRITICAL}, High ${NEW_HIGH}, Medium ${NEW_MEDIUM}, Low ${NEW_LOW}, Negligible ${NEW_NEGLIGIBLE}, Unknown ${NEW_UNKNOWN}"
    output ""

    output "| Severity | Change |"
    output "|----------|--------|"
    output "| Critical | $(format_diff "${OLD_CRITICAL}" "${NEW_CRITICAL}") |"
    output "| High     | $(format_diff "${OLD_HIGH}" "${NEW_HIGH}") |"
    output "| Medium   | $(format_diff "${OLD_MEDIUM}" "${NEW_MEDIUM}") |"
    output "| Low      | $(format_diff "${OLD_LOW}" "${NEW_LOW}") |"
    output "| Negligible | $(format_diff "${OLD_NEGLIGIBLE}" "${NEW_NEGLIGIBLE}") |"
    output "| Unknown  | $(format_diff "${OLD_UNKNOWN}" "${NEW_UNKNOWN}") |"
    output "| **Total** | **$(format_diff "${OLD_TOTAL}" "${NEW_TOTAL}")** |"
    output ""

    total_diff=$((NEW_TOTAL - OLD_TOTAL))
    if [ "${total_diff}" -lt 0 ]; then
      output "✅ Improvement: reduced CVEs by $((-total_diff))."
    elif [ "${total_diff}" -gt 0 ]; then
      output "⚠️ Regression: increased CVEs by ${total_diff}."
    else
      output "⚪ No net change in CVE count."
    fi
    output ""
  done
done <<<"${CHANGED_FILES}"

output "---"
output ""
output "✅ Dockerfile diff scan complete."
