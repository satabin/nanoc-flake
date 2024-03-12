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
      let
        mkPackage = pkgs: pkgs.callPackage ./nanoc.nix { };
      in
      flake-utils.lib.eachDefaultSystem (system:  let
        pkgs = nixpkgs.legacyPackages.${system};
      in {

        packages.nanoc = mkPackage pkgs;
        defaultPackage = self.packages."${system}".nanoc;

        apps.nanoc = flake-utils.lib.mkApp {
          drv = self.packages."${system}".nanoc;
        };
        apps.default = self.apps."${system}".nanoc;

        devShell = pkgs.mkShell {
          buildInputs = [
            pkgs.nixpkgs-fmt
            pkgs.bundix
          ];
          inputsFrom = builtins.attrValues self.packages.${system};
        };

      }) // {
        overlays.default = final: prev: {
          nanoc = mkPackage final;
        };
      };
}
