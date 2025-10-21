# Node.js Docker Hub Image-to-Digest Counts

Shows the number of unique digests observed for each tagged version

## Summary Statistics:

- Total unique digests: 37
- Version range: 23.9.0 → 24.10.0
- Time span: 2025-03-14 - 2025-10-14 (7+ months)
- Most rebuilt version: 23.11.0 (5 digests)
- Same-day rebuilds: 6 instances (0-day intervals)
- Longest gap: 20 days between rebuilds

```txt
NODE_VERSION=23.9.0 on Debian Bookworm (12) - 1 digest
- sha256:c29271c7f2b4788fe9b90a7506d790dc8f2ff46132e1b70e71bf0c0679c8451c [latest] (first seen: 2025-03-14) - C:41 H:170 M:186 L:110
N:676

NODE_VERSION=23.10.0 on Debian Bookworm (12) - 2 digests over 15 days
- sha256:e940261391ab78a883bbcfba448bcbb6d36803053f67017e6e270ef095f213ca [latest] (first seen: 2025-03-17) - C:41 H:170 M:186 L:110
N:676
- sha256:990d0ab35ae15d8a322ee1eeaf4f7cf14e367d3d0ee2f472704b7b3df4c9e7c1 [latest] (+15 days) - C:40 H:161 M:172 L:102 N:676

NODE_VERSION=23.11.0 on Debian Bookworm (12) - 5 digests over 27 days
- sha256:047d633b358c33f900110efff70b4f1c73d066dec92dd6941c42d26889f69a0e [latest] (first seen: 2025-04-08) - C:40 H:161 M:172 L:102
N:676
- sha256:73da8b4109487f501fcb5c388fdbbe9d38634fed1349fd16b2a46a2d9435ac37 [latest] (+0 days - same day) - C:40 H:154 M:170 L:102 N:676
- sha256:c5bfe90b30e795ec57bcc0040065ca6f284af84a1dafd22a207bd6b48c39ce01 [latest] (+20 days) - C:40 H:154 M:170 L:102 N:676
- sha256:42cb7b259ff53bf6012a5e68a6d00f9f9a70857be829059e355ffff1feaaa48b [latest] (+0 days - same day) - C:40 H:150 M:170 L:102 N:676
- sha256:ee8a0bc5bbaece0c538c76e7c20fde6d4db319bbd5d4e423940999f16da89aa1 [latest] (+5 days) - C:40 H:150 M:170 L:102 N:676

NODE_VERSION=24.0.0 on Debian Bookworm (12) - 1 digest
- sha256:34bb77a39088f2d52fca6b3c965269da281d3b845f5ea06851109547e488bae3 [latest] (first seen: 2025-05-08) - C:40 H:151 M:170 L:102
N:676

NODE_VERSION=24.0.1 on Debian Bookworm (12) - 2 digests over 5 days
- sha256:c26190f250a508b505d81cdeff5a20e4a15f74a265c3c57a7df51bd40cf1f67a [latest] (first seen: 2025-05-09) - C:40 H:151 M:170 L:102
N:676
- sha256:149a0b6925212aa032160fe556ea5c10963ccfbe51f4af154ce50e39783bde00 [latest] (+5 days) - C:40 H:151 M:170 L:102 N:676

NODE_VERSION=24.0.2 on Debian Bookworm (12) - 2 digests over 3 days
- sha256:37c7b4cd8867313fc17ba76c1a6676414c61e2aac113694072bb8e3ef6d0a4c8 [latest] (first seen: 2025-05-22) - C:40 H:150 M:170 L:102
N:676
- sha256:85150f7c8d9cf5e830f21d34ea52cf0c8d1d0317e8ff1ad73a5b76cca888aa49 [latest] (+3 days) - C:40 H:150 M:148 L:77 N:659

NODE_VERSION=24.1.0 on Debian Bookworm (12) - 2 digests over 10 days
- sha256:ef0861618e36d8e5339583a63e2b1082b7ad9cb59a53529bf7d742afa3e2f06b [latest] (first seen: 2025-05-30) - C:40 H:150 M:148 L:77
N:659
- sha256:c332080545f1de96deb1c407e6fbe9a7bc2be3645e127845fdcce57a7af3cf56 [latest] (+10 days) - C:40 H:150 M:148 L:77 N:659

NODE_VERSION=24.2.0 on Debian Bookworm (12) - 3 digests over 13 days
- sha256:16d3d3862d7442290079b2d073805f7584f466f7e2f69bde164ad5f16b272c67 [latest] (first seen: 2025-06-11) - C:40 H:150 M:148 L:77
N:659
- sha256:0df6857b50b3ecf7e644cf2b859c764fb36afaa9bc1356391ad6a3efadf5d880 [latest] (+0 days - same day) - C:40 H:150 M:146 L:77 N:659
- sha256:d1db2ecd11f417ab2ff4fef891b4d27194c367d101f9b9cd546a26e424e93d31 [latest] (+12 days) - C:40 H:150 M:146 L:77 N:659

NODE_VERSION=24.3.0 on Debian Bookworm (12) - 3 digests over 7 days
- sha256:4b383ce285ed2556aa05a01c76305405a3fecd410af56e2d47a039c59bdc2f04 [latest] (first seen: 2025-07-01) - C:40 H:150 M:146 L:76
N:659
- sha256:8369522c586f6cafcf77e44630e7036e4972933892f8b45e42d9baeb012d521c [latest] (+5 days) - C:38 H:133 M:142 L:71 N:659
- sha256:256a2e7037e745228f7630d578e6c1d327ab4c0a8e401c63d0d4d9dfb3c13465 [latest] (+1 days) - C:38 H:133 M:142 L:71 N:659

NODE_VERSION=24.4.0 on Debian Bookworm (12) - 1 digest
- sha256:e7db48bc35ee8d2e8d1511dfe779d78076966bd101ab074ea2858da8d59efb7f [latest] (first seen: 2025-07-16) - C:38 H:133 M:142 L:71
N:659

NODE_VERSION=24.4.1 on Debian Bookworm (12) - 3 digests over 12 days
- sha256:601f205b7565b569d3b909a873cc9aa9c6f79b5052a9fe09d73e885760237c4c [latest] (first seen: 2025-07-22) - C:38 H:132 M:142 L:71
N:659
- sha256:9b2491ed2930a275b659f2f12ffe20ec525dc3628f2f323adca6cef4eed59742 [latest] (+2 days) - C:38 H:127 M:140 L:71 N:659
- sha256:c7a63f857d6dc9b3780ceb1874544cc22f3e399333c82de2a46de0049e841729 [latest] (+10 days) - C:38 H:127 M:140 L:71 N:659

NODE_VERSION=24.5.0 on Debian Bookworm (12) - 4 digests over 2 days
- sha256:dd5c5e4d0a67471a683116483409d1e46605a79521b000c668cff29df06efd51 [latest] (first seen: 2025-08-12) - C:38 H:127 M:140 L:71
N:659
- sha256:dc4ac80350904c2797058e477a30b6285e9e025f23f139ea8b277c9efe55dd9a [latest] (+0 days - same day) - C:38 H:127 M:140 L:71 N:659
- sha256:71f5f2de0f2d4f9337ed7843bd343e76470c70261d8b98ba93812ec657153509 [latest] (+0 days - same day) - C:38 H:127 M:140 L:71 N:659
- sha256:14fe96d5b60b7fe5ac5eeed9e5866a23412cb8503d8a2fd215f6a923cca6de58 [latest] (+1 days) - C:38 H:127 M:140 L:71 N:659

NODE_VERSION=24.6.0 on Debian Bookworm (12) - 1 digest
- sha256:d2b6b5aedb5b729f68ee1129e0f5a5d4713d93f82448249e82241876d8e8d86e [latest] (first seen: 2025-08-28) - C:38 H:127 M:140 L:71
N:659

NODE_VERSION=24.7.0 on Debian Bookworm (12) - 3 digests over 2 days
- sha256:701c8a634cb3ddbc1dc9584725937619716882525356f0989f11816ba3747a22 [latest] (first seen: 2025-09-08) - C:38 H:127 M:140 L:71
N:659
- sha256:9f756c50a38aea7d680761fbcf254693f131a5c6f73692c543d992cb93b93c4f [latest] (+0 days - same day) - C:32 H:107 M:85 L:62 N:659
- sha256:12affdc046489e63450191d69b5a093302f487eb140a2075022475f94dc39037 [latest] (+1 days) - C:32 H:107 M:85 L:62 N:659

NODE_VERSION=24.8.0 on Debian Bookworm (12) - 1 digest
- sha256:82a1d74c5988b72e839ac01c5bf0f7879a8ffd14ae40d7008016bca6ae12852b [latest] (first seen: 2025-09-26) - C:32 H:107 M:85 L:62
N:659

NODE_VERSION=24.9.0 on Debian Bookworm (12) - 2 digests over 7 days
- sha256:a2ed436bacdcc9dd543202a327bbce2519c43e3755a41a186f8f51c037ef3342 [latest] (first seen: 2025-10-01) - C:32 H:107 M:85 L:62
N:659
- sha256:4e87fa2c1aa4a31edfa4092cc50428e86bf129e5bb528e2b3bbc8661e2038339 [latest] (+7 days) - C:6 H:42 M:85 L:49 N:659

NODE_VERSION=24.10.0 on Debian Bookworm (12) - 1 digest
- sha256:377f1c17906eb5a145c34000247faa486bece16386b77eedd5a236335025c2ef [latest] (first seen: 2025-10-14) - C:6 H:42 M:85 L:49 N:659
```