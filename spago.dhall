{ name = "my-project"
, dependencies = 
  [ "console"
  , "effect"
  , "prelude"
  , "halogen" 
  , "bifunctors"
  , "control"
  , "maybe"
  , "tuples"
  ]
, packages = ./packages.dhall
, sources = [ "src/**/*.purs", "test/**/*.purs" ]
}
