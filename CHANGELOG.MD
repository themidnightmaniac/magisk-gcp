# Changelog

## 1.1.0 - 2024-11-25

_Updated with more options, see [OPTIONS.MD](https://github.com/themidnightmaniac/magisk-gcp/blob/master/OPTIONS.MD)_

### Changed

- Improve pattern matching in post-fs-data.sh
- Bump version to 1.1.0

### Added

- Add OPTIONS.MD file to track what options are changed by the module
- Add clearer documentation @ README

### Removed 

- Remove hardcoded gps.conf path in post-fs-data.sh

### Fixed

- Fix touch statement possibly overwriting system files making the module patch the wrong file

## 1.0.0 - 2024-11-20

_First release._

### Added
- Added post-fs-data.sh.
- Added necessary structure for the module to work.
- Added Module info related stuff.
- Created README, CHANGELOG and TODO files.
