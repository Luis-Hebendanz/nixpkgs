{ lib, rustPlatform, fetchFromGitHub }:

rustPlatform.buildRustPackage rec {
  pname = "nix-template";
  version = "0.1.0";

  src = fetchFromGitHub {
    owner = "jonringer";
    repo = pname;
    rev = "v${version}";
    sha256 = "1h6xdvhzg7nb0s82b3r5bsh8bfdb1l5sm7fa24lfwd396xp9yyig";
  };

  cargoSha256 = "0hp31b5q4s6grkha2jz55945cbjkqdpvx1l8m49zv5prczhd7mz5";

  meta = with lib; {
    description = "Make creating nix expressions easy";
    homepage = "https://github.com/jonringer/nix-template/";
    changelog = "https://github.com/jonringer/nix-template/releases/tag/v${version}";
    license = licenses.cc0;
    maintainers = with maintainers; [ jonringer ];
  };
}
