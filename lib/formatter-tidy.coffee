{CompositeDisposable} = require 'atom'

module.exports = FormatterTidy =
  config:
    a:
      title: 'Path to the exectuable'
      type: 'object'
      properties:
        executablePath:
          title: 'Full path of exectuable'
          type: 'string'
          default: 'tidy'
    html:
      title: 'HTML'
      type: 'object'
      description: 'All parameters for HTML.'
      properties:
        enable:
          title: 'Enable formatter for HTML'
          type: 'boolean'
          default: true
          description: 'Need restart Atom.'
        arguments:
          title: 'Arguments passed to the formatter HTML'
          type: 'array'
          default: []
          description: 'Example : `[[PRINT EXAMPLE]]`.'
    xml:
      title: 'XML'
      type: 'object'
      description: 'All parameters for XML.'
      properties:
        enable:
          title: 'Enable formatter for XML'
          type: 'boolean'
          default: true
          description: 'Need restart Atom.'
        arguments:
          title: 'Arguments passed to the formatter XML'
          type: 'array'
          default: []
          description: 'Example : `[[PRINT EXAMPLE]]`.'

  provideFormatter: ->
    [
      {
        selector: '.text.html.basic, text.html.gohtml, text.html.ruby, text.html.mustache, text.html.erb'
        getNewText: (text) ->
          child_process = require 'child_process'
          return new Promise (resolve, reject) ->
            command = atom.config.get 'formatter-tidy.a.executablePath'
            args = atom.config.get 'formatter-tidy.html.arguments'
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
              if toReturn.length isnt 0
                resolve(toReturn.join('\n'))
              else
                atom.notifications.addWarning("An error is occured");
      } if atom.config.get 'formatter-tidy.html.enable'
      {
        selector: '.text.xml, source.plist'
        getNewText: (text) ->
          child_process = require 'child_process'
          return new Promise (resolve, reject) ->
            command = atom.config.get 'formatter-tidy.a.executablePath'
            args = atom.config.get 'formatter-tidy.xml.arguments'
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
              if toReturn.length isnt 0
                resolve(toReturn.join('\n'))
              else
                atom.notifications.addWarning("An error is occured");
      } if atom.config.get 'formatter-tidy.xml.enable'
    ]
