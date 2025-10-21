# Automating container image updates for "Silent Rebuilds" of tags

Examples of using [Dependabot](https://docs.github.com/en/code-security/dependabot/working-with-dependabot/automating-dependabot-with-github-actions), [Renovate](https://github.com/marketplace/actions/renovate-bot-github-action), and [Chainguard's Digestabot](https://github.com/chainguard-dev/digestabot) in GitHub Actions for container image updates.

We walkthrough this repos examples in a video you can watch by [signing up here (free)](https://learn.bretfisher.com/chainguard-event).

## Goals for this repo's examples of automating image updates

- Better understand the edge cases for how image updates happen and if existing tools cover those edge cases.
- Better understand the side effects of pinning to specific major, minor, patch, or digest versions of container images.
- Better understand how different container registries handle updates for container base OS distros vs application dependency updates.
- Find out if we can accidentally miss important updates by pinning to specific tags or digests.
- Find out if these tools support the same features/limits for Dockerfiles, Compose files, Kubernetes manifests, and Helm charts.

## Tool list

- [Dependabot](https://docs.github.com/en/code-security/dependabot/dependabot-version-updates/configuration-options-for-the-dependabot.yml-file#package-ecosystem) - GitHub's native tool for dependency updates, including Docker images.
- [Renovate](https://docs.renovatebot.com/modules/manager/dockerfile/) - A popular open source dependency update tool with a GitHub Action.
- [Digestabot](https://github.com/chainguard-dev/digestabot) - A newer open source tool from Chainguard focused on keeping container image digests up to date.

## The upstream base image "Silent Rebuilds" problem

Many official container images on Docker Hub and other registries are periodically rebuilt without changing the tag version. This can happen for various reasons, such as security patches to the base OS or updates to underlying dependencies. These silent rebuilds can lead to situations where a container image tagged with the same version has different contents over time, potentially introducing vulnerabilities or bugs without any indication in the tag itself.

For examples of how often this happens, see the [digest-counts](./digest-counts) folder in this repo, which tracks digest changes for popular images like NGINX, Node.js, and Python over several months.

As we try to shorten the time between vulnerability disclosures and patch deployments, silent rebuilds can complicate our efforts. If we're not aware that an image has been silently rebuilt, we might miss critical updates that address newly discovered vulnerabilities.

Also, if we're pinning to specific tags or digests in our deployment manifests, we might inadvertently miss out on important updates if those tags or digests change without humans getting a notification (PRs) when the image is rebuilt.

Here's a newsletter post I wrote on this topic: [Automate Your Way to Zero CVE Images](https://www.bretfisher.com/automate-your-way-to-zero-cve-images/)

## This repo's recommended approach

Container CVE and version updates often have (at least) two goals that can conflict if not managed properly: a) ensure we're using the most secure and up-to-date images, and b) maintain stability and predictability in our deployments.

To balance these goals, this repo recommends the following approach:

1. **Pin to image tags *and* digests**: In your Dockerfiles, Compose files, Kubernetes manifests, and Helm charts, always pin to both the image tag and its corresponding digest. This ensures that you're using a specific, known version of the image while also allowing for updates when the tag is rebuilt.

   Example:
   ```yaml
   image: nginx:1.29.2@sha256:f79cde317d4d172a392978344034eed6dff5728a8e6d7a42f507504c23ecf8b8
   ```

Note: The way container runtimes resolve tags and digests (AFAIK) is that **if both are specified, the tag is effectively ignored** and the digest is used by the machine to pull the image. However, we do need the tag for humans to understand what version it's using. By automating the updates of these two, we can reduce the potential for human error (forgetting to keep the tag and digest in sync).

2. **Use CI/CD automation to provide PRs for updates to tags and digests**: Set up GitHub Actions using Dependabot, Renovate, and/or Digestabot to monitor your container images. Configure these tools to create pull requests whenever a new tag or digest is detected. I generally run these daily.

3. **Ensure your tooling can detect new digests for the same tag**: Test and verify that your chosen tools can detect when a tag has been silently rebuilt and update the digest accordingly. This is crucial for staying up-to-date with security patches.

4. **Also pin digests for each GitHub Action**: In your GitHub Actions workflows, pin its digest rather than (mutable) tag to ensure you're using a specific, known version of the action. This helps maintain consistency and security in your CI/CD pipeline, and *helps* avoid (but doesn't prevent) some attack vectors in your image build workflows (like the S1ngularity GitHub Actions attack). **Only Dependabot currently supports this via GHA automation.**

   Example:
   ```yaml
    steps:
      - uses: actions/checkout@692973e3d937129bcbf40652eb9f2f61becf3332 # v4.1.7
   ```

## Tool feature support matrix

Each of the three tools has different levels of support for the features needed to fully implement the recommended approach above. Here's a summary of their capabilities as of October 2025:

| Feature                                                | Dependabot | Renovate | Digestabot |
|--------------------------------------------------------|------------|----------|------------|
| Pin to both tag and digest in manifests                | Yes        | Yes      | Yes        |
| Detect new digests for the same tag                    | Yes        | Yes      | Yes        |
| Create PRs for tag updates                             | Yes        | Yes      | No         |
| Create PRs for digest updates                          | Yes        | Yes      | Yes        | 
| Update GitHub Actions to pin to digest                 | Yes        | No       | No         |
| Support Dockerfiles                                    | Yes        | Yes      | Yes        |
| Support Docker Compose files                           | Yes        | Yes      | Yes        |
| Support Kubernetes manifests                           | Yes        | Yes      | Yes        |
| Support Helm charts                                    | Yes        | Yes      | Yes        |
| Supports Chainguard Images (cgr.dev)                   | No         | Yes      | Yes        |

- Due to various unsupported features, you'll always need Dependabot for updating GitHub Actions digests.
- You can get away with all image updates in Dependabot or Renovate, but because Dependabot doesn't support Chainguard images, Renovate is preferred if you use those.


## Project task list

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

## Digest tracking methodology

- These tests use the multi-arch manifest, not the platform specific digest
- It's possible that the multi-arch manifest could change even if the platform specific digest does not
- Worst case if we're tracking the multi-arch digest it could change when the image hasn't changed and we redeploy for no reason
- If we tracked the platform specific digest, this image becomes platform-specific and you'd need a Dockerfile-per-platform, which is not ideal

