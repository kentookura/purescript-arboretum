{-
Welcome to a Spago project!
You can edit this file as you like.

Need help? See the following resources:
- Spago documentation: https://github.com/purescript/spago
- Dhall language tour: https://docs.dhall-lang.org/tutorials/Language-Tour.html

When creating a new Spago project, you can use
`spago init --no-comments` or `spago init -C`
to generate this file without the comments in this block.
-}
{ name = "my-project"
, dependencies =
  [ "aff"
  , "affjax"
  , "affjax-web"
  , "arrays"
  , "assert"
  , "bifunctors"
  , "console"
  , "control"
  , "datetime"
  , "decimals"
  , "deku"
  , "effect"
  , "either"
  , "enums"
  , "filterable"
  , "foldable-traversable"
  , "foreign"
  , "functors"
  , "group"
  , "hyrule"
  , "identity"
  , "integers"
  , "lists"
  , "maybe"
  , "newtype"
  , "nonempty"
  , "nullable"
  , "ordered-collections"
  , "parsing"
  , "partial"
  , "precise"
  , "prelude"
  , "qualified-do"
  , "quantities"
  , "random"
  , "record"
  , "refs"
  , "routing"
  , "routing-duplex"
  , "scribblet"
  , "strings"
  , "test-unit"
  , "transformers"
  , "tuples"
  , "typelevel-prelude"
  , "unfoldable"
  , "unicode"
  , "web-dom"
  , "web-events"
  , "web-html"
  , "web-uievents"
  , "yoga-json"
  ]
, packages = ../packages.dhall
, sources = [ "src/**/*.purs", "test/**/*.purs" ]
}
