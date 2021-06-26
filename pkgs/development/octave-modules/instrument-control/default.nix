{ buildOctavePackage
, lib
, fetchurl
}:

buildOctavePackage rec {
  pname = "instrument-control";
  version = "0.7.0";

  src = fetchurl {
    url = "mirror://sourceforge/octave/${pname}-${version}.tar.gz";
    sha256 = "0cdnnbxihz7chdkhkcgy46pvkij43z9alwr88627z7jaiaah6xby";
  };

  meta = with lib; {
    homepage = "https://octave.sourceforge.io/instrument-control/index.html";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ KarlJoad ];
    description = "Low level I/O functions for serial, i2c, spi, parallel, tcp, gpib, vxi11, udp and usbtmc interfaces";
  };
}
