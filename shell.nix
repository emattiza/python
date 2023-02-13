{pkgs ? import <nixpkgs> {}, ...}: let
  package = pkgs.callPackage ./default.nix {};
in
  package.env
