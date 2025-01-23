{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = {
    self,
    nixpkgs,
    flake-utils,
    ...
  }:
    flake-utils.lib.eachDefaultSystem (system: let
      pkgs = nixpkgs.legacyPackages.${system};
    in {
      devShells.default = self.devShells.${system}.ruby-lexer-1;

      devShells.ruby-lexer-1 = pkgs.mkShellNoCC {
        nativeBuildInputs = with pkgs; [ruby];
      };
    });
}
