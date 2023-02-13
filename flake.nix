{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs";
    flake-utils.url = "github:numtide/flake-utils";
  };
  outputs = {
    self,
    nixpkgs,
    flake-utils,
  }:
    flake-utils.lib.eachDefaultSystem (
      system: let
        pkgs = nixpkgs.legacyPackages.${system};
        python-pdal = pkgs.callPackage ./default.nix {inherit pkgs;};
      in {
        packages = flake-utils.lib.flattenTree rec {
          python-pdal = python-pdal;
          default = python-pdal;
        };
        devShells = rec {
          pdal-shell = pkgs.mkShell {buildInputs = [python-pdal];};
          default = pdal-shell;
        };
      }
    );
}
