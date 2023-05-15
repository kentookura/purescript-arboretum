{ name = "api"
, dependencies =
  [ "console", "effect", "httpurple", "prelude", "routing-duplex" ]
, packages = (../../spago.dhall).packages
, sources = [ "src/**/*.purs", "test/**/*.purs" ]
}
