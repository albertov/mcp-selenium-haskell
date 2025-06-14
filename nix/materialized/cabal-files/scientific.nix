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
    flags = { integer-simple = false; };
    package = {
      specVersion = "1.10";
      identifier = { name = "scientific"; version = "0.3.8.0"; };
      license = "BSD-3-Clause";
      copyright = "";
      maintainer = "Bas van Dijk <v.dijk.bas@gmail.com>";
      author = "Bas van Dijk";
      homepage = "https://github.com/basvandijk/scientific";
      url = "";
      synopsis = "Numbers represented using scientific notation";
      description = "\"Data.Scientific\" provides the number type 'Scientific'. Scientific numbers are\narbitrary precision and space efficient. They are represented using\n<http://en.wikipedia.org/wiki/Scientific_notation scientific notation>.\nThe implementation uses a coefficient @c :: 'Integer'@ and a base-10 exponent\n@e :: 'Int'@. A scientific number corresponds to the\n'Fractional' number: @'fromInteger' c * 10 '^^' e@.\n\nNote that since we're using an 'Int' to represent the exponent these numbers\naren't truly arbitrary precision. I intend to change the type of the exponent\nto 'Integer' in a future release.\n\nThe main application of 'Scientific' is to be used as the target of parsing\narbitrary precision numbers coming from an untrusted source. The advantages\nover using 'Rational' for this are that:\n\n* A 'Scientific' is more efficient to construct. Rational numbers need to be\nconstructed using '%' which has to compute the 'gcd' of the 'numerator' and\n'denominator'.\n\n* 'Scientific' is safe against numbers with huge exponents. For example:\n@1e1000000000 :: 'Rational'@ will fill up all space and crash your\nprogram. Scientific works as expected:\n\n>>> read \"1e1000000000\" :: Scientific\n1.0e1000000000\n\n* Also, the space usage of converting scientific numbers with huge exponents to\n@'Integral's@ (like: 'Int') or @'RealFloat's@ (like: 'Double' or 'Float')\nwill always be bounded by the target type.";
      buildType = "Simple";
    };
    components = {
      "library" = {
        depends = [
          (hsPkgs."base" or (errorHandler.buildDepError "base"))
          (hsPkgs."binary" or (errorHandler.buildDepError "binary"))
          (hsPkgs."bytestring" or (errorHandler.buildDepError "bytestring"))
          (hsPkgs."containers" or (errorHandler.buildDepError "containers"))
          (hsPkgs."deepseq" or (errorHandler.buildDepError "deepseq"))
          (hsPkgs."hashable" or (errorHandler.buildDepError "hashable"))
          (hsPkgs."integer-logarithms" or (errorHandler.buildDepError "integer-logarithms"))
          (hsPkgs."primitive" or (errorHandler.buildDepError "primitive"))
          (hsPkgs."template-haskell" or (errorHandler.buildDepError "template-haskell"))
          (hsPkgs."text" or (errorHandler.buildDepError "text"))
        ] ++ (if compiler.isGhc && compiler.version.ge "9.0"
          then [
            (hsPkgs."base" or (errorHandler.buildDepError "base"))
          ] ++ pkgs.lib.optional (flags.integer-simple) (hsPkgs."invalid-cabal-flag-settings" or (errorHandler.buildDepError "invalid-cabal-flag-settings"))
          else if flags.integer-simple
            then [
              (hsPkgs."integer-simple" or (errorHandler.buildDepError "integer-simple"))
            ]
            else [
              (hsPkgs."integer-gmp" or (errorHandler.buildDepError "integer-gmp"))
            ]);
        buildable = true;
      };
      tests = {
        "test-scientific" = {
          depends = [
            (hsPkgs."base" or (errorHandler.buildDepError "base"))
            (hsPkgs."binary" or (errorHandler.buildDepError "binary"))
            (hsPkgs."bytestring" or (errorHandler.buildDepError "bytestring"))
            (hsPkgs."QuickCheck" or (errorHandler.buildDepError "QuickCheck"))
            (hsPkgs."scientific" or (errorHandler.buildDepError "scientific"))
            (hsPkgs."smallcheck" or (errorHandler.buildDepError "smallcheck"))
            (hsPkgs."tasty" or (errorHandler.buildDepError "tasty"))
            (hsPkgs."tasty-hunit" or (errorHandler.buildDepError "tasty-hunit"))
            (hsPkgs."tasty-quickcheck" or (errorHandler.buildDepError "tasty-quickcheck"))
            (hsPkgs."tasty-smallcheck" or (errorHandler.buildDepError "tasty-smallcheck"))
            (hsPkgs."text" or (errorHandler.buildDepError "text"))
          ];
          buildable = true;
        };
      };
      benchmarks = {
        "bench-scientific" = {
          depends = [
            (hsPkgs."base" or (errorHandler.buildDepError "base"))
            (hsPkgs."criterion" or (errorHandler.buildDepError "criterion"))
            (hsPkgs."scientific" or (errorHandler.buildDepError "scientific"))
          ];
          buildable = true;
        };
      };
    };
  } // {
    src = pkgs.lib.mkDefault (pkgs.fetchurl {
      url = "http://hackage.haskell.org/package/scientific-0.3.8.0.tar.gz";
      sha256 = "13b343bca8aa26d7718e52e622e5a118056653edafcbc7ccc5333be7217218cf";
    });
  }) // {
    package-description-override = "name:               scientific\nversion:            0.3.8.0\nx-revision:         2\nsynopsis:           Numbers represented using scientific notation\ndescription:\n  \"Data.Scientific\" provides the number type 'Scientific'. Scientific numbers are\n  arbitrary precision and space efficient. They are represented using\n  <http://en.wikipedia.org/wiki/Scientific_notation scientific notation>.\n  The implementation uses a coefficient @c :: 'Integer'@ and a base-10 exponent\n  @e :: 'Int'@. A scientific number corresponds to the\n  'Fractional' number: @'fromInteger' c * 10 '^^' e@.\n  .\n  Note that since we're using an 'Int' to represent the exponent these numbers\n  aren't truly arbitrary precision. I intend to change the type of the exponent\n  to 'Integer' in a future release.\n  .\n  The main application of 'Scientific' is to be used as the target of parsing\n  arbitrary precision numbers coming from an untrusted source. The advantages\n  over using 'Rational' for this are that:\n  .\n  * A 'Scientific' is more efficient to construct. Rational numbers need to be\n  constructed using '%' which has to compute the 'gcd' of the 'numerator' and\n  'denominator'.\n  .\n  * 'Scientific' is safe against numbers with huge exponents. For example:\n  @1e1000000000 :: 'Rational'@ will fill up all space and crash your\n  program. Scientific works as expected:\n  .\n  >>> read \"1e1000000000\" :: Scientific\n  1.0e1000000000\n  .\n  * Also, the space usage of converting scientific numbers with huge exponents to\n  @'Integral's@ (like: 'Int') or @'RealFloat's@ (like: 'Double' or 'Float')\n  will always be bounded by the target type.\n\nhomepage:           https://github.com/basvandijk/scientific\nbug-reports:        https://github.com/basvandijk/scientific/issues\nlicense:            BSD3\nlicense-file:       LICENSE\nauthor:             Bas van Dijk\nmaintainer:         Bas van Dijk <v.dijk.bas@gmail.com>\ncategory:           Data\nbuild-type:         Simple\ncabal-version:      >=1.10\nextra-source-files: changelog\ntested-with:\n  GHC ==8.6.5\n   || ==8.8.4\n   || ==8.10.7\n   || ==9.0.2\n   || ==9.2.8\n   || ==9.4.8\n   || ==9.6.6\n   || ==9.8.4\n   || ==9.10.1\n   || ==9.12.1\n\nsource-repository head\n  type:     git\n  location: https://github.com/basvandijk/scientific.git\n\nflag integer-simple\n  description: Use the integer-simple package instead of integer-gmp\n  default:     False\n\nlibrary\n  exposed-modules:\n    Data.ByteString.Builder.Scientific\n    Data.Scientific\n    Data.Text.Lazy.Builder.Scientific\n\n  other-modules:\n    GHC.Integer.Compat\n    Utils\n\n  other-extensions:\n    BangPatterns\n    DeriveDataTypeable\n    Trustworthy\n\n  ghc-options:      -Wall\n  build-depends:\n      base                >=4.5      && <4.22\n    , binary              >=0.8.6.0  && <0.9\n    , bytestring          >=0.10.8.2 && <0.13\n    , containers          >=0.6.0.1  && <0.8\n    , deepseq             >=1.4.4.0  && <1.6\n    , hashable            >=1.4.4.0  && <1.6\n    , integer-logarithms  >=1.0.3.1  && <1.1\n    , primitive           >=0.9.0.0  && <0.10\n    , template-haskell    >=2.14.0.0 && <2.24\n    , text                >=1.2.3.0  && <1.3  || >=2.0 && <2.2\n\n  if impl(ghc >=9.0)\n    build-depends: base >=4.15\n\n    if flag(integer-simple)\n      build-depends: invalid-cabal-flag-settings <0\n\n  else\n    if flag(integer-simple)\n      build-depends: integer-simple\n\n    else\n      build-depends: integer-gmp\n\n  if impl(ghc <8)\n    other-extensions: TemplateHaskell\n\n  if impl(ghc >=9.0)\n    -- these flags may abort compilation with GHC-8.10\n    -- https://gitlab.haskell.org/ghc/ghc/-/merge_requests/3295\n    ghc-options: -Winferred-safe-imports -Wmissing-safe-haskell-mode\n\n  hs-source-dirs:   src\n  default-language: Haskell2010\n\ntest-suite test-scientific\n  type:             exitcode-stdio-1.0\n  hs-source-dirs:   test\n  main-is:          test.hs\n  default-language: Haskell2010\n  ghc-options:      -Wall\n  build-depends:\n      base\n    , binary\n    , bytestring\n    , QuickCheck        >=2.14.2\n    , scientific\n    , smallcheck        >=1.0\n    , tasty             >=1.4.0.1\n    , tasty-hunit       >=0.8\n    , tasty-quickcheck  >=0.8\n    , tasty-smallcheck  >=0.2\n    , text\n\nbenchmark bench-scientific\n  type:             exitcode-stdio-1.0\n  hs-source-dirs:   bench\n  main-is:          bench.hs\n  default-language: Haskell2010\n  ghc-options:      -O2\n  build-depends:\n      base\n    , criterion   >=0.5\n    , scientific\n";
  }