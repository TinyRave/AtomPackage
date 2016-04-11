fs = require 'fs'
CoffeeScript = require 'coffee-script'

module.exports.coffeeSourceToMappedJS = (coffeeSource, filename, path) ->
  compilerResult = CoffeeScript.compile(coffeeSource, {
    bare: true
    filename: filename
    sourceMap: true
    sourceFiles: [path]
    generatedFile: 'eval'
    inline: true
  })

  jsSource = compilerResult.js
  dataURI = 'data:application/json;charset=utf-8,' + encodeURI(compilerResult.v3SourceMap)

  # Final result
  {
    source: "#{jsSource}\n//# sourceMappingURL=#{dataURI}"
    sourceMap: JSON.parse(compilerResult.v3SourceMap)
  }

module.exports.coffeeFileToMappedJS = (path, filename) ->
  coffeeSource = fs.readFileSync(path, 'utf8')
  module.exports.coffeeSourceToMappedJS(coffeeSource, filename, path).source
