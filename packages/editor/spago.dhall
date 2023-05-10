{ name = "my-project"
, dependencies =
  [ 
  , "arrays"
  , "bifunctors"
  , "console"
  , "control"
  , "deku"
  , "dissect"
  , "effect"
  , "either"
  , "foldable-traversable"
  , "lists"
  , "maybe"
  , "prelude"
  , "refs"
  , "strings"
  , "textcursor"
  , "transformers"
  , "tuples"
  , "web-events"
  , "web-html"
  , "web-uievents"
  ]
, packages = (../spago.dhall).packages
, sources = [ "src/**/*.purs", "test/**/*.purs" ]
}
