{
  pkgs,
  cmake,
  ninja,
  pkgconfig,
  pdal,
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
  nativeBuildInputs = [
    cmake
    ninja
    pkgconfig
    scikit-build
    pybind11
  ];
  checkInputs = [pytest];
  checkPhase = ''
    PYTHONPATH=$out/${python.sitePackages}:$PYTHONPATH ${pytest}/bin/pytest test/
  '';
  propagatedBuildInputs = [numpy pdal] ++ passthru.optional-dependencies.meshio;
  passthru.optional-dependencies = {
    meshio = [meshio];
  };
}
