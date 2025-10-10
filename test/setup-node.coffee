# Setup for Node.js built-in test runner
{before} = require 'node:test'
assert = require 'node:assert/strict'

# Make js2coffee globally available immediately
global.js2coffee = require '../index'

# Create Chai-like expect API using Node's assert (set up immediately, not in before hook)
global.expect = (actual) ->
    self =
      actual: actual

      # Chai: expect(x).to.be.an('object')
      be:
        an: (type) ->
          actualType = typeof actual
          actualType = 'array' if Array.isArray(actual)
          assert.equal actualType, type, "Expected #{actual} to be an #{type}"
        a: (type) ->
          actualType = typeof actual
          actualType = 'array' if Array.isArray(actual)
          assert.equal actualType, type, "Expected #{actual} to be a #{type}"

      # Chai: expect(x).eql(y)
      eql: (expected) ->
        # Convert to plain objects for comparison
        actualPlain = JSON.parse(JSON.stringify(actual))
        expectedPlain = JSON.parse(JSON.stringify(expected))
        assert.deepEqual actualPlain, expectedPlain

      # Chai: expect(x).eq(y)
      eq: (expected) ->
        assert.equal actual, expected

      # Chai: expect(x).equals(y)
      equals: (expected) ->
        assert.equal actual, expected

      # Chai: expect(x).exist
      exist:
        get: -> assert.ok actual?, "Expected #{actual} to exist"

      # Chai: expect(x).include(y)
      include: (expected) ->
        assert.ok actual.includes(expected), "Expected '#{actual}' to include '#{expected}'"

      # Chai: expect(x).match(regex)
      match: (regex) ->
        assert.match actual, regex

      # Chai: expect(x).have.length
      have:
        length: (expected) ->
          assert.equal actual.length, expected, "Expected length #{expected}, got #{actual.length}"

      # Chai: expect(fn).to.throw(err)
      throw: (expected) ->
        threw = false
        thrownError = null
        try
          actual()
        catch err
          threw = true
          thrownError = err
          if expected
            if typeof expected == 'string'
              assert.ok err.message.includes(expected), "Expected error message to include '#{expected}', got: #{err.message}"
            else if expected instanceof RegExp
              assert.match err.message, expected

        assert.ok threw, "Expected function to throw"

      to:
        throw: (expected) ->
          self.throw(expected)

      toBeLessThan: (expected) ->
        assert.ok actual < expected, "Expected #{actual} to be less than #{expected}"

      toBeGreaterThan: (expected) ->
        assert.ok actual > expected, "Expected #{actual} to be greater than #{expected}"

    self
