{ lib
, buildPythonPackage
, fetchPypi
, grpc_google_iam_v1
, google-api-core
, libcst
, mock
, proto-plus
, pytestCheckHook
, pytest-asyncio
}:

buildPythonPackage rec {
  pname = "google-cloud-securitycenter";
  version = "1.3.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-cyJ58BPB7mYWbmHFxPAxnf2JX0b8kqLJF4hdcppaNNI=";
  };

  propagatedBuildInputs = [ grpc_google_iam_v1 google-api-core libcst proto-plus ];

  checkInputs = [ mock pytestCheckHook pytest-asyncio ];

  pythonImportsCheck = [
    "google.cloud.securitycenter"
    "google.cloud.securitycenter_v1"
    "google.cloud.securitycenter_v1beta1"
    "google.cloud.securitycenter_v1p1beta1"
  ];

  meta = with lib; {
    description = "Cloud Security Command Center API API client library";
    homepage = "https://github.com/googleapis/python-securitycenter";
    license = licenses.asl20;
    maintainers = with maintainers; [ SuperSandro2000 ];
  };
}
