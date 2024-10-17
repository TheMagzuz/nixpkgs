{ lib, buildDotnetModule, gtk3, love, callPackage, fetchFromGitHub, fetchfossil
, sqlite, lua51Packages, fetchurl, pkg-config, writeShellScript, substituteAll
, nuget, git, libarchive, curl, mono }:
let
  lsqlite3 = callPackage ./lsqlite.nix {
    inherit lib;
    inherit fetchurl;
    inherit fetchfossil;
    inherit sqlite;
    inherit lua51Packages;
  };
  lua-subprocess = callPackage ./lua-subprocess.nix {
    inherit lua51Packages;
    inherit fetchFromGitHub;
  };
  nativefiledialog = callPackage ./nativefiledialog.nix {
    inherit lib;
    inherit lua51Packages;
    inherit fetchFromGitHub;
    inherit gtk3;
    inherit pkg-config;
  };
  find-love = writeShellScript "find-love.sh" ''
    cd "$(dirname "$1")" || exit 1
    ${love}/bin/love --fused "$@"
  '';
in buildDotnetModule rec {
  pname = "olympus";
  version = "0-unstable-2024-09-21";
  sourceRoot = ".";
  projectFile = "./olympus/sharp/Olympus.Sharp.sln";

  srcs = [
    (fetchFromGitHub {
      owner = "EverestAPI";
      repo = "Olympus";
      rev = "97de76e0271ccccb1302e5c8f16ecdf064261025";
      hash = "sha256-GFzrxTWV10g8rA0UVwAOWxIOoFrNjpau4k344kl3zRA=";
      name = "olympus";
    })
    (fetchFromGitHub {
      owner = "EverestAPI";
      repo = "OlympUI";
      rev = "main";
      hash = "sha256-4cv8beVLamcRnr/+L/LU3ZKzZOoqxSwIIwlbgIV4RgQ=";
      name = "OlympUI";
      leaveDotGit = true;
    })
    (fetchFromGitHub {
      owner = "vrld";
      repo = "moonshine";
      rev = "master";
      hash = "sha256-bQX4s9EofFojDpk3ms8S4a2EPHhXRuq/3fBN8OluzrQ=";
      name = "moonshine";
      leaveDotGit = true;
    })
    (fetchFromGitHub {
      owner = "LPGhatguy";
      repo = "luajit-request";
      rev = "master";
      hash = "sha256-SMK2VsHwxgIRd54t01pOOMCni+3pNer6aGfY82Ql9Y0=";
      name = "luajit-request";
      leaveDotGit = true;
    })
  ];

  nugetDeps = ./deps.nix;

  patches = [
    (substituteAll {
      src = ./use-system-mono.patch;
      inherit mono;
    })
  ];

  nativeBuildInputs = [ nuget git libarchive ];

  buildInputs = [ (lib.getLib curl) ];

  makeWrapperArgs =
    [ "--prefix" "LD_LIBRARY_PATH" ":" "${lib.getLib curl}/lib" ];

  preConfigure = ''
    BASE_PATH=$(pwd)
    cd olympus

    cp -rT "$BASE_PATH/OlympUI" src/ui
    cp -rT "$BASE_PATH/moonshine" src/moonshine
    cp -rT "$BASE_PATH/luajit-request" src/luajit-request

    echo ${version} > src/version.txt
    cd $BASE_PATH
  '';

  installPhase = ''
    mkdir -p "$out/bin" "$out/lib" "$out/share/applications" "$out/share/icons/hicolor/128x128/apps"

    cp "olympus/olympus.sh" "$out/lib/olympus"
    cp "${find-love}" "$out/lib/find-love"

    bsdtar --format zip --strip-components 2 -cf "$out/lib/olympus.love" olympus/src

    cp olympus/sharp/bin/Release/net452 "$out/lib/sharp" -rT
    cp "olympus/lib-linux/olympus.desktop" "$out/share/applications"
    cp "olympus/src/data/icon.png" "$out/share/icons/hicolor/128x128/apps/olympus.png"

    cp -r ${lsqlite3}/lib/lua/5.1/* $out/lib
    cp -r ${lua-subprocess}/lib/lua/5.1/* $out/lib
    cp -r ${nativefiledialog}/lib/lua/5.1/* $out/lib
  '';

  meta = {
    description = "Everest installer / mod manager for Celeste";
    homepage = "https://everestapi.github.io/";
    platforms = lib.platforms.unix;
    license = lib.licenses.mit;
    mainProgram = "olympus";
  };

}
