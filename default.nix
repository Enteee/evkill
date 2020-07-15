{
  crossTarget ? "",
  nixpkgsDrv ? (
    import (builtins.fetchGit {
      # Descriptive name to make the store path easier to identify
      name = "nixos-unstable";
      url = "https://github.com/nixos/nixpkgs-channels/";

      # Commit hash :
      # `git ls-remote https://github.com/nixos/nixpkgs-channels nixos-20.03`
      ref = "refs/heads/nixos-unstable";
      rev = "840c782d507d60aaa49aa9e3f6d0b0e780912742";
    })
  ),
}:
with nixpkgsDrv {};
let
  buildCrossRustPackage = import ./buildCrossRustPackage.nix {
    inherit crossTarget;
    inherit nixpkgsDrv;
  };
in
buildCrossRustPackage rec {
  pname = "evkill";
  version = "0.0.1";

  src = builtins.path { path = ./.; name = pname; };

  cargoSha256 = "06rnvi2kyi1frj1spxmg2i5iv3niz5m8a120lcn46blffvzl5vxc";

  meta = with stdenv.lib; {
    description = "Silencer for your input event sources";
    homepage = "https://github.com/Enteee/evkill";
    license = licenses.asl20;
    maintainers = [ maintainers.Enteee ];
    platforms = platforms.all;
  };
}
