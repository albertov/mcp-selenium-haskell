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
      specVersion = "1.12";
      identifier = { name = "base-orphans"; version = "0.9.3"; };
      license = "MIT";
      copyright = "(c) 2012-2017 Simon Hengel,\n(c) 2014-2017 João Cristóvão,\n(c) 2015-2017 Ryan Scott";
      maintainer = "Simon Hengel <sol@typeful.net>,\nJoão Cristóvão <jmacristovao@gmail.com>,\nRyan Scott <ryan.gl.scott@gmail.com>";
      author = "Simon Hengel <sol@typeful.net>,\nJoão Cristóvão <jmacristovao@gmail.com>,\nRyan Scott <ryan.gl.scott@gmail.com>";
      homepage = "https://github.com/haskell-compat/base-orphans#readme";
      url = "";
      synopsis = "Backwards-compatible orphan instances for base";
      description = "@base-orphans@ defines orphan instances that mimic instances available in\nlater versions of @base@ to a wider (older) range of compilers.\n@base-orphans@ does not export anything except the orphan instances\nthemselves and complements @<http://hackage.haskell.org/package/base-compat\nbase-compat>@.\n\nSee the README for what instances are covered:\n<https://github.com/haskell-compat/base-orphans#readme>.\nSee also the\n<https://github.com/haskell-compat/base-orphans#what-is-not-covered what is not covered>\nsection.";
      buildType = "Simple";
    };
    components = {
      "library" = {
        depends = [
          (hsPkgs."base" or (errorHandler.buildDepError "base"))
          (hsPkgs."ghc-prim" or (errorHandler.buildDepError "ghc-prim"))
        ];
        buildable = true;
      };
      tests = {
        "spec" = {
          depends = [
            (hsPkgs."QuickCheck" or (errorHandler.buildDepError "QuickCheck"))
            (hsPkgs."base" or (errorHandler.buildDepError "base"))
            (hsPkgs."base-orphans" or (errorHandler.buildDepError "base-orphans"))
            (hsPkgs."hspec" or (errorHandler.buildDepError "hspec"))
          ];
          build-tools = [
            (hsPkgs.pkgsBuildBuild.hspec-discover.components.exes.hspec-discover or (pkgs.pkgsBuildBuild.hspec-discover or (errorHandler.buildToolDepError "hspec-discover:hspec-discover")))
          ];
          buildable = true;
        };
      };
    };
  } // {
    src = pkgs.lib.mkDefault (pkgs.fetchurl {
      url = "http://hackage.haskell.org/package/base-orphans-0.9.3.tar.gz";
      sha256 = "17a35079c8719014560c028d9805ec1301b900972adf212e00af23fe3ebfabd8";
    });
  }) // {
    package-description-override = "cabal-version: 1.12\n\n-- This file has been generated from package.yaml by hpack version 0.37.0.\n--\n-- see: https://github.com/sol/hpack\n--\n-- hash: 6458bdc7f3a546586fe9f53d2b25831f0ffd55408907fb98a9b8a5cf1a0f64e3\n\nname:                base-orphans\nversion:             0.9.3\nsynopsis:            Backwards-compatible orphan instances for base\ndescription:         @base-orphans@ defines orphan instances that mimic instances available in\n                     later versions of @base@ to a wider (older) range of compilers.\n                     @base-orphans@ does not export anything except the orphan instances\n                     themselves and complements @<http://hackage.haskell.org/package/base-compat\n                     base-compat>@.\n                     .\n                     See the README for what instances are covered:\n                     <https://github.com/haskell-compat/base-orphans#readme>.\n                     See also the\n                     <https://github.com/haskell-compat/base-orphans#what-is-not-covered what is not covered>\n                     section.\ncategory:            Compatibility\nhomepage:            https://github.com/haskell-compat/base-orphans#readme\nbug-reports:         https://github.com/haskell-compat/base-orphans/issues\nauthor:              Simon Hengel <sol@typeful.net>,\n                     João Cristóvão <jmacristovao@gmail.com>,\n                     Ryan Scott <ryan.gl.scott@gmail.com>\nmaintainer:          Simon Hengel <sol@typeful.net>,\n                     João Cristóvão <jmacristovao@gmail.com>,\n                     Ryan Scott <ryan.gl.scott@gmail.com>\ncopyright:           (c) 2012-2017 Simon Hengel,\n                     (c) 2014-2017 João Cristóvão,\n                     (c) 2015-2017 Ryan Scott\nlicense:             MIT\nlicense-file:        LICENSE\nbuild-type:          Simple\ntested-with:\n    GHC == 8.0.2 , GHC == 8.2.2 , GHC == 8.4.4 , GHC == 8.6.5 , GHC == 8.8.4 , GHC == 8.10.7 , GHC == 9.0.2 , GHC == 9.2.8 , GHC == 9.4.8 , GHC == 9.6.6 , GHC == 9.8.2 , GHC == 9.10.1 , GHC == 9.12.1\nextra-source-files:\n    CHANGES.markdown\n    README.markdown\n\nsource-repository head\n  type: git\n  location: https://github.com/haskell-compat/base-orphans\n\nlibrary\n  hs-source-dirs:\n      src\n  ghc-options: -Wall\n  build-depends:\n      base >=4.9 && <5\n    , ghc-prim\n  exposed-modules:\n      Data.Orphans\n  other-modules:\n      Data.Orphans.Prelude\n  default-language: Haskell2010\n\ntest-suite spec\n  type: exitcode-stdio-1.0\n  main-is: Spec.hs\n  hs-source-dirs:\n      test\n  ghc-options: -Wall\n  build-depends:\n      QuickCheck\n    , base >=4.9 && <5\n    , base-orphans\n    , hspec ==2.*\n  build-tool-depends: hspec-discover:hspec-discover == 2.*\n  other-modules:\n      Control.Applicative.OrphansSpec\n      Control.Exception.OrphansSpec\n      Data.Bits.OrphansSpec\n      Data.Foldable.OrphansSpec\n      Data.Monoid.OrphansSpec\n      Data.Traversable.OrphansSpec\n      Data.Version.OrphansSpec\n      Foreign.Storable.OrphansSpec\n      GHC.Fingerprint.OrphansSpec\n      System.Posix.Types.IntWord\n      System.Posix.Types.OrphansSpec\n      Paths_base_orphans\n  default-language: Haskell2010\n";
  }