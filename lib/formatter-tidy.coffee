{CompositeDisposable} = require 'atom'

module.exports = FormatterTidy =
  config:
    executablePath:
      title: 'Path to the exectuable'
      type: 'string'
      default: 'tidy'
    argumentsHtml:
      title: 'Arguments passed to the formatter html language'
      type: 'array'
      default: []
      description: ''
    argumentsXml:
      title: 'Arguments passed to the formatter xml language'
      type: 'array'
      default: []
      description: ''

  provideFormatter: ->
    [
      {
        selector: '.text.html.basic'
        getNewText: (text) ->
          child_process = require 'child_process'
          return new Promise (resolve, reject) ->
            command = atom.config.get 'formatter-tidy.executablePath'
            args = atom.config.get 'formatter-tidy.argumentsHtml'
            args.push '--indent'
            args.push 'auto'
            args.push '--quiet'
            args.push 'yes'
            args.push '--show-errors'
            args.push '0'
            args.push '--show-warnings'
            args.push '0'
            args.push '--force-output'
            args.push 'yes'
            args.push '--tidy-mark'
            args.push 'no'
            console.log command, args
            toReturn = []
            process = child_process.spawn(command, args, {})
            process.stdout.on 'data', (data) -> toReturn.push data
            process.stdin.write text
            process.stdin.end()
            process.on 'close', ->
              resolve(toReturn.join('\n'))
      }
      {
        selector: '.text.xml'
        getNewText: (text) ->
          child_process = require 'child_process'
          return new Promise (resolve, reject) ->
            command = atom.config.get 'formatter-tidy.executablePath'
            args = atom.config.get 'formatter-tidy.argumentsXml'
            args.push '-xml'
            args.push '--indent'
            args.push 'auto'
            args.push '--quiet'
            args.push 'yes'
            args.push '--show-errors'
            args.push '0'
            args.push '--show-warnings'
            args.push '0'
            args.push '--force-output'
            args.push 'yes'
            args.push '--tidy-mark'
            args.push 'no'
            toReturn = []
            console.log command, args
            process = child_process.spawn(command, args, {})
            process.stdout.on 'data', (data) -> toReturn.push data
            process.stdin.write text
            process.stdin.end()
            process.on 'close', ->
              resolve(toReturn.join('\n'))
      }
    ]
