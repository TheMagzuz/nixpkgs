{ lib, lua51Packages, fetchFromGitHub, gtk3, pkg-config }:
lua51Packages.buildLuarocksPackage {
  pname = "nativefiledialog";
  version = "1.2.0";
  rockspecFilename = "lua/nfd-scm-1.rockspec";
  src = fetchFromGitHub {
    owner = "Vexatos";
    repo = "nativefiledialog";
    rev = "bea4560b9269bdc142fef946ccd8682450748958";
    hash = "sha256-veCLHTmZU4puZW0NHeWFZa80XKc6w6gxVLjyBmTrejg=";
  };

  externalDeps = [ (lib.getLib gtk3) ];
  buildInputs = [ (lib.getDev gtk3) pkg-config ];
}
