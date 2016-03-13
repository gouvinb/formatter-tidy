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
          description: 'Example : `--wrap, 160`.'
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
          description: 'Example : `--wrap, 80, --indent-attributes, yes`.'

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
            toReturn = []
            toReturnErr = []
            process = child_process.spawn(command, args, {})
            process.stderr.on 'data', (data) -> toReturnErr.push data
            process.stdout.on 'data', (data) -> toReturn.push data
            process.stdin.write text
            process.stdin.end()
            process.on 'close', ->
              if toReturn.length isnt 0
                resolve(toReturn.join('\n'))
              else
                atom.notifications.addWarning(toReturnErr.join('\n'));
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
            toReturn = []
            toReturnErr = []
            process = child_process.spawn(command, args, {})
            process.stderr.on 'data', (data) -> toReturnErr.push data
            process.stdout.on 'data', (data) -> toReturn.push data
            process.stdin.write text
            process.stdin.end()
            process.on 'close', ->
              if toReturn.length isnt 0
                resolve(toReturn.join('\n'))
              else
                atom.notifications.addError('formatter-tidy : error', {dismissable: true, detail: toReturnErr.join('\n')});
      } if atom.config.get 'formatter-tidy.xml.enable'
    ]
