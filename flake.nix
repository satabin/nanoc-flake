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

        defaultPackage = pkgs.bundlerApp {
          pname = "nanoc";
          gemdir = ./.;
          exes = [ "nanoc" ];

          meta = with lib; {
            description = "Nanoc is a flexible static-site generator";
            longDescription = ''
              Nanoc is a static-site generator, fit for building anything from a small
              personal blog to a large corporate website. 
            '';
            homepage = https://nanoc.ws/;
            license = licenses.mit;
            platforms = platforms.unix;
          };
        };

        devShell = pkgs.mkShell {
          buildInputs = [
            pkgs.nixpkgs-fmt
            pkgs.bundix
          ];
          inputsFrom = builtins.attrValues self.packages.${system};
        };

      });
}
