{ name = "cli"
, dependencies =
  [ "aff"
  , "affjax"
  , "affjax-node"
  , "arrays"
  , "console"
  , "effect"
  , "either"
  , "exceptions"
  , "foldable-traversable"
  , "markup"
  , "maybe"
  , "node-buffer"
  , "node-fs"
  , "node-fs-aff"
  , "node-path"
  , "nullable"
  , "optparse"
  , "parsing"
  , "prelude"
  , "tuples"
  ]
, packages = (./spago.dhall).packages
, sources = [ "cli/**/*.purs" ]
}
