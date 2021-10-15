{
  pkgs ? import (builtins.fetchTarball "https://github.com/NixOS/nixpkgs/archive/bc66bad58ccceccae361e84628702cfc7694efda.tar.gz") {},
  sf ? "0.1"
}:

let

ldbc_snb_data = import (builtins.fetchGit {
  url = "https://github.com/NRHelmi/ldbc_snb_datagen_spark";
  ref = "main";
}) {inherit pkgs sf;};

in with pkgs;
stdenv.mkDerivation rec {
  name = "ldbc_snb_data_converter";
  src = ./.;
  buildInputs = [ wget python38Packages.virtualenv ];

  buildPhase = ''
    mkdir -p $out/{tmp,ldbc_snb_data}
    cp -r --no-preserve=mode,ownership ${ldbc_snb_data}/graphs/csv/raw/composite-merged-fk/* $out/tmp
    
    export LDBC_SNB_DATA=$out/tmp
    touch $LDBC_SNB_DATA/{static,dynamic}/fake.csv

    virtualenv env
    source env/bin/activate

    ./spark-concat.sh $LDBC_SNB_DATA

    ./load.sh $LDBC_SNB_DATA
    ./transform.sh

    cat export/snb-export-only-ids-projected-fk.sql | ./duckdb ldbc.duckdb
    cat export/snb-export-only-ids-merged-fk.sql    | ./duckdb ldbc.duckdb

    cp -r data/csv-only-ids-projected-fk/ $out/ldbc_snb_data/social-network-sf${sf}-projected-fk
    cp -r data/csv-only-ids-merged-fk/ $out/ldbc_snb_data/social-network-sf${sf}-merged-fk
  '';
  shellHook = ''
    export LDBC_SNB_DATA="${ldbc_snb_data}"
  '';

  dontInstall = true;
  __noChroot = true;
}