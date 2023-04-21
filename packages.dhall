let upstream =
      https://github.com/purescript/package-sets/releases/download/psc-0.15.8-20230420/packages.dhall
        sha256:01f6ef030637be27a334e8f0977d563f9699543f596d60e8fb067e4f60d2e571

in  upstream
  with markup = ./spago.dhall as Location
