{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    flake-utils.url = "github:numtide/flake-utils";
    nix2container.url = "github:nlewo/nix2container";
  };
  outputs = {
    self,
    nixpkgs,
    flake-utils,
    nix2container,
  }:
    flake-utils.lib.eachDefaultSystem (
      system: let
        pkgs = nixpkgs.legacyPackages.${system};
        containerPkgs = nix2container.packages.${system};
        python-pdal = pkgs.callPackage ./default.nix {inherit pkgs;};
        interpreter = pkgs.python310.withPackages (ps: [python-pdal]);
        containerBuildProd = containerPkgs.nix2container.buildImage {
          name = "python-pdal";
          tag = "prod";
          layers = [
            (containerPkgs.nix2container.buildLayer
              {
                deps = [interpreter];
              })
          ];
          config = {
            entrypoint = ["${interpreter}/bin/python" "-i"];
          };
        };
        containerBuild = containerPkgs.nix2container.buildImage {
          name = "python-pdal";
          tag = "dev";
          copyToRoot = pkgs.buildEnv {
            name = "root";
            paths = [pkgs.bashInteractive pkgs.coreutils pkgs.ripgrep pkgs.silver-searcher];
            pathsToLink = ["/bin"];
          };
          layers = [
            (containerPkgs.nix2container.buildLayer
              {
                deps = [interpreter];
              })
          ];
          config = {
            entrypoint = ["${interpreter}/bin/python" "-i"];
          };
        };
      in {
        packages = flake-utils.lib.flattenTree rec {
          inherit python-pdal;
          dev-python-pdal-image = containerBuild;
          prod-python-pdal-image = containerBuildProd;
          default = python-pdal;
        };
        devShells = rec {
          pdal-shell = pkgs.mkShell {buildInputs = [python-pdal];};
          default = pdal-shell;
        };
      }
    );
}
