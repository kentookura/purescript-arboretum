let upstream =
      https://github.com/purescript/package-sets/releases/download/psc-0.15.8-20230508/packages.dhall
        sha256:968d8a0fe4e883bc13727e8d79dae8974732cde98971b883b55109d06c320ffe

in  upstream
  with markup = ./packages/markup/spago.dhall as Location
  with editor = ./packages/editor/spago.dhall as Location
  with server = ./packages/server/spago.dhall as Location
  with frontend = ./packages/frontend/spago.dhall as Location
  with supabase =
    { repo = "https://github.com/rowtype-yoga/purescript-supabase.git"
    , version = "3d7a27063bbe2d73daed29436616a5aa3fd16cf9"
    , dependencies =
      [ "aff"
      , "aff-promise"
      , "console"
      , "datetime"
      , "effect"
      , "either"
      , "exceptions"
      , "fetch"
      , "fetch-core"
      , "foldable-traversable"
      , "foreign"
      , "functions"
      , "lists"
      , "maybe"
      , "nullable"
      , "prelude"
      , "react-basic-hooks"
      , "record"
      , "record-studio"
      , "transformers"
      , "tuples"
      , "typelevel-prelude"
      , "unsafe-coerce"
      , "unsafe-reference"
      , "untagged-union"
      , "web-file"
      , "yoga-json"
      ]
    }
  with textcursor =
    { repo = "https://github.com/kentookura/purescript-textcursor"
    , version = "d28273cdf86d17088be0d29efbfbc42053330117"
    , dependencies =
      [ "arrays"
      , "control"
      , "effect"
      , "foldable-traversable"
      , "gen"
      , "maybe"
      , "newtype"
      , "prelude"
      , "profunctor-lenses"
      , "quickcheck"
      , "strings"
      , "tailrec"
      , "transformers"
      , "web-dom"
      , "web-events"
      , "web-html"
      ]
    }
