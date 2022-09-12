# changelog

[![Keep a Changelog](https://img.shields.io/badge/Keep%20a%20Changelog-1.0.0-informational)](https://keepachangelog.com/en/1.0.0/)
[![Semantic Versioning](https://img.shields.io/badge/Sematic%20Versioning-2.0.0-informational)](https://semver.org/spec/v2.0.0.html)
![clq validated](https://img.shields.io/badge/clq-validated-success)

Keep the newest entry at top, format date according to ISO 8601: `YYYY-MM-DD`.

Categories, defined in [changemap.json](.github/clq/changemap.json)):
- _major_ release trigger:
   - `Changed` for changes in existing functionality.
   - `Removed` for now removed features.
- _minor_ release trigger:
   - `Added` for new features.
   - `Deprecated` for soon-to-be removed features.
- _bug-fix_ release trigger:
   - `Fixed` for any bug fixes.
   - `Security` in case of vulnerabilities.

## [1.2.3] - 2022-12-26
### Fixed
- Bump denisa/clq from 1.7.1-alpine to 1.7.3-alpine

## [1.2.2] - 2022-08-30
### Fixed
- bump denisa/clq from 1.6.3-alpine to 1.7.1-alpine
- minor documentation improvements

## [1.2.1] - 2022-05-25
### Fixed
- Properly joins all lines in the body with an escaped newline %0A

## [1.2.0] - 2022-05-13
### Added
- Use option changeMap to specify a changeMap to use instead of the default.
- A custom changemap.json for use by the CHANGELOG.md, and rewrite the category changes
  to conform.

### Fixed
- Bump denisa/clq from 1.6.2-alpine to 1.6.3-alpine

## [1.1.3] - 2022-05-08
### Fixed
- rename github branch to `main`

## [1.1.2] - 2022-05-07
### Fixed
- When creating all tags, creates either version or (tries to create) prerelease tags
- bump denisa/clq from 1.6.1-alpine to 1.6.2-alpine

## [1.1.1] - 2022-04-30
### Fixed
- create all tags include pre-release version
- Examples in the README were not referencing the action

## [1.1.0] - 2022-04-29
### Added
- create all tags (major/minor/patch, major/minor, major)

### Fixed
- add .editconfig
- bump actions/checkout from 2.3.1 to 3.0.2
- bump denisa/clq from 1.3.0-alpine to 1.6.1-alpine
- change to ncipollo/release-action

## [1.0.2] - 2020-07-25
### Fixed
- examples have the proper `uses:` statement

## [1.0.1] - 2020-07-23
### Fixed
- removed steps to publish clq binaries from workflows

## [1.0.0] - 2020-07-23
### Added
- clq action
