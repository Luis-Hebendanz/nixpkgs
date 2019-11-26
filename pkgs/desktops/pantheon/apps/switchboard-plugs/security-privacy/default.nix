{ stdenv
, fetchFromGitHub
, pantheon
, meson
, python3
, ninja
, pkgconfig
, vala
, libgee
, granite
, gtk3
, glib
, polkit
, zeitgeist
, switchboard
, lightlocker
}:

stdenv.mkDerivation rec {
  pname = "switchboard-plug-security-privacy";
  version = "2.2.2";

  src = fetchFromGitHub {
    owner = "elementary";
    repo = pname;
    rev = version;
    sha256 = "1dwq9rqswgnnglhrgcpvrp6shn3pb4x8f8f23x84sqakb430idp7";
  };

  passthru = {
    updateScript = pantheon.updateScript {
      repoName = pname;
    };
  };

  nativeBuildInputs = [
    meson
    ninja
    pkgconfig
    python3
    vala
  ];

  buildInputs = [
    glib
    granite
    gtk3
    libgee
    polkit
    switchboard
    zeitgeist
  ];

  patches = [
    ./hardcode-gsettings.patch
  ];

  postPatch = ''
    chmod +x meson/post_install.py
    patchShebangs meson/post_install.py

    substituteInPlace src/Views/LockPanel.vala \
      --subst-var-by LIGHTLOCKER_GSETTINGS_PATH ${glib.getSchemaPath lightlocker}
    substituteInPlace src/Views/FirewallPanel.vala \
      --subst-var-by SWITCHBOARD_SEC_PRIV_GSETTINGS_PATH ${glib.makeSchemaPath "$out" "${pname}-${version}"}
  '';

  meta = with stdenv.lib; {
    description = "Switchboard Security & Privacy Plug";
    homepage = https://github.com/elementary/switchboard-plug-security-privacy;
    license = licenses.lgpl3Plus;
    platforms = platforms.linux;
    maintainers = pantheon.maintainers;
  };

}
