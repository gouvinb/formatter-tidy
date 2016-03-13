# formatter-tidy package

Formatter for HTML, XML.

This Formatter plugin for [Formatter](https://atom.io/packages/formatter)
provides an interface to [tidy(-html5)](http://www.html-tidy.org/).

## Installation

1.  Install tidy or tidy-html5
(ex: on OSX with brew -> `brew install tidy-html5`)

2.  Install [Formatter](https://atom.io/packages/formatter) package via Atom

    -   *or with* `apm install formatter`

3.  Install formatter-tidy package via Atom

    -   *or with* `apm install formatter-tidy`

## Usage

### Warning

Tidy is primarily a validator and not a HTML/XML formatter.

### In your source compatible file

Default (inspired from IntelliJ):

```cson
'atom-text-editor':
  'alt-ctrl-l': 'formatter:format-code'
  'alt-cmd-l': 'formatter:format-code'
```

### List of config

-   Path to the exectuable

    -   **Full path** tidy

-   HTML language

    -   Enable formatter for HTML language (*need restart Atom*)

    -   Arguments passed to the formatter HTML language

        -   Example : `--wrap, 160`

-   XML language

    -   Enable formatter for XML language (*need restart Atom*)

    -   Arguments passed to the formatter XML language

        -   Example : `--wrap, 80, --indent-attributes, yes`

## TODO

-   [ ] optimize enable config
-   [ ] cursor position
-   [ ] more optimization ?

## Contributing

1.  Fork it!
2.  Create your feature branch: `git checkout -b my-new-feature`
3.  Commit your changes: `git commit -am 'Add some feature'`
4.  Push to the branch: `git push origin my-new-feature`
5.  Submit a pull request :D

## License

See [LICENSE.md](./LICENSE.md)
