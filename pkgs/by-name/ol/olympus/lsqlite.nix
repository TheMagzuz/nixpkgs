{ lib, fetchurl, fetchfossil, sqlite, lua51Packages }:
lua51Packages.buildLuarocksPackage {
  pname = "lsqlite3";
  version = "0.9.6-1";
  knownRockspec = (fetchurl {
    url = "mirror://luarocks/lsqlite3-0.9.6-1.rockspec";
    hash = "sha256-yazriTTLeH1ZM1kDpIs+TZaFRbheb6wfEWLK8P/lKb8=";
  }).outPath;
  src = fetchfossil {
    url = "http://lua.sqlite.org";
    rev = "v0.9.6";
    hash = "sha256-Mq409A3X9/OS7IPI/KlULR6ZihqnYKk/mS/W/2yrGBg=";
  };
  externalDeps = [ (lib.getDev sqlite) (lib.getLib sqlite) ];
  buildInputs = [ (lib.getLib sqlite) ];

  env = { "SQLITE_INCDIR" = "${lib.getDev sqlite}/include"; };
}
