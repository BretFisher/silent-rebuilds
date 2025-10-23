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

git fetch --no-tags --depth=1 origin "${BASE_REF}" >/dev/null 2>&1 || true

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
  grype "${ref}" -o json --fail-on none -q 2>/dev/null || echo ""
}

severity_counts() {
  local payload="${1:-}"
  if [ -z "${payload}" ]; then
    echo "0 0 0 0 0 0 0"
    return
  fi
  echo "${payload}" | jq -r '[
    (.matches // []) | map(select(.vulnerability.severity == "Critical")) | length,
    (.matches // []) | map(select(.vulnerability.severity == "High")) | length,
    (.matches // []) | map(select(.vulnerability.severity == "Medium")) | length,
    (.matches // []) | map(select(.vulnerability.severity == "Low")) | length,
    (.matches // []) | map(select(.vulnerability.severity == "Negligible")) | length,
    (.matches // []) | map(select(.vulnerability.severity == "Unknown")) | length,
    (.matches // []) | length
  ] | @tsv'
}

while IFS= read -r dockerfile; do
  [ -n "${dockerfile}" ] || continue

  output "### ${dockerfile}"
  output ""

  if ! git cat-file -e "${BASE_REF}:${dockerfile}" >/dev/null 2>&1; then
    output "ℹ️ ${dockerfile} added in this comparison; skipping baseline scan."
    output ""
    continue
  fi

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
      if ! docker pull "${old_ref}" >/dev/null 2>&1; then
        output "❌ Failed to pull \`${old_ref}\`"
        old_ref=""
      fi
    fi

    if [ -n "${new_ref}" ]; then
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

    read -r OLD_CRITICAL OLD_HIGH OLD_MEDIUM OLD_LOW OLD_NEGLIGIBLE OLD_UNKNOWN OLD_TOTAL <<<"$(severity_counts "${old_scan}")"
    read -r NEW_CRITICAL NEW_HIGH NEW_MEDIUM NEW_LOW NEW_NEGLIGIBLE NEW_UNKNOWN NEW_TOTAL <<<"$(severity_counts "${new_scan}")"

    if [ "${OLD_TOTAL}" -eq 0 ] && [ "${NEW_TOTAL}" -eq 0 ]; then
      output "ℹ️ No CVEs detected for either image."
      output ""
      continue
    fi

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
