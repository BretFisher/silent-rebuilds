# silent-rebuilds
Testing dependabot, digestabot, and renovate GitHub Actions for container image updates

## Goals for this repo's testing of image updates

- Better understand the edge cases for how image updates happen and if existing tools cover those edge cases.
- Better understand the side effects of pinning to specific major, minor, patch, or digest versions of container images.
- Better understand how different container registries handle updates for container base OS distros vs application depency updates.
- Find out if we can accidently miss important updates by pinning to specific tags or digests.
- Find out if these tools support the same features/limits for Dockerfiles, Compose files, Kubernetes manifests, and Helm charts.

## Tool list

- [Dependabot](https://docs.github.com/en/code-security/dependabot/dependabot-version-updates/configuration-options-for-the-dependabot.yml-file#package-ecosystem)
- [Renovate](https://docs.renovatebot.com/modules/manager/dockerfile/)
- [Digestabot](https://github.com/chainguard-dev/digestabot)

## Official image registries for popular open source languages and apps

- Docker Hub Official Images (e.g., node, python, nginx, redis, postgres)
- Chainguard Images (e.g., node, python, nginx, redis, postgres)
- GitHub Container Registry (e.g., ghcr.io/node, ghcr.io/python,
    ghcr.io/nginx, ghcr.io/redis, ghcr.io/postgres)
- Google Container Registry (e.g., gcr.io/google-appengine/nodejs, gcr.io/google-appengine/python, gcr.io/google-containers/nginx, gcr.io/google-containers/redis, gcr.io/cloudsql-docker/gce-proxy:1.33.1)
- Amazon ECR Public Gallery (e.g., public.ecr.aws/docker/library/node, public.ecr.aws/docker/library/python, public.ecr.aws/nginx/nginx, public.ecr.aws/redis/redis, public.ecr.aws/rds/rds-postgres)
- Quay.io (e.g., quay.io/nodejs/node, quay.io/python/python, quay.io/nginx/nginx, quay.io/redis/redis, quay.io/postgres/postgres)

## Things to test

Create a list of GitHub Actions in this repo that use Dependabot, Renovate, and Digestabot to test the following questions. Ideally we also have scripts that can use these tools in the same way locally.

- [ ] Can Dependabot or Renovate pin a container image to a specific digest?
- [ ] Can Dependabot or Renovate update a container image to a new digest when the tag is updated?
- [ ] Will Dependabot or Renovate create a pull request when only the digest changes but the tag remains the same?
- [ ] Can Dependabot or Renovate detect that node:24.0 has been updated to 24.0.1?
- [ ] Can Digestabot work alongside Dependabot or Renovate to ensure we've always got the latest digest for the tag we've pinned to, yet ensure we are always pinning to a digest?
- [ ] Once we understand the limits of these three tools, can we test against Node:24 for minor and patch updates?
    - [ ] Pin to node:24
    - [ ] Pin to node:24.0
    - [ ] Pin to node:24.0.0
    - [ ] Pin to node:24@digest
- [ ] Study how different registries handle official image updates.
    - Docker Hub's Node image never gets updated with base fixes after the app versions inital release.
    - Chainguard Images rebuild nightly to see if any base OS updates are available. They update to a new digest if upstream OS updates are available.
    - [ ] How does GitHub Container Registry compare?
    - [ ] How does Google Container Registry compare?
    - [ ] How does Amazon ECR Public Gallery compare?

## Digest tracking methoadology

- These tests use the multi-arch manifest, not the platform specific digest
- It's possible that the multi-arch manifest could change even if the platform specific digest does not
- Worst case if we're tracking the multi-arch digest it could change when the image hasn't changed and we redeploy for no reason
- If we tracked the platform specific digest, this image becomes platform-specific and you'd need a Dockerfile-per-platform, which is not ideal

