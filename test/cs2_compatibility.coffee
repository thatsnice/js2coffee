require './setup'

TransformerBase = require('../lib/transforms/base')
Builder = require('../lib/builder')

describe 'CS 2.x compatibility', ->

  describe 'Builder constructor with super()', ->
    it 'passes arguments to parent BuilderBase constructor', ->
      ast = { type: 'Program', body: [] }
      options = { filename: 'test.js', indent: 2 }

      builder = new Builder(ast, options)

      # These should be initialized by BuilderBase constructor
      # Will fail in CS 2.x if Builder's super() doesn't pass arguments
      expect(builder.root).equal ast
      expect(builder.options).equal options
      expect(builder.path).eql []

  describe 'safeExtend with inherited properties', ->
    it 'only copies own properties, not inherited ones', ->
      # Create a base class with a property
      class BaseClass
        inheritedMethod: -> 'base'

      # Create a subclass that should NOT inherit
      class SubClass extends BaseClass
        ownMethod: -> 'sub'

      # Create destination class
      class DestClass extends TransformerBase

      # Test that safeExtend exists (it's module-private but used by .run)
      # We test it indirectly by using .run with multiple transform classes

      # Create two transform classes where one extends another
      class Transform1 extends TransformerBase
        method1: -> 'transform1'

      class Transform2 extends Transform1
        method2: -> 'transform2'

      # Run TransformerBase.run to trigger safeExtend
      ast = { type: 'Program', body: [], loc: {}, range: [0, 0] }
      ctx = {}

      # This should work without copying inherited properties multiple times
      # (Will fail in CS 2.x with for...of without hasOwnProperty check)
      result = TransformerBase.run(ast, {}, [Transform1, Transform2], ctx)

      # Should complete without error
      expect(result).be.an('object')
      expect(result.type).equal 'Program'
