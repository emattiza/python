let
  pkgs = import <nixpkgs> {};
in
  with pkgs; (
    let
      pdal-python = callPackage ./nix/release.nix {
        inherit (python310Packages) buildPythonPackage numpy meshio scikit-build pybind11 pytest;
      };
    in
      python310.withPackages (ps: [ps.numpy pdal-python])
  )
