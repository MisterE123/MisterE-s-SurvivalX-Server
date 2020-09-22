# Changelog
All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](http://keepachangelog.com/en/1.0.0/)
and this project adheres to [Semantic Versioning](https://semver.org/).


## [Unreleased]

	- No further features planned.


## [0.2.0] - 2019-10-30
### Added

	- Global function which allows other mods to register their nodes (see api.txt).

### Changed

	- License changed to EUPL v1.2
	- Code entirely rewritten.
	- mod.conf set to follow MT v5.x specifics.

### Removed

	- Support for MT v0.4.x
	
## [0.2.1] - 2020-6-25

### Changed
- [changes by MisterE] init.lua changed the node overrider to make leaf nodes a false liquid instead of a ladder. Also changed the for loop from a set # of iters to just iterate through the 			entire node list regardless of its length.
