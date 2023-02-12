let
  pkgs = import <nixpkgs> {};
  pythonVersion = "310";
  pyPkgs = pkgs."python${pythonVersion}Packages";
  python = pkgs.python310Packages.python;
in {
  pdal-python = pkgs.python310Packages.buildPythonPackage {
    src = ./.;
    pname = "pdal-python";
    version = "3.2.2";
    dontUseCmakeConfigure = true;
    nativeBuildInputs = with pkgs; [
      cmake
      ninja
      pkgconfig
      pyPkgs.scikit-build
      pyPkgs.pybind11
    ];
    checkInputs = [pyPkgs.pytest];
    checkPhase = ''
      PYTHONPATH=$out/${python.sitePackages}:$PYTHONPATH pytest test/
    '';
    propagatedBuildInputs = [pyPkgs.numpy pkgs.pdal pyPkgs.meshio];
  };
}
