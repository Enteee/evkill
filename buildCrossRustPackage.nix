{
  crossTarget ? "",
  nixpkgsDrv ? import <nixpkgs>,
}:
with nixpkgsDrv {};
let
  crossNixpkgs = (
    if crossTarget != "" && crossTarget != targetPlatform.config then
    (
      nixpkgsDrv {
        crossSystem = {
          config = crossTarget;
        };
      }
    ) else (
      nixpkgsDrv {}
    )
  );

  rustTarget = builtins.trace ''building for Rust target: ${rust.toRustTarget crossNixpkgs.stdenv.targetPlatform}'' rust.toRustTarget crossNixpkgs.stdenv.targetPlatform;

  moz_rust_src = fetchFromGitHub {
    owner = "mozilla";
    repo = "nixpkgs-mozilla";
    rev = "efda5b357451dbb0431f983cca679ae3cd9b9829";
    sha256 = "11wqrg86g3qva67vnk81ynvqyfj0zxk83cbrf0p9hsvxiwxs8469";
  };
  moz_rust = import "${moz_rust_src.out}/rust-overlay.nix" pkgs pkgs;


  rust_channel = moz_rust.rustChannelOfTargets "stable" null [ rustTarget ];

  rustPlatform = crossNixpkgs.makeRustPlatform {
    cargo = rust_channel;
    rustc = rust_channel;
  };
in
  args: rustPlatform.buildRustPackage (
    args // {
      target = rustTarget;
    }
  )

