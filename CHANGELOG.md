# Changelog

## [2.3.0] - 2025-10-08

### Added

#### ES.Next Support via Babel Preprocessing

Modern JavaScript (ES2015 through ES2023+) is now supported through an optional Babel preprocessing stage.

**New Features:**
- Automatic detection of modern syntax (arrow functions, async/await, optional chaining, etc.)
- Two-stage pipeline: Babel transpiles ES.Next → ES5, then js2coffee transforms to CoffeeScript
- Configuration option `babel` in `build()` API:
  - `babel: true` - Force Babel preprocessing
  - `babel: false` - Disable Babel preprocessing
  - Default: Auto-detect based on syntax

**Example:**
```coffeescript
# Input: modern JavaScript
greet = (name) -> `Hello, ${name}!`
{x, y} = point
makePoint = (x, y) -> {x, y}

# Converts from:
const greet = (name) => `Hello, ${name}!`;
const {x, y} = point;
const makePoint = (x, y) => ({x, y});
```

**New Dependencies:**
- `@babel/core` - ^7.26.0
- `@babel/preset-env` - ^7.26.0

### Changed

#### CoffeeScript 2.x Migration

**Upgraded from deprecated `coffee-script@1.x` to `coffeescript@2.x`**

This resolves security vulnerabilities and enables compatibility with modern CoffeeScript.

**Critical Bug Fix:**
- Fixed issue where AST transformers weren't being registered properly
- CoffeeScript 2.x makes class methods non-enumerable (per ES2015 spec)
- Updated `safeExtend()` to use `Object.getOwnPropertyNames()` for proper method copying

**Build Tooling:**
- Upgraded `coffeeify` from 2.0.1 to 3.0.1

#### Dependency Reduction

Removed 9 dependencies (47% reduction: 19 → 10 packages) by replacing with Node.js built-ins:

| Removed | Replaced With |
|---------|---------------|
| `mocha` + `chai` + `mocha-clean` | Node.js `node:test` + `node:assert/strict` |
| `glob` | Node.js `fs.globSync()` |
| `minimist` | Node.js `util.parseArgs()` |
| `read-input` | Custom native implementation |
| `underscore`, `coffeelint`, `js-yaml` | Removed (unused) |

**Security:**
- Zero vulnerabilities (previously had 9)
- All dependencies actively maintained

### Requirements

- **Node.js 22+** (for `fs.globSync()`)
- **CoffeeScript 2.7.0+** (for building from source)

### Migration Guide

**For users upgrading from 2.2.0:**

No changes required. This is a backwards-compatible release.

- All existing code continues to work unchanged
- Modern JavaScript support is automatically enabled when detected
- No breaking changes to the API

**To disable Babel preprocessing:**
```javascript
const result = js2coffee.build(source, { babel: false });
```

### Technical Details

#### Architecture

Two-stage pipeline:
1. **Stage 1**: Babel transpiles ES.Next → ES5/partial ES6
2. **Stage 2**: js2coffee transforms ES5/ES6 → CoffeeScript

This preserves the battle-tested transformation logic while enabling modern JavaScript support.

#### Babel Configuration
- Target: IE 10 (ensures ES5 compatibility with Esprima 2.5)
- Modules: Preserved
- Retain Lines: Enabled (preserves approximate line numbers)
- Comments: Preserved

### Performance

- Negligible overhead for ES5 code (Babel only runs when modern syntax detected)
- Test suite: ~1.9s for 326 tests

---

## [2.2.0] - 2016-03-21

Final release by original maintainers. See original repository for details.

[2.3.0]: https://github.com/js2coffee/js2coffee/compare/v2.2.0...v2.3.0
[2.2.0]: https://github.com/js2coffee/js2coffee/releases/tag/v2.2.0

## About this file

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

