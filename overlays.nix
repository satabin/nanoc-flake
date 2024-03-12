{inputs, ...}: {
  additions = final: _prev: import ../nanoc.nix {pkgs = final;};

  packages = final: _prev: {
    stable = import inputs.nixpkgs {
      system = final.system;
    };
  };
}
