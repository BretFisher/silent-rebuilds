# Python Docker Hub Image-to-Digest Counts

Shows the number of unique digests observed for each tagged version

## Summary Statistics:

- Total unique digests: 29
- Version range: 3.13.3 → 3.13.9
- Time span: 2025-04-10 - 2025-10-18 (6+ months)
- Base distro transition: Debian Bookworm (12) → Debian Trixie (13) at version 3.13.6 (2025-08-13)
- Most rebuilt version: 3.13.3 (9 digests)
- Same-day rebuilds: 3 instances (0-day intervals)
- Longest gap: 24 days between rebuilds

```txt
PYTHON_VERSION=3.13.3 on Debian Bookworm (12) - 9 digests over 53 days
- sha256:1f7ef1e8f35bc8629b05f4df943175f2851ba05f4a509f72304ebffde78178ee [3.13] (first seen: 2025-04-10) - C:41 H:161 M:183 L:101
N:699
- sha256:9819e5616923079cc16af4a93d4be92c0c487c6e02fd9027220381f3e125d64a [3.13] (+1 days) - C:41 H:161 M:183 L:101 N:699
- sha256:34dc8eb488136014caf530ec03a3a2403473a92d67a01a26256c365b5b2fc0d4 [3.13] (+17 days) - C:41 H:161 M:183 L:101 N:699
- sha256:884da97271696864c2eca77c6362b1c501196d6377115c81bb9dd8d538033ec3 [3.13] (+5 days) - C:41 H:157 M:183 L:101 N:699
- sha256:3abe339a3bc81ffabcecf9393445594124de6420b3cfddf248c52b1115218f04 [3.13] (+8 days) - C:41 H:157 M:183 L:101 N:699
- sha256:653b0cf8fc50366277a21657209ddd54edd125499d20f3520c6b277eb8c828d3 [3.13] (+3 days) - C:41 H:157 M:183 L:101 N:699
- sha256:e3424acce37cdb1d7f885b2d13c14a550a0b6b96ff8a58d2a08883f3f865fd1e [3.13] (+7 days) - C:41 H:157 M:161 L:76 N:682
- sha256:a4b2b11a9faf847c52ad07f5e0d4f34da59bad9d8589b8f2c476165d94c6b377 [3.13] (+7 days) - C:41 H:157 M:161 L:76 N:682
- sha256:0bc836167214f98aca9c9bca7b4c6dc2c2a77f4a29d5029e6561a14706335102 [3.13] (+2 days) - C:41 H:157 M:161 L:76 N:682

PYTHON_VERSION=3.13.4 on Debian Bookworm (12) - 1 digest
- sha256:eb120d016adcbc8bac194e15826bbb4f1d1569d298d8817bb5049ed5e59f41d9 [3.13] (first seen: 2025-06-08) - C:40 H:154 M:159 L:76 N:682

PYTHON_VERSION=3.13.5 on Debian Bookworm (12) - 5 digests over 52 days
- sha256:5f69d22a88dd4cc4ee1576def19aef48c8faa1b566054c44291183831cbad13b [3.13] (first seen: 2025-06-14) - C:40 H:154 M:157 L:76 N:682
- sha256:a6af772cf98267c48c145928cbeb35bd8e89b610acd70f93e3e8ac3e96c92af8 [3.13] (+24 days) - C:38 H:137 M:153 L:71 N:682
- sha256:28f60ab75da2183870846130cead1f6af30162148d3238348f78f89cf6160b5d [3.13] (+4 days) - C:38 H:137 M:153 L:71 N:682
- sha256:dd82a2be8703eec3824c8c5f693aa9836fb984f72a14b8a32502236d94c0f8cb [3.13] (+12 days) - C:38 H:132 M:151 L:71 N:682
- sha256:4ea77121eab13d9e71f2783d7505f5655b25bb7b2c263e8020aae3b555dbc0b2 [3.13] (+11 days) - C:38 H:132 M:151 L:71 N:682

PYTHON_VERSION=3.13.6 on Debian Bookworm (12) - 1 digest
- sha256:68d0775234842868248bfe185eece56e725d3cb195f511a21233d0f564dee501 [3.13] (first seen: 2025-08-11) - C:38 H:131 M:150 L:71 N:682

PYTHON_VERSION=3.13.6 on Debian Trixie (13) - 2 digests over 1 days
- sha256:b3e52dd22ff14e2e6dcbc0f028f743dc037c74258e9af3d0a2fd8e6617d94d72 [3.13] (first seen: 2025-08-13) - C:33 H:115 M:94 L:91 N:611
- sha256:50cbf8e58ca53a806b99250b1ba2d16c19433e8c42e7eb4ac4ea924b095e280b [3.13] (+1 days) - C:33 H:115 M:94 L:91 N:611

PYTHON_VERSION=3.13.7 on Debian Trixie (13) - 9 digests over 51 days
- sha256:3b2f1b9c9948e9dc96e1a2f4668ba9870ff43ab834f91155697476142b3bc299 [3.13] (first seen: 2025-08-16) - C:33 H:115 M:94 L:91 N:611
- sha256:18634e45b29c0dd1a9a3a3d0781f9f8a221fe32ee7a853db01e9120c710ef535 [3.13] (+23 days) - C:33 H:115 M:94 L:91 N:611
- sha256:b41c4877ed4d8a4d6e04f0b341b84f2bd384325816975b1ebf7a2f2e02b7acaa [3.13] (+0 days - same day) - C:13 H:75 M:92 L:37 N:611
- sha256:3efe6d5302c6131cbfbdb089c0dff7cf5a85ae5675c025df8488da10010acced [3.13] (+0 days - same day) - C:13 H:75 M:92 L:37 N:611
- sha256:c1dab8c06c4fe756fd4316f33a2ba4497be09fa106d2cd9782c33ee411193f9c [3.13] (+3 days) - C:13 H:75 M:92 L:37 N:611
- sha256:2deb0891ec3f643b1d342f04cc22154e6b6a76b41044791b537093fae00b6884 [3.13] (+9 days) - C:13 H:75 M:92 L:37 N:611
- sha256:081e7d0f7e520a653648602d10dcf11a832c8480b98698795d5fe8f456bbba4d [3.13] (+9 days) - C:13 H:75 M:92 L:37 N:611
- sha256:b9a26ed0117af0612457ffdbfb8973f2b5d88f3670d7e353ed7db0fda9e177c8 [3.13] (+0 days - same day) - C:0 H:23 M:66 L:37 N:611
- sha256:0c745292b7b34dcdd6050527907d78c39363dc45ad6afc6d107c454b93cebca1 [3.13] (+4 days) - C:0 H:23 M:66 L:37 N:611

PYTHON_VERSION=3.13.8 on Debian Trixie (13) - 1 digest
- sha256:4889af0e45f04b7c5dd741421a1280919499d38d3125d714b69fa86b23b1052a [3.13] (first seen: 2025-10-12) - C:0 H:23 M:66 L:37 N:611

PYTHON_VERSION=3.13.9 on Debian Trixie (13) - 1 digest
- sha256:75ba988a6cd84bb048a05fafae370a2f4600344b844d53ef90730d3518802f67 [3.13] (first seen: 2025-10-18) - C:0 H:23 M:66 L:37 N:611
```