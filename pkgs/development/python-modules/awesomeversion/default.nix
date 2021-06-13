{ lib
, buildPythonPackage
, fetchFromGitHub
, pytestCheckHook
, pythonOlder
, requests
}:

buildPythonPackage rec {
  pname = "awesomeversion";
  version = "21.5.0";
  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "ludeeus";
    repo = pname;
    rev = version;
    sha256 = "sha256-0EOGWJZyvcRJyOqkcISvjL7o6lIaCwMKLftshsQCR6E=";
  };

  postPatch = ''
    substituteInPlace setup.py --replace "main" ${version}
  '';

  propagatedBuildInputs = [ requests ];

  checkInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [ "awesomeversion" ];

  meta = with lib; {
    description = "Python module to deal with versions";
    homepage = "https://github.com/ludeeus/awesomeversion";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
