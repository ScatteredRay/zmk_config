{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=566e53c2ad750c84f6d31f9ccb9d00f823165550";
    zmk-moergo = {
      #url = "github:moergo-sc/zmk?ref=zmk-update";
      url = "github:scatteredray/zmk?ref=zmk-update";
      flake = false;
    };
  };

  outputs = { self, nixpkgs, zmk-moergo }:
    let
      pkgs = import nixpkgs {
        system = "x86_64-linux";
      };
      zmkPkg = import zmk-moergo {
        inherit pkgs;
      };
      zmk = zmkPkg.zmk;
    in {
      packages.x86_64-linux = (pkgs.callPackage ./default.nix {
        inherit pkgs zmk;
      });
      devShells.x86_64-linux.default = pkgs.mkShell {
        shellHook = ''
          ${pkgs.zsh}/bin/zsh
          exit
        '';
        inputsFrom = [
          self.packages.x86_64-linux.default
        ];
      };
    };
}
