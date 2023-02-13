{pkgs ? import <nixpkgs> {}, ...}:
with pkgs; (
  let
    pdal-python = callPackage ./nix/release.nix {
      inherit (python310Packages) buildPythonPackage numpy meshio scikit-build pybind11 pytest;
    };
  in
    pdal-python
)
