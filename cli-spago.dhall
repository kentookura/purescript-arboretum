{ name = "cli"
, dependencies =
  [ "arrays"
  , "console"
  , "effect"
  , "either"
  , "exceptions"
  , "foldable-traversable"
  , "markup"
  , "maybe"
  , "node-buffer"
  , "node-fs"
  , "node-path"
  , "nullable"
  , "optparse"
  , "prelude"
  , "tuples"
  ]
, packages = (./spago.dhall).packages
, sources = [ "cli/**/*.purs" ]
}
