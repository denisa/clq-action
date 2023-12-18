# changelog

[![Keep a Changelog](https://img.shields.io/badge/Keep%20a%20Changelog-1.0.0-informational)](https://keepachangelog.com/en/1.0.0/)
[![Semantic Versioning](https://img.shields.io/badge/Sematic%20Versioning-2.0.0-informational)](https://semver.org/spec/v2.0.0.html)
![clq validated](https://img.shields.io/badge/clq-validated-success)

Keep the newest entry at top, format date according to ISO 8601: `YYYY-MM-DD`.

Categories, defined in [changemap.json](.github/clq/changemap.json):

- *major* release trigger:
  - `Changed` for changes in existing functionality.
  - `Removed` for now removed features.
- *minor* release trigger:
  - `Added` for new features.
  - `Deprecated` for soon-to-be removed features.
- *bugfix* release trigger:
  - `Fixed` for any bugfixes.
  - `Security` in case of vulnerabilities.

## [1.4.1] - 2024-01-20

### Fixed

- Bump actions/upload-artifact from 3 to 4

## [1.4.0] - 2023-12-05

### Added

- Update clq to 1.8.1 so that the generated changelog can now inlcude emoji.

## [1.3.5] - 2023-09-27

### Fixed

- Introduce superlinter

## [1.3.4] - 2023-09-09

### Fixed

- Improve sample jobs in the README.md
- Bump denisa/clq from 1.7.10 to 1.7.11

## [1.3.3] - 2023-09-05

### Fixed

- Bump actions/checkout from 3 to 4

## [1.3.2] - 2023-04-08

### Fixed

- Bump denisa/clq from 1.7.3 to 1.7.10
- Handle multi-line output to $GITHUB_OUTPUT

## [1.3.1] - 2023-01-14

### Fixed

- convert from `::set-output` to `>> $GITHUB_OUTPUT` as per [deprecation notice](https://github.blog/changelog/2022-10-11-github-actions-deprecating-save-state-and-set-output-commands/)
- track actions’ major version changes only

## [1.3.0] - 2022-12-26

### Added

- The new optional argument `dockerProxy` makes it possible to fetch the clq docker image
  through a proxy and bypass rate limiting.

### Fixed

- use denisa/semantic-tag-helper

## [1.2.3] - 2022-12-26

### Fixed

- Bump denisa/clq from 1.7.1-alpine to 1.7.3-alpine
- Bump koalaman/shellcheck from v0.8.0 to v0.9.0
- Bump ncipollo/release-action from 1.10.0 to 1.12.0
- Bump actions/checkout from 3.0.2 to 3.2.0

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

- rename GitHub branch to `main`

## [1.1.2] - 2022-05-07

### Fixed

- When creating all tags, creates either version or (tries to create) prerelease tags
- bump denisa/clq from 1.6.1-alpine to 1.6.2-alpine

## [1.1.1] - 2022-04-30

### Fixed

- create all tags include prerelease version
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
