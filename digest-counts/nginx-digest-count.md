# NGINX Docker Hub Image-to-Digest Counts

Shows the number of unique digests observed for each tagged version

## Summary Statistics:

- Total unique digests: 20
- Version range: 1.27.4 → 1.29.2
- Time span: 2025-04-08 - 2025-10-20 (6+ months)
- Base distro transition: Debian Bookworm (12) → Debian Trixie (13) at version 1.29.2 (2025-10-08)
- Most rebuilt version: 1.27.5 (6 digests)
- Same-day rebuilds: 3 instances (0-day intervals)
- Longest gap: 25 days between rebuilds

```txt
NGINX_VERSION=1.27.4 on Debian Bookworm (12) - 2 digests over 8 days
- sha256:124b44bfc9ccd1f3cedf4b592d4d1e8bddb78b51ec2ed5056c52d3692baebc19 [latest] (first seen: 2025-04-08) - C:6 H:37 M:47 L:13 N:92
- sha256:09369da6b10306312cd908661320086bf87fbae1b6b0c49a1f50ba531fef2eab [latest] (+8 days) - C:6 H:34 M:47 L:13 N:92

NGINX_VERSION=1.27.5 on Debian Bookworm (12) - 6 digests over 57 days
- sha256:5ed8fcc66f4ed123c1b2560ed708dc148755b6e4cbd8b943fab094f2c6bfa91e [latest] (first seen: 2025-04-28) - C:6 H:34 M:47 L:13 N:92
- sha256:9aca031fc06c3c5eaefef2920321f0d89d0242083fdd6bc7a5c38e80c3433d02 [latest] (+1 days) - C:6 H:33 M:47 L:13 N:92
- sha256:c15da6c91de8d2f436196f3a768483ad32c258ed4e1beb3d367a27ed67253e66 [latest] (+22 days) - C:6 H:33 M:47 L:13 N:92
- sha256:59b59d308832ec4428da454bda93f595a00463596fd6385b8b0e6e388bce955a [latest] (+0 days - same day) - C:5 H:33 M:38 L:11 N:89
- sha256:fb39280b7b9eba5727c884a3c7810002e69e8f961cc373b89c92f14961d903a0 [latest] (+19 days) - C:5 H:33 M:38 L:11 N:89
- sha256:6784fb0834aa7dbbe12e3d7471e69c290df3e6ba810dc38b34ae33d3c1c05f7d [latest] (+13 days) - C:4 H:33 M:35 L:11 N:89

NGINX_VERSION=1.29.0 on Debian Bookworm (12) - 6 digests over 42 days
- sha256:dc53c8f25a10f9109190ed5b59bda2d707a3bde0e45857ce9e1efaa32ff9cbc1 [latest] (first seen: 2025-07-01) - C:4 H:33 M:35 L:11 N:89
- sha256:93230cd54060f497430c7a120e2347894846a81b6a5dd2110f7362c5423b4abc [latest] (+13 days) - C:3 H:25 M:33 L:11 N:89
- sha256:f5c017fb33c6db484545793ffb67db51cdd7daebee472104612f73a85063f889 [latest] (+6 days) - C:3 H:25 M:33 L:11 N:89
- sha256:d8ec2a0b8d30642667482f37385c64879e6c3f32d2714c8322cd9154b60cb7e7 [latest] (+0 days - same day) - C:3 H:25 M:33 L:11 N:89
- sha256:84ec966e61a8c7846f509da7eb081c55c1d56817448728924a87ab32f12a72fb [latest] (+21 days) - C:3 H:23 M:31 L:11 N:89
- sha256:c424bd04bb9d3dd358bfb73557283e38e00fa4ceee983c92be2a8ea4dac923df [latest] (+0 days - same day) - C:3 H:23 M:31 L:11 N:89

NGINX_VERSION=1.29.1 on Debian Bookworm (12) - 4 digests over 54 days
- sha256:7ad64835251abfd777c0058f472b5e107d6eb3ef0d2e9077a44623a0b51f7dc3 [latest] (first seen: 2025-08-14) - C:3 H:23 M:31 L:11 N:89
- sha256:33e0bbc7ca9ecf108140af6288c7c9d1ecc77548cbfd3952fd8466a75edefe57 [latest] (+25 days) - C:3 H:23 M:31 L:11 N:89
- sha256:d5f28ef21aabddd098f3dbc21fe5b7a7d7a184720bc07da0b6c9b9820e97f25e [latest] (+20 days) - C:1 H:16 M:22 L:10 N:89
- sha256:8adbdcb969e2676478ee2c7ad333956f0c8e0e4c5a7463f4611d7a2e7a7ff5dc [latest] (+7 days) - C:1 H:16 M:22 L:10 N:89

NGINX_VERSION=1.29.2 on Debian Trixie (13) - 2 digests over 12 days
- sha256:f79cde317d4d172a392978344034eed6dff5728a8e6d7a42f507504c23ecf8b8 [latest] (first seen: 2025-10-08) - C:0 H:5 M:7 L:10 N:70
- sha256:3b7732505933ca591ce4a6d860cb713ad96a3176b82f7979a8dfa9973486a0d6 [latest] (+12 days) - C:0 H:5 M:7 L:10 N:70
```