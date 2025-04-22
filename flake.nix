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
      devShells.default = self.devShells.${system}.racket;

      devShells.ruby = pkgs.mkShellNoCC {
        nativeBuildInputs = with pkgs; [ruby];
      };
      devShells.racket = pkgs.mkShellNoCC {
        nativeBuildInputs = with pkgs; [racket-minimal];
      };

      packages.ruby-lexer-1 = pkgs.writeShellApplication {
        name = "ruby-lexer-1";
        runtimeInputs = with pkgs; [ruby];
        text = ''
          dir=${./ruby-lexer-1}
          ruby "$dir/TestTinyLexer.rb" "$0"
        '';
      };
      packages.ruby-parser-1 = pkgs.writeShellApplication {
        name = "ruby-parser-1";
        runtimeInputs = with pkgs; [ruby];
        text = ''
          dir=${./ruby-parser-1}
          ruby "$dir/main.rb" "$0"
        '';
      };
      packages.ruby-parser-2 = pkgs.writeShellApplication {
        name = "ruby-parser-2";
        runtimeInputs = with pkgs; [ruby];
        text = ''
          dir=${./ruby-parser-2}
          ruby "$dir/main.rb" "$1"
        '';
      };
      packages.scheme-interpreter = pkgs.writeShellApplication {
        name = "scheme-interpreter";
        runtimeInputs = with pkgs; [racket-minimal];
        text = ''
          dir="${./scheme-interpreter}"
          pushd $dir >/dev/null 2>/dev/null
          racket main.rkt
          popd >/dev/null 2>/dev/null
        '';
      };
      packages.ada-subtypes = pkgs.stdenv.mkDerivation {
        name = "ada-subtypes";
        src = ./ada-subtypes;
        nativeBuildInputs = [pkgs.gnat14];
        buildPhase = ''
          gnatmake main.adb
        '';
        installPhase = ''
          mkdir -p $out/bin
          cp main $out/bin/ada-subtypes
        '';
      };
    });
}
