{ system
  , compiler
  , flags
  , pkgs
  , hsPkgs
  , pkgconfPkgs
  , errorHandler
  , config
  , ... }:
  ({
    flags = {};
    package = {
      specVersion = "1.10";
      identifier = { name = "th-abstraction"; version = "0.7.1.0"; };
      license = "ISC";
      copyright = "2017 Eric Mertens";
      maintainer = "emertens@gmail.com";
      author = "Eric Mertens";
      homepage = "https://github.com/glguy/th-abstraction";
      url = "";
      synopsis = "Nicer interface for reified information about data types";
      description = "This package normalizes variations in the interface for\ninspecting datatype information via Template Haskell\nso that packages and support a single, easier to use\ninformational datatype while supporting many versions\nof Template Haskell.";
      buildType = "Simple";
    };
    components = {
      "library" = {
        depends = [
          (hsPkgs."base" or (errorHandler.buildDepError "base"))
          (hsPkgs."ghc-prim" or (errorHandler.buildDepError "ghc-prim"))
          (hsPkgs."template-haskell" or (errorHandler.buildDepError "template-haskell"))
          (hsPkgs."containers" or (errorHandler.buildDepError "containers"))
        ];
        buildable = true;
      };
      tests = {
        "unit-tests" = {
          depends = [
            (hsPkgs."th-abstraction" or (errorHandler.buildDepError "th-abstraction"))
            (hsPkgs."base" or (errorHandler.buildDepError "base"))
            (hsPkgs."containers" or (errorHandler.buildDepError "containers"))
            (hsPkgs."template-haskell" or (errorHandler.buildDepError "template-haskell"))
          ];
          buildable = true;
        };
      };
    };
  } // {
    src = pkgs.lib.mkDefault (pkgs.fetchurl {
      url = "http://hackage.haskell.org/package/th-abstraction-0.7.1.0.tar.gz";
      sha256 = "f9b6184aba4c6b61dd0d96f7dad41a4c9db0a01d3cdbf993a7d860488f1c04c5";
    });
  }) // {
    package-description-override = "name:                th-abstraction\r\nversion:             0.7.1.0\r\nx-revision: 1\r\nsynopsis:            Nicer interface for reified information about data types\r\ndescription:         This package normalizes variations in the interface for\r\n                     inspecting datatype information via Template Haskell\r\n                     so that packages and support a single, easier to use\r\n                     informational datatype while supporting many versions\r\n                     of Template Haskell.\r\nlicense:             ISC\r\nlicense-file:        LICENSE\r\nauthor:              Eric Mertens\r\nmaintainer:          emertens@gmail.com\r\ncopyright:           2017 Eric Mertens\r\nhomepage:            https://github.com/glguy/th-abstraction\r\nbug-reports:         https://github.com/glguy/th-abstraction/issues\r\ncategory:            Development\r\nbuild-type:          Simple\r\nextra-source-files:  ChangeLog.md README.md\r\ncabal-version:       >=1.10\r\ntested-with:         GHC==9.12.1, GHC==9.10.1, GHC==9.8.4, GHC==9.6.6, GHC==9.4.8, GHC==9.2.8, GHC==9.0.2, GHC==8.10.7, GHC==8.8.4, GHC==8.6.5, GHC==8.4.4, GHC==8.2.2, GHC==8.0.2\r\n\r\nsource-repository head\r\n  type: git\r\n  location: https://github.com/glguy/th-abstraction.git\r\n\r\nlibrary\r\n  exposed-modules:     Language.Haskell.TH.Datatype\r\n                       Language.Haskell.TH.Datatype.TyVarBndr\r\n  other-modules:       Language.Haskell.TH.Datatype.Internal\r\n  build-depends:       base             >=4.9   && <5,\r\n                       ghc-prim,\r\n                       template-haskell >=2.11  && <2.24,\r\n                       containers       >=0.4   && <0.9\r\n  hs-source-dirs:      src\r\n  default-language:    Haskell2010\r\n\r\n  if impl(ghc >= 9.0)\r\n    -- these flags may abort compilation with GHC-8.10\r\n    -- https://gitlab.haskell.org/ghc/ghc/-/merge_requests/3295\r\n    ghc-options: -Winferred-safe-imports -Wmissing-safe-haskell-mode\r\n\r\ntest-suite unit-tests\r\n  other-modules:       Harness\r\n                       Types\r\n  type:                exitcode-stdio-1.0\r\n  main-is:             Main.hs\r\n  build-depends:       th-abstraction, base, containers, template-haskell\r\n  hs-source-dirs:      test\r\n  default-language:    Haskell2010\r\n\r\n  if impl(ghc >= 8.6)\r\n    ghc-options:       -Wno-star-is-type\r\n";
  }