{ name = "frontend"
, dependencies =
  [ "aff"
  , "console"
  , "deku"
  , "effect"
  , "either"
  , "fetch"
  , "fetch-argonaut"
  , "httpurple"
  , "markup"
  , "parsing"
  , "prelude"
  , "routing-duplex"
  , "server"
  , "transformers"
  , "tuples"
  ]
, packages = (../../spago.dhall).packages
, sources = [ "src/**/*.purs", "test/**/*.purs" ]
}
