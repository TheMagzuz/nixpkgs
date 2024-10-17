{ lua51Packages, fetchFromGitHub }:
lua51Packages.buildLuarocksPackage {
  pname = "lua-subprocess";
  version = "scm-1";
  rockspecFilename = "subprocess-scm-1.rockspec";
  src = fetchFromGitHub {
    owner = "0x0ade";
    repo = "lua-subprocess";
    rev = "bfa8e97da774141f301cfd1106dca53a30a4de54";
    hash = "sha256-4LiYWB3PAQ/s33Yj/gwC+Ef1vGe5FedWexeCBVSDIV0=";
  };
}
