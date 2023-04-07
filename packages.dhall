let upstream =
      https://github.com/purescript/package-sets/releases/download/psc-0.15.7-20230319/packages.dhall
        sha256:63aa81db076458010149c90a978717abe63d72455fecfee0397d93f9ff6ea077

in  upstream
  with markup = ./spago.dhall as Location