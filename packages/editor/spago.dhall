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
  , "transformers"
  , "tuples"
  , "web-events"
  , "web-html"
  , "web-uievents"
  ]
, packages = ../../packages.dhall
, sources = [ "src/**/*.purs", "test/**/*.purs" ]
}
