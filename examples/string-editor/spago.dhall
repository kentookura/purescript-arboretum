let config = ../../spago.dhall

in      config
    //  { sources = config.sources # [ "examples/string-editor/**/*.purs" ]
        , dependencies = [ "console", "deku", "editor", "effect", "prelude" ]
        }
