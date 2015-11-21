{ nixpkgs ? import <nixpkgs> {}, compiler ? "default" }:

let

  inherit (nixpkgs) pkgs;

  f = { mkDerivation, base, hspec, mono-traversable, network-uri
      , semigroups, stdenv, text, yesod, yesod-core, yesod-test
      }:
      mkDerivation {
        pname = "yesod-csp";
        version = "0.1.1.0";
        src = ./.;
        libraryHaskellDepends = [
          base mono-traversable network-uri semigroups text yesod yesod-core
        ];
        testHaskellDepends = [
          base hspec network-uri semigroups yesod yesod-test
        ];
        description = "Add CSP headers to Yesod apps";
        license = stdenv.lib.licenses.mit;
      };

  haskellPackages = if compiler == "default"
                       then pkgs.haskellPackages
                       else pkgs.haskell.packages.${compiler};

  drv = haskellPackages.callPackage f {};

in

  if pkgs.lib.inNixShell then drv.env else drv
