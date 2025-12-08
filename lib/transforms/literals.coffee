{ replace, quote } = require('../helpers')
TransformerBase = require('./base')

###
# Transforms strings, regexes, etc
###

module.exports = class extends TransformerBase

  Literal: (node) ->
    @unpackRegexpIfNeeded(node)

  # Babel-specific: handle RegExpLiteral nodes
  RegExpLiteral: (node) ->
    @unpackRegexpIfNeeded(node)

  ###
  # Accounts for regexps that start with an equal sign or space.
  ###

  unpackRegexpIfNeeded: (node) ->
    # Handle both Esprima format (node.value instanceof RegExp) and Babel format (node.pattern)
    if node.value instanceof RegExp
      pattern = node.value.toString()
      m = pattern.match(/^\/([\s\=].*)\/([a-z]*)$/)
    else if node.pattern?
      # Babel format: check if pattern starts with space or =
      pattern = node.pattern
      flags = node.flags or ''
      regexStr = "/#{pattern}/#{flags}"
      m = regexStr.match(/^\/([\s\=].*)\/([a-z]*)$/)
    else
      return

    if m
      node = replace node,
        type: 'CallExpression'
        callee: { type: 'Identifier', name: 'RegExp' },
        arguments: [
          type: 'StringLiteral'
          value: m[1]
          extra: { raw: quote(m[1]) }
        ]

      if m[2]
        node.arguments.push
          type: 'StringLiteral'
          value: m[2]
          extra: { raw: quote(m[2]) }

      node

