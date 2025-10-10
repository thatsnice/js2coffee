# Changelog

## [2.3.0] - 2025-10-08

### Added

#### ES.Next Support via Babel Preprocessing

Modern JavaScript (ES2015 through ES2023+) is now supported through an optional Babel preprocessing stage.

**New Features:**
- Automatic detection of modern syntax (arrow functions, async/await, optional chaining, etc.)
- Two-stage pipeline: Babel transpiles modern JS → ES5, then js2coffee transforms to CoffeeScript
- Configuration option `babel` in `build()` API:
  - `babel: true` - Force Babel preprocessing
  - `babel: false` - Disable Babel preprocessing
  - Default: Auto-detect based on syntax

**Example:**
```javascript
// Input: Modern JavaScript
const greet = (name) => `Hello, ${name}!`;
const value = obj?.prop ?? 'default';

// Output: CoffeeScript
greet = (name) ->
  'Hello, ' + name + '!'
value = if obj?.prop != null then obj.prop else 'default'
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

#### Dependency Updates

**Core parsing dependencies upgraded to latest versions:**
- `esprima`: 2.5.0 → 4.0.1 (ES2017 support)
- `escodegen`: 1.6.0 → 2.1.0
- `estraverse`: 4.1.1 → 5.3.0
- `source-map`: 0.5.2 → 0.7.6

**Removed 9 dependencies** (47% reduction: 19 → 10 packages) by replacing with Node.js built-ins:

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

#### Output Formatting Improvements

**Concise Array Literals:**

Arrays containing simple values (literals, identifiers, unary expressions) now format on a single line instead of multi-line, significantly improving output conciseness.

**Before (2.2.0):**
```javascript
// Input:
var arr = [1, 2, 3, 4, 5];

// Output (29 chars):
arr = [
  1
  2
  3
  4
  5
]
```

**After (2.3.0):**
```javascript
// Input:
var arr = [1, 2, 3, 4, 5];

// Output (23 chars - 12% reduction):
arr = [ 1, 2, 3, 4, 5 ]
```

**Behavior:**
- Arrays with ≤10 simple elements format on a single line
- Complex arrays (objects, functions, nested arrays) still use multi-line formatting for readability
- Preserves CoffeeScript's promise of expressive efficiency

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
1. **Stage 1**: Babel transpiles modern JS → ES5
2. **Stage 2**: js2coffee transforms ES5 → CoffeeScript

All modern JavaScript features (ES2015+) are currently transpiled to ES5 for maximum compatibility with js2coffee's existing transformers. While Esprima 4.x can parse up to ES2017 natively, js2coffee doesn't yet have handlers for all ES6+ AST node types. Future enhancements could leverage native ES2015-ES2017 parsing.

#### Babel Configuration
- Target: IE 10 (transpiles to ES5 for maximum compatibility)
- Modules: Preserved (not transformed)
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

