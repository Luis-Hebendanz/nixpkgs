{ lib, stdenv, fetchurl, makeWrapper, openjdk11_headless, nixosTests }:

stdenv.mkDerivation rec {
  pname = "graylog";
  version = "4.0.7";

  src = fetchurl {
    url = "https://packages.graylog2.org/releases/graylog/graylog-${version}.tgz";
    sha256 = "sha256-sZn/ug4oh/SHbICbiQeAmtEIwT3++DBWbT2XBkYGYUc=";
  };

  dontBuild = true;
  dontStrip = true;

  nativeBuildInputs = [ makeWrapper ];
  makeWrapperArgs = [ "--set-default" "JAVA_HOME" "${openjdk11_headless}" ];

  passthru.tests = { inherit (nixosTests) graylog; };

  installPhase = ''
    mkdir -p $out
    cp -r {graylog.jar,lib,bin,plugin} $out
    wrapProgram $out/bin/graylogctl $makeWrapperArgs
  '';

  meta = with lib; {
    description = "Open source log management solution";
    homepage    = "https://www.graylog.org/";
    license     = licenses.gpl3;
    platforms   = platforms.unix;
    maintainers = [ maintainers.fadenb ];
  };
}
