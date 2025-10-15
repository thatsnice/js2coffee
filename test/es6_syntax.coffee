require './setup'

describe 'ES6/ES2017 syntax support', ->

  describe 'Arrow functions', ->
    it 'converts simple arrow functions', ->
      input = 'const add = (a, b) => a + b;'
      result = js2coffee(input)
      expect(result).include '->'
      expect(result).include 'add = (a, b) ->'

    it 'converts arrow functions with blocks', ->
      input = '''
        const multiply = (a, b) => {
          return a * b;
        };
      '''
      result = js2coffee(input)
      expect(result).include '->'
      expect(result).include 'return'

  describe 'Default parameters', ->
    it 'converts functions with default parameters', ->
      input = 'function greet(name = "World") { return "Hello " + name; }'
      result = js2coffee(input)
      expect(result).include 'name = '
      expect(result).include 'World'
      expect(result).include 'greet'

    it 'converts arrow functions with default parameters', ->
      input = 'const greet = (name = "World") => "Hello " + name;'
      result = js2coffee(input)
      expect(result).include 'name = '
      expect(result).include 'World'

  describe 'Template literals', ->
    it 'converts template literals to CoffeeScript interpolation', ->
      input = 'const msg = `Hello ${name}`;'
      result = js2coffee(input)
      # Should convert to CoffeeScript string interpolation
      expect(result).include '"'
      expect(result).include '#{'

    it 'converts template literals with multiple interpolations', ->
      input = 'const msg = `${greeting} ${name}!`;'
      result = js2coffee(input)
      expect(result).include '#{'

  describe 'Async/await', ->
    it 'converts async functions', ->
      input = '''
        async function fetchData() {
          const data = await getData();
          return data;
        }
      '''
      result = js2coffee(input)
      expect(result).include 'await'
      expect(result).include 'getData()'

    it 'converts async arrow functions', ->
      input = 'const fetch = async () => await getData();'
      result = js2coffee(input)
      expect(result).include 'await'
