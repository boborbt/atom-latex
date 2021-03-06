_ = require "underscore-plus"
path = require "path"

module.exports =
class Builder
  constructor: ->
    @envPathKey = switch process.env.platform
      when "win32" then "Path"
      else "PATH"

  run: (args, callback) -> null
  constructArgs: (filePath) -> null
  parseLogFile: (texFilePath) -> null

  constructChildProcessOptions: ->
    env = _.clone(process.env)
    childPath = @constructPath()
    env[@envPathKey] = childPath if childPath?.length
    options = env: env

  constructPath: ->
    texPath = atom.config.get("latex.texPath")
    texPath?.replace("$PATH", process.env[@envPathKey])

  resolveLogFilePath: (texFilePath) ->
    outputDirectory = atom.config.get("latex.outputDirectory") ? ""
    currentDirectory = path.dirname(texFilePath)
    fileName = path.basename(texFilePath).replace(/\.tex$/, ".log")
    logFilePath = path.join(currentDirectory, outputDirectory, fileName)
