with (import <nixpkgs> { });
mkShell {
  buildInputs = with pkgs; [
    nodePackages.purs-tidy
    spago
    purescript
    dhall
    dhall-lsp-server
  ];
  shellHook = "";
}
