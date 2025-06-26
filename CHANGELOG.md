# Changelog

# [2.9.0](https://github.com/saltstack-formulas/nginx-formula/compare/v2.8.1...v2.9.0) (2025-06-26)


### Continuous Integration

* update `pre-commit` configuration inc. for pre-commit.ci [skip ci] ([9f83975](https://github.com/saltstack-formulas/nginx-formula/commit/9f83975053707988494c55389a610cf3c20bcdee))
* **kitchen+gitlab:** update for new pre-salted images [skip ci] ([2df772e](https://github.com/saltstack-formulas/nginx-formula/commit/2df772ee67e8ec5a047ad90e169fc192ddfa90c0))
* **vagrant:** use `linked_clone` at all times (inc. CI) [skip ci] ([6f2b7b1](https://github.com/saltstack-formulas/nginx-formula/commit/6f2b7b100c0ce196769e75fa4058d3276923173d))


### Features

* **opensuse:** optional openSUSE devel repository ([094bde5](https://github.com/saltstack-formulas/nginx-formula/commit/094bde5082fbafb0ed8fb25acc4eb315ab179d15))


### Tests

* **system.rb:** add support for `mac_os_x` [skip ci] ([8222541](https://github.com/saltstack-formulas/nginx-formula/commit/82225416ef625e87c5109991ae7b7160bfbd834f))

## [2.8.1](https://github.com/saltstack-formulas/nginx-formula/compare/v2.8.0...v2.8.1) (2022-03-02)


### Bug Fixes

* **debian:** avoid adding repositories entries multiple times ([d1d3e55](https://github.com/saltstack-formulas/nginx-formula/commit/d1d3e552adf3bc17265ffcc1c27920d4b9a09c6d)), closes [/github.com/saltstack/salt/issues/59785#issuecomment-826590482](https://github.com//github.com/saltstack/salt/issues/59785/issues/issuecomment-826590482)


### Continuous Integration

* update linters to latest versions [skip ci] ([512fe00](https://github.com/saltstack-formulas/nginx-formula/commit/512fe00a069f2fcabed119c36f9444c2a65e179c))


### Tests

* **repository:** use `system.platform[:codename]` [skip ci] ([0e51694](https://github.com/saltstack-formulas/nginx-formula/commit/0e51694c2a59b975be0fe4972c525b73f556a6db))
* **system:** add `build_platform_codename` [skip ci] ([5f1a289](https://github.com/saltstack-formulas/nginx-formula/commit/5f1a289f11cdcbb2dac6021109cfc390068134d4))

# [2.8.0](https://github.com/saltstack-formulas/nginx-formula/compare/v2.7.5...v2.8.0) (2022-02-03)


### Code Refactoring

* **pkgs:** readbility ([b76e8cc](https://github.com/saltstack-formulas/nginx-formula/commit/b76e8cc6640943d97bc778948555ae3f45a71552))


### Continuous Integration

* **kitchen+gitlab:** update for new pre-salted images [skip ci] ([7fcb960](https://github.com/saltstack-formulas/nginx-formula/commit/7fcb9608cd838469e7c1faf2126ea8d5673d0481))


### Features

* **debian:** use keyrings instead of key_ids ([037c13a](https://github.com/saltstack-formulas/nginx-formula/commit/037c13a674d9e2850a808bcb0fe8600e4ec8b177))


### Reverts

* **pkg:** use grains.osfinger in a format suitable for all platforms ([8fee9f0](https://github.com/saltstack-formulas/nginx-formula/commit/8fee9f05bd86c549a050a5b4c555fa0d532493d3))


### Styles

* **map.jinja:** remove empty line ([ae52641](https://github.com/saltstack-formulas/nginx-formula/commit/ae52641cfc87ad576f22f0675eff436ebccf3d34))


### Tests

* **repository:** favor `platform` over `os` ([c16ecf8](https://github.com/saltstack-formulas/nginx-formula/commit/c16ecf82f52b0236a8b54b5ad984c08902b79534))

## [2.7.5](https://github.com/saltstack-formulas/nginx-formula/compare/v2.7.4...v2.7.5) (2022-02-02)


### Bug Fixes

* **snippets:** make sure they're deployed before being used ([9dfc1c1](https://github.com/saltstack-formulas/nginx-formula/commit/9dfc1c1b2f4a0cd17221b303c95af1d7a9aba781))


### Continuous Integration

* **3003.1:** update inc. AlmaLinux, Rocky & `rst-lint` [skip ci] ([6a42a9b](https://github.com/saltstack-formulas/nginx-formula/commit/6a42a9bdf84e764cb4b3313ad2b6d95688517dec))
* **freebsd:** update with latest pre-salted Vagrant boxes [skip ci] ([860fabe](https://github.com/saltstack-formulas/nginx-formula/commit/860fabe327cfa9512152b0f278897311f35449bf))
* **gemfile:** allow rubygems proxy to be provided as an env var [skip ci] ([1557473](https://github.com/saltstack-formulas/nginx-formula/commit/155747346c5b0fe7e1af5214734581e992832b45))
* **gemfile+lock:** use `ssf` customised `inspec` repo [skip ci] ([a11da83](https://github.com/saltstack-formulas/nginx-formula/commit/a11da83d03fad1c50a93ba06c1c5af21f1c79e7a))
* **gitlab-ci:** enable instance after upstream issue resolved [skip ci] ([79499e8](https://github.com/saltstack-formulas/nginx-formula/commit/79499e841be74162dd5ec869de267366b6048af1))
* **kitchen:** move `provisioner` block & update `run_command` [skip ci] ([6b65017](https://github.com/saltstack-formulas/nginx-formula/commit/6b650177aaa9800151f2e7f628551856f0c28c54))
* **kitchen+ci:** update with `3004` pre-salted images/boxes [skip ci] ([30f87cc](https://github.com/saltstack-formulas/nginx-formula/commit/30f87cc84b2991c7f0ed1f0066f9241a3754e8df))
* **kitchen+ci:** update with latest `3003.2` pre-salted images [skip ci] ([70a1f31](https://github.com/saltstack-formulas/nginx-formula/commit/70a1f3135ccfde09f6016a46eee3fc55b2ca9840))
* **kitchen+ci:** update with latest CVE pre-salted images [skip ci] ([e041418](https://github.com/saltstack-formulas/nginx-formula/commit/e0414181a724076176cb37f6402f013f4e498109))
* **vagrant:** replace FreeBSD 12.2 with 12.3 [skip ci] ([7deb74f](https://github.com/saltstack-formulas/nginx-formula/commit/7deb74fdbccad7e8590b9ddf7d0630e9a2ba56e1))
* add Debian 11 Bullseye & update `yamllint` configuration [skip ci] ([fa8a5db](https://github.com/saltstack-formulas/nginx-formula/commit/fa8a5db5079b1e41eeac5d4ee25c06d976a24f3e))
* **kitchen+gitlab:** remove Ubuntu 16.04 & Fedora 32 (EOL) [skip ci] ([d15f3de](https://github.com/saltstack-formulas/nginx-formula/commit/d15f3decb3fb1d8d1d04934c8d909913380d53f1))

## [2.7.4](https://github.com/saltstack-formulas/nginx-formula/compare/v2.7.3...v2.7.4) (2021-06-15)


### Bug Fixes

* **servers:** include main config file watch in extend ([00387e7](https://github.com/saltstack-formulas/nginx-formula/commit/00387e7cbd90ceb5496df5cf9bce8f7dae25b056))

## [2.7.3](https://github.com/saltstack-formulas/nginx-formula/compare/v2.7.2...v2.7.3) (2021-06-14)


### Tests

* **snippets:** add tests for snippets includes ([1c83b6d](https://github.com/saltstack-formulas/nginx-formula/commit/1c83b6d5fa93079476ca9e8baa1ccd9d44e5237f)), closes [#275](https://github.com/saltstack-formulas/nginx-formula/issues/275) [#274](https://github.com/saltstack-formulas/nginx-formula/issues/274)

## [2.7.2](https://github.com/saltstack-formulas/nginx-formula/compare/v2.7.1...v2.7.2) (2021-06-14)


### Bug Fixes

* **certificates:** ensure `openssl` installed before `cmd.run` ([0cd7c7b](https://github.com/saltstack-formulas/nginx-formula/commit/0cd7c7b20528ce9fbd4f8991a365415a3093546d)), closes [/gitlab.com/saltstack-formulas/nginx-formula/-/jobs/1345325819#L2830](https://github.com//gitlab.com/saltstack-formulas/nginx-formula/-/jobs/1345325819/issues/L2830)
* **snippets:** ignore servers or snippets when undefined ([6cb486d](https://github.com/saltstack-formulas/nginx-formula/commit/6cb486dbd290c91bbdbf00fd0061efaedbef4dea)), closes [#274](https://github.com/saltstack-formulas/nginx-formula/issues/274)

## [2.7.1](https://github.com/saltstack-formulas/nginx-formula/compare/v2.7.0...v2.7.1) (2021-05-12)


### Bug Fixes

* **servers:** wrong conditional specification ([494b2fb](https://github.com/saltstack-formulas/nginx-formula/commit/494b2fbea490fded02cecd4d3e3e0372476548fb))


### Continuous Integration

* add `arch-master` to matrix and update `.travis.yml` [skip ci] ([4697152](https://github.com/saltstack-formulas/nginx-formula/commit/46971528d7a7e23241564da146ee8d28b7d2eecc))

# [2.7.0](https://github.com/saltstack-formulas/nginx-formula/compare/v2.6.3...v2.7.0) (2021-04-28)


### Continuous Integration

* **kitchen+gitlab:** adjust matrix to add `3003` [skip ci] ([46faf4e](https://github.com/saltstack-formulas/nginx-formula/commit/46faf4e24b39f7d4fd138126dbe5eb6a06eb5b67))
* **vagrant:** add FreeBSD 13.0 [skip ci] ([b41062e](https://github.com/saltstack-formulas/nginx-formula/commit/b41062e3b19c4c109198bd95c53158d871bbff85))
* **vagrant:** use pre-salted boxes & conditional local settings [skip ci] ([b9e9cd3](https://github.com/saltstack-formulas/nginx-formula/commit/b9e9cd38e6d29b7eb4cd8ae74a1bdf901959dee3))


### Documentation

* **readme:** add `Testing with Vagrant` section [skip ci] ([5727848](https://github.com/saltstack-formulas/nginx-formula/commit/57278481de489441a5c04aee544962212e91c5af))


### Features

* **servers_config:** add require statement to manage dependencies ([622d22f](https://github.com/saltstack-formulas/nginx-formula/commit/622d22f9711085aeca19f3907e22e87c6b21b8d0))


### Tests

* **requires:** verify dependencies in vhosts ([6478143](https://github.com/saltstack-formulas/nginx-formula/commit/64781431b9187d392f56ce5461c3b1a9c2944f90))

## [2.6.3](https://github.com/saltstack-formulas/nginx-formula/compare/v2.6.2...v2.6.3) (2021-04-03)


### Bug Fixes

* **freebsd:** add `openssl` pkg and update all `default` tests ([4cd351a](https://github.com/saltstack-formulas/nginx-formula/commit/4cd351adbc184b938b0d0cf587419bab5b39a7d3))


### Continuous Integration

* enable Vagrant-based testing using GitHub Actions ([c79ce9a](https://github.com/saltstack-formulas/nginx-formula/commit/c79ce9a9ae30e889ab925bb0398008b434bc9b0a))

## [2.6.2](https://github.com/saltstack-formulas/nginx-formula/compare/v2.6.1...v2.6.2) (2021-03-30)


### Bug Fixes

* **servers_config:** fixup 05994e1 ([c03729a](https://github.com/saltstack-formulas/nginx-formula/commit/c03729ae326876a20cb22c346f9d4cd96418af9a))

## [2.6.1](https://github.com/saltstack-formulas/nginx-formula/compare/v2.6.0...v2.6.1) (2021-03-29)


### Bug Fixes

* **servers_config:** remove service depedency ([05994e1](https://github.com/saltstack-formulas/nginx-formula/commit/05994e1b174ccdf3ff4a444f81314ad925fa478d))


### Code Refactoring

* **servers_config:** remove unused loop ([3825557](https://github.com/saltstack-formulas/nginx-formula/commit/3825557070a18db4828cc634dd036a428f8a9836))


### Continuous Integration

* **kitchen+ci:** include `passenger` suite [skip ci] ([0bbe686](https://github.com/saltstack-formulas/nginx-formula/commit/0bbe68619fdf3791e6202ce3f17ca03efc4441c1))


### Tests

* standardise use of `share` suite & `_mapdata` state [skip ci] ([8ea3c82](https://github.com/saltstack-formulas/nginx-formula/commit/8ea3c82be3fccb2bad8bac566f210454549d141e))

# [2.6.0](https://github.com/saltstack-formulas/nginx-formula/compare/v2.5.0...v2.6.0) (2021-03-11)


### Bug Fixes

* **passenger:** various fixes ([7271c9d](https://github.com/saltstack-formulas/nginx-formula/commit/7271c9d16c8218244ae5ef0b188b7f9f4a414074))
* **pkg:** add inline EPEL repo configuration for Amazon Linux 2 ([ae6375c](https://github.com/saltstack-formulas/nginx-formula/commit/ae6375ccccd56a506ee28babbeabf351112a06de))


### Continuous Integration

* **gemfile+lock:** use `ssf` customised `kitchen-docker` repo [skip ci] ([123d13e](https://github.com/saltstack-formulas/nginx-formula/commit/123d13e2f483c203cbfc1366b36a30e1732603e1))
* **kitchen+ci:** make rubocop happy [skip ci] ([eedfc56](https://github.com/saltstack-formulas/nginx-formula/commit/eedfc56b41b673e196029274048670e89e55a694))
* **kitchen+ci:** use latest pre-salted images (after CVE) [skip ci] ([63d32a4](https://github.com/saltstack-formulas/nginx-formula/commit/63d32a40b13ca2c77bb83cceba620218617aab6a))
* **kitchen+gitlab-ci:** use latest pre-salted images [skip ci] ([b4411c6](https://github.com/saltstack-formulas/nginx-formula/commit/b4411c61d3352ecb9775197f991f5f33996730dc))
* **pre-commit:** update hook for `rubocop` [skip ci] ([2a23743](https://github.com/saltstack-formulas/nginx-formula/commit/2a23743fca8fd54b2a18dc2a07d0daa8142c0289))


### Features

* **config:** validate config before applying ([b396b24](https://github.com/saltstack-formulas/nginx-formula/commit/b396b24fe456de7001b2cc013814ada189351e6f))


### Tests

* **config:** fix for Amazon Linux 2 & Oracle Linux 7/8 ([ab39c8f](https://github.com/saltstack-formulas/nginx-formula/commit/ab39c8f7c3c9bf5dbd4436cad8ccce21263fe646))

# [2.5.0](https://github.com/saltstack-formulas/nginx-formula/compare/v2.4.1...v2.5.0) (2021-01-04)


### Continuous Integration

* **commitlint:** ensure `upstream/master` uses main repo URL [skip ci] ([0ecd767](https://github.com/saltstack-formulas/nginx-formula/commit/0ecd767e8691ba14b8c3ab7311fa7ae78e71d575))
* **gitlab-ci:** add `rubocop` linter (with `allow_failure`) [skip ci] ([5c9f6d4](https://github.com/saltstack-formulas/nginx-formula/commit/5c9f6d4d7144452145d06b95643a34f7fde3d35e))


### Features

* **context:** pass `nginx` to snippets and server_config contexts ([8641f0d](https://github.com/saltstack-formulas/nginx-formula/commit/8641f0d79a073b870a386ba9b494339c8e53b255))

## [2.4.1](https://github.com/saltstack-formulas/nginx-formula/compare/v2.4.0...v2.4.1) (2020-12-16)


### Continuous Integration

* **gemfile.lock:** add to repo with updated `Gemfile` [skip ci] ([bcd67a6](https://github.com/saltstack-formulas/nginx-formula/commit/bcd67a6d462ac7b33e0e8638f0da9a2e762076b2))
* **gitlab-ci:** use GitLab CI as Travis CI replacement ([f988e6d](https://github.com/saltstack-formulas/nginx-formula/commit/f988e6d8f5eb8bb9f8a99d6b2075883797040600))
* **kitchen:** use `saltimages` Docker Hub where available [skip ci] ([a45ffb6](https://github.com/saltstack-formulas/nginx-formula/commit/a45ffb66aef246504794a82fddc71b5351f667e5))
* **kitchen+travis:** remove `master-py2-arch-base-latest` [skip ci] ([86f0a57](https://github.com/saltstack-formulas/nginx-formula/commit/86f0a5705afd745fa9982e22c762d37b0f94345a))
* **pre-commit:** add to formula [skip ci] ([cb98ed0](https://github.com/saltstack-formulas/nginx-formula/commit/cb98ed05c69af62c32e4b780498421cf4bdd2856))
* **pre-commit:** enable/disable `rstcheck` as relevant [skip ci] ([093c38e](https://github.com/saltstack-formulas/nginx-formula/commit/093c38eae748a457644d9b0e802e10ebfef16bdb))
* **pre-commit:** finalise `rstcheck` configuration [skip ci] ([33ce43d](https://github.com/saltstack-formulas/nginx-formula/commit/33ce43dcec7e5daef07c246b826848b0fe10662a))
* **travis:** add notifications => zulip [skip ci] ([a288342](https://github.com/saltstack-formulas/nginx-formula/commit/a28834207074d7b7796822a83765bec9b799a9f0))
* **workflows/commitlint:** add to repo [skip ci] ([437b28a](https://github.com/saltstack-formulas/nginx-formula/commit/437b28af257a657192ea8452365c2a843e3a4b94))


### Styles

* **libtofs.jinja:** use Black-inspired Jinja formatting [skip ci] ([66f4ea7](https://github.com/saltstack-formulas/nginx-formula/commit/66f4ea7ed9dd1aa10474c064a10f103b32f2b60f))

# [2.4.0](https://github.com/saltstack-formulas/nginx-formula/compare/v2.3.3...v2.4.0) (2020-03-31)


### Bug Fixes

* **libtofs:** “files_switch” mess up the variable exported by “map.jinja” [skip ci] ([10b446e](https://github.com/saltstack-formulas/nginx-formula/commit/10b446ed1ed295e5bf75fcb437953df61b39ba9e))


### Continuous Integration

* **kitchen:** avoid using bootstrap for `master` instances [skip ci] ([efebb0a](https://github.com/saltstack-formulas/nginx-formula/commit/efebb0af6b4cda41a75d571fe5adc869b32febb7))


### Features

* **add purge option:** purge sites option ([a373bda](https://github.com/saltstack-formulas/nginx-formula/commit/a373bdab79e854c43c61de7edd65d460c73f0477))

## [2.3.3](https://github.com/saltstack-formulas/nginx-formula/compare/v2.3.2...v2.3.3) (2019-12-22)


### Bug Fixes

* **map.jinja:** use upstream default for `worker_connections` ([49caf8c](https://github.com/saltstack-formulas/nginx-formula/commit/49caf8cd69be49bd7773949c9f29e147732140a5)), closes [#261](https://github.com/saltstack-formulas/nginx-formula/issues/261)


### Continuous Integration

* **gemfile:** restrict `train` gem version until upstream fix [skip ci] ([09be54d](https://github.com/saltstack-formulas/nginx-formula/commit/09be54d05fb3ce7cff039aa74633a3b29dcbbcee))
* **travis:** quote pathspecs used with `git ls-files` [skip ci] ([091c614](https://github.com/saltstack-formulas/nginx-formula/commit/091c61448dd068e2734869caeb91cedb6f4264e2))
* **travis:** run `shellcheck` during lint job [skip ci] ([ccf64d9](https://github.com/saltstack-formulas/nginx-formula/commit/ccf64d9be2f0aa07dfb72ed25352197081e9e388))
* **travis:** use `major.minor` for `semantic-release` version [skip ci] ([facbaa1](https://github.com/saltstack-formulas/nginx-formula/commit/facbaa1e392de9238cf494964e57af73e1bf709a))

## [2.3.2](https://github.com/saltstack-formulas/nginx-formula/compare/v2.3.1...v2.3.2) (2019-11-25)


### Bug Fixes

* **certificates.sls:** prepare `certificates_path` dir separately ([297e3ac](https://github.com/saltstack-formulas/nginx-formula/commit/297e3ac400707cdd8f396da4c23ba30fc719a2cd)), closes [#241](https://github.com/saltstack-formulas/nginx-formula/issues/241)
* **release.config.js:** use full commit hash in commit link [skip ci] ([b13ec85](https://github.com/saltstack-formulas/nginx-formula/commit/b13ec85433d85b8ca87c3798db9cab3e297b81cf))


### Continuous Integration

* **kitchen:** use `debian-10-master-py3` instead of `develop` [skip ci] ([0665878](https://github.com/saltstack-formulas/nginx-formula/commit/066587829c5a40967b0e7926f12202b07b51ab3c))
* **kitchen:** use `develop` image until `master` is ready (`amazonlinux`) [skip ci] ([e8ed39a](https://github.com/saltstack-formulas/nginx-formula/commit/e8ed39a62cd40fe43af2aae67a3e2347d02b6b6a))
* **kitchen+travis:** upgrade matrix after `2019.2.2` release [skip ci] ([faefcab](https://github.com/saltstack-formulas/nginx-formula/commit/faefcabd654e5323b6ca146fb0046dd636ed5f68))
* **travis:** apply changes from build config validation [skip ci] ([4125887](https://github.com/saltstack-formulas/nginx-formula/commit/41258874a52df3da7a9f036b5378eb12b7a1a537))
* **travis:** opt-in to `dpl v2` to complete build config validation [skip ci] ([dbeb2da](https://github.com/saltstack-formulas/nginx-formula/commit/dbeb2da3e43aa13f162b1ac4c6203ecff60e0102))
* **travis:** update `salt-lint` config for `v0.0.10` [skip ci] ([a8382b5](https://github.com/saltstack-formulas/nginx-formula/commit/a8382b51a028ed5f069ff0168127ef3c8a4337da))
* **travis:** use build config validation (beta) [skip ci] ([bbf91c9](https://github.com/saltstack-formulas/nginx-formula/commit/bbf91c9f1432118a9eafde507de9ffa7b3ff5093))
* merge travis matrix, add `salt-lint` & `rubocop` to `lint` job ([567c08c](https://github.com/saltstack-formulas/nginx-formula/commit/567c08c9adf752eb95627b0e914804645015ee20))


### Documentation

* **contributing:** remove to use org-level file instead [skip ci] ([2e58d63](https://github.com/saltstack-formulas/nginx-formula/commit/2e58d636aaa8a66ec9540238b2f4e267172e10c2))
* **readme:** update link to `CONTRIBUTING` [skip ci] ([3ff6692](https://github.com/saltstack-formulas/nginx-formula/commit/3ff6692590932e7cc7609fdc0f52fc261228f290))


### Performance Improvements

* **travis:** improve `salt-lint` invocation [skip ci] ([e586fbe](https://github.com/saltstack-formulas/nginx-formula/commit/e586fbeebc758cdfd6d381a6ef9ad72231523dea))


### Tests

* **pillar/nginx.sls:** add reprodicible snippet based on issue [#241](https://github.com/saltstack-formulas/nginx-formula/issues/241) ([4ba3524](https://github.com/saltstack-formulas/nginx-formula/commit/4ba35247ed742393367968db34ff61a6b07f6695))

## [2.3.1](https://github.com/saltstack-formulas/nginx-formula/compare/v2.3.0...v2.3.1) (2019-10-10)


### Bug Fixes

* **certificates.sls:** fix `salt-lint` errors ([](https://github.com/saltstack-formulas/nginx-formula/commit/bedc1b6))
* **map.jinja:** fix `salt-lint` errors ([](https://github.com/saltstack-formulas/nginx-formula/commit/0772d8a))
* **pkg.sls:** fix `salt-lint` errors ([](https://github.com/saltstack-formulas/nginx-formula/commit/06d055e))


### Continuous Integration

* **kitchen:** change `log_level` to `debug` instead of `info` ([](https://github.com/saltstack-formulas/nginx-formula/commit/671a4ce))
* **kitchen:** install required packages to bootstrapped `opensuse` [skip ci] ([](https://github.com/saltstack-formulas/nginx-formula/commit/17291a0))
* **kitchen:** use bootstrapped `opensuse` images until `2019.2.2` [skip ci] ([](https://github.com/saltstack-formulas/nginx-formula/commit/a39e124))
* **platform:** add `arch-base-latest` ([](https://github.com/saltstack-formulas/nginx-formula/commit/c921086))
* **yamllint:** add rule `empty-values` & use new `yaml-files` setting ([](https://github.com/saltstack-formulas/nginx-formula/commit/3d48b1b))
* merge travis matrix, add `salt-lint` & `rubocop` to `lint` job ([](https://github.com/saltstack-formulas/nginx-formula/commit/08ce3ed))
* use `dist: bionic` & apply `opensuse-leap-15` SCP error workaround ([](https://github.com/saltstack-formulas/nginx-formula/commit/8ddb921))


### Documentation

* **pillar.example:** fix TOFS comment to explain the default path [skip ci] ([](https://github.com/saltstack-formulas/nginx-formula/commit/714f547)), closes [/github.com/saltstack-formulas/libvirt-formula/pull/60#issuecomment-537965254](https://github.com//github.com/saltstack-formulas/libvirt-formula/pull/60/issues/issuecomment-537965254) [/github.com/saltstack-formulas/libvirt-formula/pull/60#issuecomment-537988138](https://github.com//github.com/saltstack-formulas/libvirt-formula/pull/60/issues/issuecomment-537988138)

# [2.3.0](https://github.com/saltstack-formulas/nginx-formula/compare/v2.2.1...v2.3.0) (2019-09-01)


### Continuous Integration

* **kitchen+travis:** replace EOL pre-salted images ([70e1426](https://github.com/saltstack-formulas/nginx-formula/commit/70e1426))


### Features

* **passenger:** inc config, snippets, servers, etc ([e07b558](https://github.com/saltstack-formulas/nginx-formula/commit/e07b558))

## [2.2.1](https://github.com/saltstack-formulas/nginx-formula/compare/v2.2.0...v2.2.1) (2019-08-25)


### Documentation

* **readme:** update testing section ([182f216](https://github.com/saltstack-formulas/nginx-formula/commit/182f216))

# [2.2.0](https://github.com/saltstack-formulas/nginx-formula/compare/v2.1.0...v2.2.0) (2019-08-12)


### Features

* **yamllint:** include for this repo and apply rules throughout ([6b7d1fe](https://github.com/saltstack-formulas/nginx-formula/commit/6b7d1fe))

# [2.1.0](https://github.com/saltstack-formulas/nginx-formula/compare/v2.0.0...v2.1.0) (2019-08-04)


### Continuous Integration

* **kitchen+travis:** modify matrix to include `develop` platform ([f6b357d](https://github.com/saltstack-formulas/nginx-formula/commit/f6b357d))


### Features

* **linux:** archlinux support (no osfinger grain) ([ab6148c](https://github.com/saltstack-formulas/nginx-formula/commit/ab6148c))

# [2.0.0](https://github.com/saltstack-formulas/nginx-formula/compare/v1.1.0...v2.0.0) (2019-06-19)


### Bug Fixes

* **snippets:** removed appending of ".conf" ([aa87721](https://github.com/saltstack-formulas/nginx-formula/commit/aa87721))


### BREAKING CHANGES

* **snippets:** Users have to modify their pillar
according to this commit. Users MUST append '.conf' for their
existing managed snippets.

# [1.1.0](https://github.com/saltstack-formulas/nginx-formula/compare/v1.0.5...v1.1.0) (2019-06-03)


### Features

* **tofs:** first implemetation + tplroot ([d5262ea](https://github.com/saltstack-formulas/nginx-formula/commit/d5262ea))

## [1.0.5](https://github.com/saltstack-formulas/nginx-formula/compare/v1.0.4...v1.0.5) (2019-05-13)


### Documentation

* **readme:** improve readme sections ([3cc3407](https://github.com/saltstack-formulas/nginx-formula/commit/3cc3407))

## [1.0.4](https://github.com/saltstack-formulas/nginx-formula/compare/v1.0.3...v1.0.4) (2019-05-13)


### Bug Fixes

* prevent running of states deprecated in `v1.0.0` ([46dff15](https://github.com/saltstack-formulas/nginx-formula/commit/46dff15))

## [1.0.3](https://github.com/saltstack-formulas/nginx-formula/compare/v1.0.2...v1.0.3) (2019-05-13)


### Documentation

* **readme:** add warning banner about `v1.0.0` breaking changes ([d553821](https://github.com/saltstack-formulas/nginx-formula/commit/d553821))

## [1.0.2](https://github.com/saltstack-formulas/nginx-formula/compare/v1.0.1...v1.0.2) (2019-05-12)


### Documentation

* **readme:** update README, add badges ([adbac43](https://github.com/saltstack-formulas/nginx-formula/commit/adbac43))

## [1.0.1](https://github.com/saltstack-formulas/nginx-formula/compare/v1.0.0...v1.0.1) (2019-05-12)


### Documentation

* remove obsolete CHANGELOG.rst file ([698aadb](https://github.com/saltstack-formulas/nginx-formula/commit/698aadb))

# [1.0.0](https://github.com/saltstack-formulas/nginx-formula/compare/v0.56.1...v1.0.0) (2019-05-12)


### Build System

* remove obsolete Makefile ([4961b04](https://github.com/saltstack-formulas/nginx-formula/commit/4961b04))


### Code Refactoring

* replace old `nginx` with `nginx.ng` ([0fc5070](https://github.com/saltstack-formulas/nginx-formula/commit/0fc5070))


### BREAKING CHANGES

* all previous `nginx` based configurations must be reviewed;
`nginx.ng` usage must be promoted to `nginx` and any uses of the original
`nginx` will have to be converted.

## [0.56.1](https://github.com/saltstack-formulas/nginx-formula/compare/v0.56.0...v0.56.1) (2019-04-27)


### Tests

* **inspec:** add test for `log_format` [#219](https://github.com/saltstack-formulas/nginx-formula/issues/219) ([4ed788e](https://github.com/saltstack-formulas/nginx-formula/commit/4ed788e))

# [0.56.0](https://github.com/saltstack-formulas/nginx-formula/compare/v0.55.1...v0.56.0) (2019-04-26)


### Features

* **`pillar.example`:** add stock `log_format` ([95ff308](https://github.com/saltstack-formulas/nginx-formula/commit/95ff308))

## [0.55.1](https://github.com/saltstack-formulas/nginx-formula/compare/v0.55.0...v0.55.1) (2019-04-26)


### Documentation

* **semantic-release:** implement an automated changelog ([569b07a](https://github.com/saltstack-formulas/nginx-formula/commit/569b07a))
