{ name = "frontend"
, dependencies =
  [ "aff"
  , "api"
  , "argonaut"
  , "argonaut-codecs"
  , "argonaut-generic"
  , "console"
  , "deku"
  , "effect"
  , "either"
  , "fetch"
  , "fetch-argonaut"
  , "fetch-yoga-json"
  , "httpurple"
  , "httpurple-argonaut"
  , "markup"
  , "parsing"
  , "prelude"
  , "routing-duplex"
  , "transformers"
  , "tuples"
  ]
, packages = (../../spago.dhall).packages
, sources = [ "src/**/*.purs", "test/**/*.purs" ]
}
