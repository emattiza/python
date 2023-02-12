{
  pkgs,
  buildPythonPackage,
  scikit-build,
  pybind11,
  pytest,
  python,
  numpy,
  meshio,
  ...
}:
buildPythonPackage rec {
  src = ../.;
  pname = "pdal-python";
  version = "3.2.2";
  dontUseCmakeConfigure = true;
  nativeBuildInputs = with pkgs; [
    cmake
    ninja
    pkgconfig
    scikit-build
    pybind11
  ];
  checkInputs = [pytest];
  checkPhase = ''
    PYTHONPATH=$out/${python.sitePackages}:$PYTHONPATH pytest test/
  '';
  propagatedBuildInputs = [numpy pkgs.pdal] ++ passthru.optional-dependencies.meshio;
  passthru.optional-dependencies = {
    meshio = [meshio];
  };
}
