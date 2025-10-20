# js2coffee Project Context

This document contains context for Claude Code when working on the js2coffee project.

## Pull Request Plan

We are breaking up improvements to js2coffee into 8 focused PRs to minimize scope and dependencies:

1. **PR-CS2**: CoffeeScript 2.x (master → pr-cs2)
   - Status: ✅ COMPLETED (5 commits, ready to submit)
   - Updates project to CoffeeScript 2.7.0
   - Branch: `pr-cs2`

2. **PR-TEST**: Test framework (master → pr-test)
   - Status: Not started
   - Test framework improvements
   - Branch: `pr-test`

3. **PR-LIBS**: Library upgrades (master → pr-libs)
   - Status: 🔄 IN PROGRESS
   - Upgrade esprima and other parsing libraries
   - Add ES6/ES2017 support (template literals, arrow functions, async/await)
   - Current commits: 5 (with uncommitted async-without-await work)
   - Branch: `pr-libs`

4. **PR-BABEL**: Babel integration (pr-libs → pr-babel)
   - Status: Not started
   - Depends on: PR-LIBS
   - Branch: `pr-babel`

5. **PR-ESNEXT**: ES.Next transforms (pr-babel → pr-esnext)
   - Status: Not started
   - Depends on: PR-BABEL
   - Branch: `pr-esnext`

6. **PR-DEPS**: Remove dependencies (master → pr-deps)
   - Status: Not started
   - Remove unnecessary dependencies
   - Branch: `pr-deps`

7. **PR-ARRAY**: Array formatting (master → pr-array)
   - Status: Not started
   - Improve array formatting
   - Branch: `pr-array`

8. **PR-QUALITY**: Conciseness tests (pr-test → pr-quality)
   - Status: Not started
   - Depends on: PR-TEST
   - Add tests to verify CoffeeScript's conciseness advantage
   - Branch: `pr-quality`

## Previous Attempts

- **pr{1..4}-\***: First reorganization attempt (abandoned)
- **pr{1..5}**: Second reorganization attempt (abandoned)
- **pr-\***: Current attempt with minimal scope and dependencies

## PR-LIBS Details

### Completed Work
1. Add tests for ES6/ES2017 syntax support
2. Upgrade parsing libraries to latest versions (esprima, etc.)
3. Add AST handlers for ES6/ES2017 features:
   - Template literals → CoffeeScript string interpolation
   - Arrow functions → CoffeeScript functions
   - Async/await support
4. Document library upgrades and new ES6/ES2017 support
5. Move ES6/ES2017 tests from unit tests to spec files

### Current Work (uncommitted)
- Async-without-await transformation using Promise constructor pattern
- Modified files:
  - `lib/builder/index.coffee` - Added containsAwait(), wrapAsyncBody(), modified handlers
  - `lib/transforms/functions.coffee` - Preserve async property
  - Moved `specs/pending/async_without_await.txt` to `specs/async_await/`
  - Added `specs/async_await/async_without_await_multiple_returns.txt`

### Key Design Decisions
- Async functions without `await` are transformed to `new Promise((resolve, reject) => ...)` pattern
- This provides a friction-free path from TypeScript to CoffeeScript for edge cases
- `===` is converted to `==` (both are strict equality in CoffeeScript)
- Template literals convert to CoffeeScript string interpolation `"#{...}"`

## Test Suite Status
- **315 passing** (as of last run)
- **44 pending** (intentionally skipped tests in specs/pending/ and specs/legacy_pending/)

## Repository Structure
- `lib/builder/` - Code generation from AST
- `lib/transforms/` - AST transformations
- `specs/` - Test specifications
- `test/` - Test harness

## Coding Standards for This Project
- CoffeeScript throughout (this is a CoffeeScript project!)
- Follow existing code style
- `===` → `==` (CoffeeScript convention)
- Keep tests passing: always run `npm test` before committing
