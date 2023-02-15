{ name = "my-project"
, dependencies =
  [ "aff"
  , "bifunctors"
  , "console"
  , "control"
  , "effect"
  , "foldable-traversable"
  , "halogen"
  , "lists"
  , "maybe"
  , "prelude"
  , "quickcheck"
  , "test-unit"
  , "tuples"
  , "gen"
  , "strings"
  , "tailrec"
  ]
, packages = ./packages.dhall
, sources = [ "src/**/*.purs", "test/**/*.purs" ]
}
