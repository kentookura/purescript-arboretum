let upstream =
      https://github.com/purescript/package-sets/releases/download/psc-0.15.8-20230508/packages.dhall
        sha256:968d8a0fe4e883bc13727e8d79dae8974732cde98971b883b55109d06c320ffe

in  upstream
  with markup = ./packages/markup/spago.dhall as Location
  with editor = ./packages/editor/spago.dhall as Location
  with cli = ./packages/cli/spago.dhall as Location
  with server = ./packages/server/spago.dhall as Location
  with frontend = ./packages/frontend/spago.dhall as Location
  with api = ./packages/api/spago.dhall as Location
