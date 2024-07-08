{
  description = "A very basic flake";

  outputs = { nixpkgs, ... }:

    let
      pkgs = nixpkgs.legacyPackages.x86_64-linux;

      src = pkgs.stdenv.mkDerivation {
        name = "video-$url";
        builder = pkgs.writeShellScript "builder.sh" ''
          source $stdenv/setup

          NODE_TLS_REJECT_UNAUTHORIZED=0 \
            ${pkgs.nodejs}/bin/node ${./downloader.mjs}

          mkdir -p "$out"
          mv ./fonts.zip "$out"
        '';
        outputHashAlgo = "sha256";
        outputHash = "sha256-J2rKkLNTlM1ydE8T6ntqZBuF6ZsuG6H+pixkP/CunVs=";
        outputHashMode = "recursive";
      };

      genEiMGothic = pkgs.runCommand "genEiMGothic" { } ''
        ${pkgs.unzip}/bin/unzip ${src}/fonts.zip
        mkdir -p $out/share/fonts
        cp ./GenEiMGothic_v2.0/*.ttf $out/share/fonts
      '';
    in

    {

      packages.x86_64-linux.default = genEiMGothic;

      devShells.x86_64-linux.default = pkgs.mkShellNoCC {
        buildInputs = [ pkgs.nixpkgs-fmt ];
      };

    };
}
