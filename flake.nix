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

      packages.ruby-lexer-1 = pkgs.writeShellApplication {
        name = "ruby-lexer-1";
        runtimeInputs = with pkgs; [ruby];
        text = ''
          dir=${./ruby-lexer-1}
          ruby "$dir/TestTinyLexer.rb" "$0"
        '';
      };
      packages.ruby-parser-2 = pkgs.writeShellApplication {
        name = "ruby-parser-2";
        runtimeInputs = with pkgs; [ruby];
        text = ''
          dir=${./ruby-parser-2}
          ruby "$dir/main.rb" "$0"
        '';
      };
    });
}
