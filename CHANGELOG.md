# Changelog

All notable changes to this project are documented in this file.
The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

## [0.2.0] - 2026-10-01
DOGOnews fork. Minor version (the gem is still 0.x) because the minimum supported Mongoid rose from 4.0 (0.1.5)
to 7.0.

### Added
- GitHub Actions test matrix (`.github/workflows/test.yml`), seven rows from Ruby 2.7 / Rails 6.1 /
  Mongoid 7.5 / MongoDB 6.0 to Ruby 3.4 / Rails 8.0 / Mongoid 9.0 / MongoDB 8.0. The `Gemfile` selects
  Rails and Mongoid from `RAILS_VERSION` / `MONGOID_VERSION` (defaults 6.1 / 7.5).
- GitHub Release workflow (`.github/workflows/release.yml`): pushing a `vX.Y.Z` tag creates a GitHub Release
  with this file's section as the notes.

### Changed
- Runtime dependency `mongoid >= 7.0, < 10` (was any version; 0.1.5 required `~> 4.0.0.alpha1`).
- Specs run on RSpec 3.13 (keeping the `should` syntax, enabled explicitly) with `database_cleaner-mongoid`;
  `raise_error` matchers assert the actual `"bad vote value"` error, and the embedded-rate validation spec
  expects Mongoid 8+ to re-validate only new or changed embedded documents.
- The gemspec `homepage` points to this fork.
- README rewritten for the maintained fork (supported versions, every `rateable` option and generated
  method/scope, development instructions); history moved to this file.

### Removed
- The Mongoid 2 code path (`embeds_many` without a counter cache).
- Travis CI and Coveralls configuration (`.travis.yml`, `.coveralls.yml`, the `coveralls` development
  dependency), `.ruby-version` and `.ruby-gemset`.

### Fixed
- `rateable` raised `Mongoid::Errors::InvalidRelationOption` on Mongoid 7+: the embedded rates were declared
  with `counter_cache: true`, which `embeds_many` does not accept.

## [0.1.9] - 2019-05-10
### Added
- `validate:` option for `rateable` (default `true`): `validate: false` stops the embedded rates from being
  validated with the parent, so a document whose rater was destroyed can still be saved.

## [0.1.8] - 2018-06-01
### Changed
- Mongoid version checks use `Mongoid::Compatibility::Version` instead of the gem's own
  `Mongoid::Rating.mongoid2?` / `mongoid3?`.

## [0.1.7] - 2018-06-01
### Changed
- `mongoid-compatibility` is a runtime dependency in the gemspec (was only in the Gemfile); version
  constraints on the `bundler` and `rspec` development dependencies dropped.

## [0.1.6] - 2018-06-01
### Added
- Mongoid 2, 3, 5 and 6 support: `inc`/`set` called with the Mongoid 2/3 signature on those versions, no
  counter cache on Mongoid 2, `Mongoid::Timestamps` instead of `Mongoid::Timestamps::Short` on the rates.

### Changed
- Runtime dependency `mongoid` without a version constraint (was `~> 4.0.0.alpha1`).

## [0.1.5] - 2013-12-30
### Fixed
- rails_admin could not delete rates: `Mongoid::Rating::Rate` now has a `rails_admin_default_object_label_method`.

## [0.1.4] - 2013-12-04
### Changed
- Runtime dependency `mongoid ~> 4.0.0.alpha1` (was `>= 4.0, < 5.0`).

## [0.1.3] - 2013-11-13
### Added
- `fmt_<field>(user = nil)`: the user's own rate if they rated, otherwise the formatted average (for the Raty
  JS plugin), with the `:format` and `:no_rate` options.

## [0.1.2] - 2013-11-13
### Fixed
- Rate values given as Strings are converted (`to_f`, or `to_i` with `float: false`) before the range check.

## [0.1.1] - 2013-11-07
### Removed
- The `eval:` option and its `db.eval` rating mode (MongoDB 2.4+ requires full admin access for `db.eval`);
  rates are always applied with atomic `inc`/`set`.

## [0.1.0] - 2013-10-25
### Added
- `by_<field>` scope: all documents, including unrated ones, ordered by average descending.

## [0.0.2] - 2013-10-01
### Changed
- Runtime dependency `mongoid >= 4.0, < 5.0`.

## [0.0.1] - 2013-10-01
### Added
- Initial release by glebtv, partially based on [mongoid_rateable](https://github.com/proton/mongoid_rateable)
  by Peter Savichev.

[Unreleased]: https://github.com/joe1chen/mongoid_rating/compare/v0.2.0...HEAD
[0.2.0]: https://github.com/joe1chen/mongoid_rating/compare/v0.1.9...v0.2.0
[0.1.9]: https://github.com/joe1chen/mongoid_rating/compare/v0.1.8...v0.1.9
[0.1.8]: https://github.com/joe1chen/mongoid_rating/compare/v0.1.7...v0.1.8
[0.1.7]: https://github.com/joe1chen/mongoid_rating/compare/v0.1.6...v0.1.7
[0.1.6]: https://github.com/joe1chen/mongoid_rating/compare/v0.1.5...v0.1.6
[0.1.5]: https://github.com/joe1chen/mongoid_rating/compare/v0.1.4...v0.1.5
[0.1.4]: https://github.com/joe1chen/mongoid_rating/compare/v0.1.3...v0.1.4
[0.1.3]: https://github.com/joe1chen/mongoid_rating/compare/v0.1.2...v0.1.3
[0.1.2]: https://github.com/joe1chen/mongoid_rating/compare/v0.1.1...v0.1.2
[0.1.1]: https://github.com/joe1chen/mongoid_rating/compare/v0.1.0...v0.1.1
[0.1.0]: https://github.com/joe1chen/mongoid_rating/compare/v0.0.2...v0.1.0
[0.0.2]: https://github.com/joe1chen/mongoid_rating/compare/v0.0.1...v0.0.2
[0.0.1]: https://github.com/joe1chen/mongoid_rating/releases/tag/v0.0.1
