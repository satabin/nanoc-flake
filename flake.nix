{
  description = "Nanoc static site generator";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-23.11";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs =
    { self
    , nixpkgs
    , flake-utils
    }:
    flake-utils.lib.eachDefaultSystem (system:
      with import nixpkgs { system = system; };
      {

        defaultPackage = pkgs.callPackage ./nanoc.nix { };

        devShell = pkgs.mkShell {
          buildInputs = [
            pkgs.nixpkgs-fmt
            pkgs.bundix
          ];
          inputsFrom = builtins.attrValues self.packages.${system};
        };

        overlays = import ./overlays.nix {inherit inputs;};

      });
}
