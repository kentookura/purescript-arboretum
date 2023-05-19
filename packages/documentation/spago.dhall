{ name = "documentation"
, dependencies =
  [ "aff"
  , "arrays"
  , "bifunctors"
  , "control" 
  , "console"
  , "decimals"
  , "deku"
  , "effect"
  , "either"
  , "filterable"
  , "foldable-traversable"
  , "foreign"
  , "hyrule"
  , "integers"
  , "lists"
  , "maybe"
  , "newtype"
  , "nonempty"
  , "ordered-collections"
  , "parsing"
  , "prelude"
  , "qualified-do"
  , "quantities"
  , "record"
  , "refs"
  , "routing"
  , "routing-duplex"
  , "strings"
  , "transformers"
  , "tuples"
  , "unfoldable"
  , "web-dom"
  , "web-events"
  , "web-html"
  , "web-uievents"
  , "yoga-json"
  , "markup"
  , "editor"
  ]
, packages = (../..spago.dhall).packages
, sources = [ "src/**/*.purs", "test/**/*.purs" ]
}
