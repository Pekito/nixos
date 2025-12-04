# Custom packages, that can be defined similarly to ones from nixpkgs
# You can build them using 'nix build .#example'
pkgs: {
  nodejs-22_18 = pkgs.callPackage ./nodejs-22_18 { };
}
