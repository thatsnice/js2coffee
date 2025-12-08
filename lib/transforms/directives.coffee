TransformerBase = require('./base')

###
# Converts Babel directives to ExpressionStatements.
#
# Babel treats bare strings like 'use strict' as Directive nodes in the
# program.directives array. Since js2coffee expects these as regular
# ExpressionStatements in program.body, this transform converts them.
#
# This keeps the parsing layer (parseJS) focused on parsing only, while
# AST normalization happens in transforms where it belongs.
###

module.exports = class extends TransformerBase
  # Disable stack tracking - we only need to process the Program node once
  ProgramExit: null
  FunctionExpression: null
  FunctionExpressionExit: null

  Program: (node) ->
    # Convert Babel directives to ExpressionStatements
    if node.directives?.length > 0
      statements = []
      for directive in node.directives
        statements.push
          type: 'ExpressionStatement'
          expression:
            type: 'StringLiteral'
            value: directive.value.value
            extra: directive.value.extra
          range: directive.range
          loc: directive.loc

      # Prepend converted directives to the body
      node.body = statements.concat(node.body)
      delete node.directives

    node
