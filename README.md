# Silent Rebuilds

> Detecting every upstream image change. Then creating PRs of updated tag + digest pinning

![Silent Rebuilds](images/silent-rebuilds.png)

This repo gives examples of using [GitHub Dependabot](https://docs.github.com/en/code-security/dependabot/working-with-dependabot/automating-dependabot-with-github-actions), [Mend Renovate](https://github.com/marketplace/actions/renovate-bot-github-action), and [Chainguard Digestabot](https://github.com/chainguard-dev/digestabot) in GitHub Actions for container image updates via tag-watching and digest-watching of upstream registries.

Thanks to [Chainguard](https://www.chainguard.dev/) for sponsoring the creation of this repository. I worked with [@ericsmalling](https://github.com/ericsmalling) to walkthrough this repos examples in a video you can get by [signing up here (free)](https://learn.bretfisher.com/chainguard-event).

## Goals for this repo's examples of automating image updates

- Better understand the edge cases for how upstream registry changes are detected and how tools update image tags and digests.
- Better understand the side effects of pinning to specific major, minor, patch, and/or digest versions of container images.
- Find out if we can accidentally miss important updates by pinning to specific tags or digests without properly configured tools.
- Find out if these tools support the same features/limits for detecting upstream changes and creating PRs for updating Dockerfiles, Compose files, Kubernetes manifests, and Helm charts.

## The upstream base image "Silent Rebuilds" problem

Many official container images on Docker Hub and other registries are periodically rebuilt without changing the tag version. This can happen for various reasons, such as security patches to the base OS dependencies, updates to the metadata, or even no change at all (A repo change happened, but didn't result in image file changes). Regardless of the reason, these "silent rebuilds" can lead to situations where a container image tagged with the same version has different contents over time. We assume these rebuilds should trigger a downstream PR for deploying the new images, so the first step is getting tools in place to watch for changing digests and notifying humans (via PRs) of new upstream images.

For examples of how often this happens, see the [digest-counts](./digest-counts) folder in this repo, which tracks digest changes for popular images like NGINX, Node.js, and Python over several months.

As we try to shorten the time between vulnerability disclosures and patch deployments, silent rebuilds can complicate our efforts. If we're not aware that an image has been silently rebuilt, we might miss critical updates that address newly discovered vulnerabilities.

Also, if we're pinning to specific tags or digests in our deployment manifests, we might inadvertently miss out on important updates if those tags or digests change without humans getting a notification (PRs) when the image is rebuilt.

Here's a newsletter post I wrote on this topic: [Automate Your Way to Zero CVE Images](https://www.bretfisher.com/automate-your-way-to-zero-cve-images/)

## Tool list

- [Dependabot](https://docs.github.com/en/code-security/dependabot/dependabot-version-updates/configuration-options-for-the-dependabot.yml-file#package-ecosystem) - GitHub's native tool for dependency updates, including Docker images.
- [Renovate](https://docs.renovatebot.com/modules/manager/dockerfile/) - A popular open source dependency update tool.
  - [Renovate GitHub Action](https://github.com/marketplace/actions/renovate-bot-github-action) - Official GitHub Action for running Renovate.
- [Digestabot GitHub Action](https://github.com/chainguard-dev/digestabot) - A newer open source tool from Chainguard focused on keeping container image digests up to date.
- [Grype](https://github.com/anchore/grype) - A vulnerability scanner for container images used in the CVE scanning examples.
  - [Grype GitHub Action](https://github.com/marketplace/actions/anchore-container-scan) - Official GitHub Action for running Grype scans.

## This repo's recommended approach

Container CVE and version updates often have (at least) two goals that can conflict if not managed properly: a) ensure we're using the most secure and up-to-date images, and b) maintain stability and predictability in our deployments.

To balance these goals, this repo recommends the following approach:

1. **Pin to image tags *and* digests**: In your Dockerfiles, Compose files, Kubernetes manifests, and Helm charts, always pin to both the image tag and its corresponding digest. This ensures that you're using a specific, known version of the image while also allowing for updates when the tag is rebuilt.

   Example:
   ```yaml
   image: nginx:1.29.2@sha256:f79cde317d4d172a392978344034eed6dff5728a8e6d7a42f507504c23ecf8b8
   ```

   Note: The way container runtimes resolve tags and digests (AFAIK) is that **if both are specified, the tag is effectively ignored** and the digest is used by the machine to pull the image. However, we do need the tag for humans to understand what version it's using. By automating the updates of these two, we can reduce the potential for human error (forgetting to keep the tag and digest in sync).

2. **Use CI/CD automation to provide PRs for updates to tags and digests**: Set up GitHub Actions using Dependabot, Renovate, and/or Digestabot to monitor your container images. Configure these tools to create pull requests whenever a new tag or digest is detected. I generally set GHA cron to run these daily.

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
| Create PRs for tag updates                             | Yes        | Yes      | **No**     |
| Create PRs for digest updates                          | Yes        | Yes      | Yes        | 
| Update GitHub Actions to pin to digest                 | Yes        | **No**   | No         |
| Support Dockerfiles                                    | Yes        | Yes      | Yes        |
| Support Docker Compose files                           | Yes        | Yes      | Yes        |
| Support Kubernetes manifests                           | Yes        | Yes      | Yes        |
| Support Helm charts                                    | Yes        | Yes      | Yes        |
| Supports Chainguard Images (cgr.dev)                   | **No**     | Yes      | Yes        |

- Due to various unsupported features, you'll always need Dependabot for updating GitHub Actions digests. Other tools only support updating the tag (which is mutable).
- You can get away with all image updates in Dependabot or Renovate, but because Dependabot doesn't support Chainguard's image registry, Renovate is preferred if you use cgr.dev images.

## Project task list

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

