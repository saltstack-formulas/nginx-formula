# Changelog

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
