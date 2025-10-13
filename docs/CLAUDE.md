# js2coffee Modernization Status

**Fork:** https://github.com/thatsnice/js2coffee
**Upstream:** https://github.com/js2coffee/js2coffee
**Last Updated:** 2025-10-12

## Overview

This is a comprehensive modernization effort to bring js2coffee up to date with modern JavaScript, CoffeeScript 2.x, and current Node.js practices. The work has been organized into independent, reviewable PRs submitted to upstream.

## Submitted Pull Requests

### PR1: Upgrade to CoffeeScript 2.x ✅
**Status:** Submitted to upstream
**Branch:** `pr1`

**Changes:**
- Upgraded from CoffeeScript 1.8 to 2.7.0
- Fixed breaking change: explicit `super()` calls in constructors
- Updated all build tooling
- All 326 tests passing

**Key Files:**
- `package.json` - CoffeeScript dependency updated
- `lib/transforms/base.coffee` - Fixed super() handling
- `Makefile`, build scripts updated

---

### PR2: Switch from mocha/chai to Node.js test library ✅
**Status:** Submitted to upstream
**Branch:** `pr2`

**Changes:**
- Migrated from mocha/chai to Node.js built-in `node:test` (Node 16+)
- Created Chai-compatible `expect()` API using `node:assert/strict`
- Converted all 13 test files
- Updated test scripts in package.json
- Removed mocha, chai, mocha-clean dependencies

**Key Files:**
- `test/setup.coffee` - Complete rewrite with Chai-compatible API
- `package.json` - Test runner changes
- All test files updated with `node:test` imports

**Test Coverage:** 326 tests, all passing

---

### PR3: Raise the bar for js2coffee ✅
**Status:** Submitted to upstream
**Branch:** `pr3`

**Changes:**
- Added conciseness test suite (17 tests verifying CoffeeScript is shorter than JavaScript)
- Improved array formatting: keep simple arrays on one line
- Added comparison matchers: `toBeLessThan()`, `toBeGreaterThan()`

**Key Files:**
- `test/conciseness.coffee` - New test suite
- `test/setup.coffee` - Added comparison matchers
- `lib/builder/index.coffee` - `isSimpleArray()` method
- Spec files updated for new array formatting

**Impact:** Makes js2coffee output more concise and readable

---

### PR4: Update libraries and transforms ✅
**Status:** Submitted to upstream
**Branch:** `pr4`

**Changes:**
- Added ES.Next support via Babel preprocessing
- Upgraded core dependencies:
  - esprima: 2.5.0 → 4.0.1 (3 major versions!)
  - escodegen: 1.6.0 → 2.1.0
  - estraverse: 4.1.1 → 5.3.0
  - source-map: 0.5.2 → 0.7.6
- Added Babel dependencies (@babel/core, @babel/preset-env)
- New transform handlers:
  - `TemplateLiteral` - Template string support
  - `ArrowFunctionExpression` - Arrow functions
  - `AwaitExpression` - async/await
  - `AssignmentPattern` - ES6 default parameters

**Key Files:**
- `lib/preprocessor.coffee` - New Babel preprocessing layer
- `lib/builder/index.coffee` - ES.Next transform handlers
- `js2coffee.coffee` - Integrated preprocessor
- `package.json` - Dependency upgrades

**Impact:** js2coffee can now handle modern JavaScript (ES6+)

---

### PR5: Remove more dependencies ✅
**Status:** Submitted to upstream
**Branch:** `pr5`

**Changes:**
- Replaced minimist with Node's built-in `util.parseArgs` (Node 16.17+)
- Vendored read-input functionality in CoffeeScript
- Removed 2 external dependencies
- Down to 6 runtime dependencies (all necessary)

**Key Files:**
- `lib/read-input.coffee` - New native implementation (72 lines)
- `lib/cli.js` - util.parseArgs implementation
- `bin/js2coffee` - Updated require paths
- `package.json` - Removed minimist and read-input

**Benefits:**
- Fewer supply chain risks
- Faster installation
- Better control over functionality

---

## Test Status

**Total Tests:** 343
**All Passing:** ✅ Yes
**Coverage:** Comprehensive (26 test suites covering all major features)

### Test Infrastructure
- Modern Node.js test runner (`node:test`)
- Chai-compatible expect API
- Async/await support
- Skip/only functionality
- Clean error reporting

---

## Dependency Summary

### Runtime Dependencies (6)
- `@babel/core` ^7.26.0 - ES.Next transpilation
- `@babel/preset-env` ^7.26.0 - Babel presets
- `escodegen` ^2.1.0 - Code generation
- `esprima` ^4.0.1 - JavaScript parsing
- `estraverse` ^5.3.0 - AST traversal
- `source-map` ^0.7.6 - Source map generation

### Dev Dependencies (7)
- `browserify` 13.3.0 - Browser builds
- `coffeescript` ^2.7.0 - CoffeeScript compiler
- `coffeeify` ^3.0.1 - Browserify transform
- `coffeelint` ^1.6.0 - Linting
- `glob` ^7.0.0 - File matching
- `js-yaml` ^3.2.1 - YAML parsing
- `terser` ^5.36.0 - Minification
- `underscore` ^1.7.0 - Utilities

**Removed:** mocha, chai, mocha-clean, minimist, read-input

---

## Features Added

### ES.Next Support
- Arrow functions: `(x) => x * 2` → `(x) -> x * 2`
- Template literals: `` `Hello ${name}` `` → `"Hello #{name}"`
- Async/await: `async function` → CoffeeScript async
- Default parameters: `function(a = 1)` → `(a = 1) ->`
- Optional chaining: `obj?.prop` (via Babel)
- Nullish coalescing: `a ?? b` (via Babel)
- And more modern syntax via Babel preprocessing

### Quality Improvements
- Conciseness testing ensures output is shorter than input
- Better array formatting (simple arrays stay on one line)
- Improved error messages with context
- Source map support maintained

---

## Branch Organization

### Main Branches
- `master` - Upstream main branch (unchanged)
- `pr1` through `pr5` - Individual PRs for upstream
- `thatsnice-v3` - Our consolidated fork (if upstream doesn't accept)

### Development Branches
- `pr1-foundation`, `pr2-test-infrastructure`, etc. - Working branches
- `pr4-housekeeping` - Additional improvements waiting for upstream decision

---

## Timeline

- **2025-10-10:** Started modernization effort
- **2025-10-12:** Completed and submitted PRs 1-5 to upstream
- **2025-10-20:** Decision point - if no upstream response, announce fork

---

## Fork Strategy

If upstream doesn't respond by October 20th:

1. **Announce fork** in r/coffeescript and r/javascript
2. **Merge all PRs** to master in thatsnice/js2coffee
3. **Publish to npm** as `@thatsnice/js2coffee` or similar
4. **Maintain actively** with modern JavaScript support

---

## Future Enhancements (Post-Fork)

### Potential Improvements
- [ ] Class syntax support
- [ ] Spread operator improvements
- [ ] Better error recovery
- [ ] Interactive mode
- [ ] VS Code extension
- [ ] Online playground
- [ ] Performance optimizations
- [ ] Additional output formats

### Documentation
- [ ] Migration guide (CoffeeScript 1.x → 2.x)
- [ ] ES.Next feature coverage matrix
- [ ] API documentation improvements
- [ ] Contributing guide

---

## Technical Notes

### Node.js Requirements
- **Minimum:** Node.js 16.17+ (for util.parseArgs)
- **Recommended:** Node.js 18+ LTS
- **Tested on:** Node.js 20+

### Breaking Changes (from upstream)
None - all changes are backward compatible at the API level.

### Migration Path
Existing users can upgrade seamlessly:
1. `npm install js2coffee@latest` (once merged/forked)
2. No code changes required
3. Tests should pass without modification

---

## Contributing

See individual PR branches for specific implementation details.

### Code Style
- CoffeeScript for library code
- Minimal dependencies
- Comprehensive tests
- Clean, reviewable diffs

### Testing
```bash
npm test                    # Run all tests
npm test -- test/file.coffee  # Run specific test
```

### Building
```bash
make dist                   # Build distribution
```

---

## Credits

**Original Author:** Rico Sta. Cruz
**Modernization:** Robert de Forest + Claude (Anthropic)
**Test Suite:** Original js2coffee contributors

---

## License

MIT License (maintained from upstream)
