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
      identifier = { name = "random"; version = "1.3.1"; };
      license = "BSD-3-Clause";
      copyright = "";
      maintainer = "core-libraries-committee@haskell.org";
      author = "";
      homepage = "";
      url = "";
      synopsis = "Pseudo-random number generation";
      description = "This package provides basic pseudo-random number generation, including the\nability to split random number generators.\n\n== \"System.Random\": pure pseudo-random number interface\n\nIn pure code, use 'System.Random.uniform' and 'System.Random.uniformR' from\n\"System.Random\" to generate pseudo-random numbers with a pure pseudo-random\nnumber generator like 'System.Random.StdGen'.\n\nAs an example, here is how you can simulate rolls of a six-sided die using\n'System.Random.uniformR':\n\n>>> let roll = uniformR (1, 6)        :: RandomGen g => g -> (Word, g)\n>>> let rolls = unfoldr (Just . roll) :: RandomGen g => g -> [Word]\n>>> let pureGen = mkStdGen 42\n>>> take 10 (rolls pureGen)           :: [Word]\n[1,1,3,2,4,5,3,4,6,2]\n\nSee \"System.Random\" for more details.\n\n== \"System.Random.Stateful\": monadic pseudo-random number interface\n\nIn monadic code, use 'System.Random.Stateful.uniformM' and\n'System.Random.Stateful.uniformRM' from \"System.Random.Stateful\" to generate\npseudo-random numbers with a monadic pseudo-random number generator, or\nusing a monadic adapter.\n\nAs an example, here is how you can simulate rolls of a six-sided die using\n'System.Random.Stateful.uniformRM':\n\n>>> let rollM = uniformRM (1, 6)                 :: StatefulGen g m => g -> m Word\n>>> let pureGen = mkStdGen 42\n>>> runStateGen_ pureGen (replicateM 10 . rollM) :: [Word]\n[1,1,3,2,4,5,3,4,6,2]\n\nThe monadic adapter 'System.Random.Stateful.runStateGen_' is used here to lift\nthe pure pseudo-random number generator @pureGen@ into the\n'System.Random.Stateful.StatefulGen' context.\n\nThe monadic interface can also be used with existing monadic pseudo-random\nnumber generators. In this example, we use the one provided in the\n<https://hackage.haskell.org/package/mwc-random mwc-random> package:\n\n>>> import System.Random.MWC as MWC\n>>> let rollM = uniformRM (1, 6)       :: StatefulGen g m => g -> m Word\n>>> monadicGen <- MWC.create\n>>> replicateM 10 (rollM monadicGen) :: IO [Word]\n[2,3,6,6,4,4,3,1,5,4]\n\nSee \"System.Random.Stateful\" for more details.";
      buildType = "Simple";
    };
    components = {
      "library" = {
        depends = [
          (hsPkgs."base" or (errorHandler.buildDepError "base"))
          (hsPkgs."bytestring" or (errorHandler.buildDepError "bytestring"))
          (hsPkgs."deepseq" or (errorHandler.buildDepError "deepseq"))
          (hsPkgs."mtl" or (errorHandler.buildDepError "mtl"))
          (hsPkgs."transformers" or (errorHandler.buildDepError "transformers"))
          (hsPkgs."splitmix" or (errorHandler.buildDepError "splitmix"))
        ] ++ pkgs.lib.optional (compiler.isGhc && compiler.version.lt "9.4") (hsPkgs."data-array-byte" or (errorHandler.buildDepError "data-array-byte"));
        buildable = true;
      };
      tests = {
        "legacy-test" = {
          depends = [
            (hsPkgs."base" or (errorHandler.buildDepError "base"))
            (hsPkgs."containers" or (errorHandler.buildDepError "containers"))
            (hsPkgs."random" or (errorHandler.buildDepError "random"))
          ];
          buildable = true;
        };
        "spec" = {
          depends = [
            (hsPkgs."base" or (errorHandler.buildDepError "base"))
            (hsPkgs."bytestring" or (errorHandler.buildDepError "bytestring"))
            (hsPkgs."random" or (errorHandler.buildDepError "random"))
            (hsPkgs."smallcheck" or (errorHandler.buildDepError "smallcheck"))
            (hsPkgs."stm" or (errorHandler.buildDepError "stm"))
            (hsPkgs."tasty" or (errorHandler.buildDepError "tasty"))
            (hsPkgs."tasty-smallcheck" or (errorHandler.buildDepError "tasty-smallcheck"))
            (hsPkgs."tasty-hunit" or (errorHandler.buildDepError "tasty-hunit"))
            (hsPkgs."transformers" or (errorHandler.buildDepError "transformers"))
          ];
          buildable = true;
        };
        "spec-inspection" = {
          depends = [
            (hsPkgs."base" or (errorHandler.buildDepError "base"))
            (hsPkgs."random" or (errorHandler.buildDepError "random"))
            (hsPkgs."tasty" or (errorHandler.buildDepError "tasty"))
            (hsPkgs."tasty-inspection-testing" or (errorHandler.buildDepError "tasty-inspection-testing"))
          ];
          buildable = if compiler.isGhc && compiler.version.ge "9.10"
            then false
            else true;
        };
      };
      benchmarks = {
        "legacy-bench" = {
          depends = [
            (hsPkgs."base" or (errorHandler.buildDepError "base"))
            (hsPkgs."random" or (errorHandler.buildDepError "random"))
            (hsPkgs."rdtsc" or (errorHandler.buildDepError "rdtsc"))
            (hsPkgs."split" or (errorHandler.buildDepError "split"))
            (hsPkgs."time" or (errorHandler.buildDepError "time"))
          ];
          buildable = true;
        };
        "bench" = {
          depends = [
            (hsPkgs."base" or (errorHandler.buildDepError "base"))
            (hsPkgs."mtl" or (errorHandler.buildDepError "mtl"))
            (hsPkgs."primitive" or (errorHandler.buildDepError "primitive"))
            (hsPkgs."random" or (errorHandler.buildDepError "random"))
            (hsPkgs."splitmix" or (errorHandler.buildDepError "splitmix"))
            (hsPkgs."tasty-bench" or (errorHandler.buildDepError "tasty-bench"))
          ];
          buildable = true;
        };
      };
    };
  } // {
    src = pkgs.lib.mkDefault (pkgs.fetchurl {
      url = "http://hackage.haskell.org/package/random-1.3.1.tar.gz";
      sha256 = "d840ac83f265b0cfa2a678f8ec78627eb50cf9be2f067c52c8a4239c29b71a35";
    });
  }) // {
    package-description-override = "cabal-version:      >=1.10\nname:               random\nversion:            1.3.1\nlicense:            BSD3\nlicense-file:       LICENSE\nmaintainer:         core-libraries-committee@haskell.org\nbug-reports:        https://github.com/haskell/random/issues\nsynopsis:           Pseudo-random number generation\ndescription:\n    This package provides basic pseudo-random number generation, including the\n    ability to split random number generators.\n    .\n    == \"System.Random\": pure pseudo-random number interface\n    .\n    In pure code, use 'System.Random.uniform' and 'System.Random.uniformR' from\n    \"System.Random\" to generate pseudo-random numbers with a pure pseudo-random\n    number generator like 'System.Random.StdGen'.\n    .\n    As an example, here is how you can simulate rolls of a six-sided die using\n    'System.Random.uniformR':\n    .\n    >>> let roll = uniformR (1, 6)        :: RandomGen g => g -> (Word, g)\n    >>> let rolls = unfoldr (Just . roll) :: RandomGen g => g -> [Word]\n    >>> let pureGen = mkStdGen 42\n    >>> take 10 (rolls pureGen)           :: [Word]\n    [1,1,3,2,4,5,3,4,6,2]\n    .\n    See \"System.Random\" for more details.\n    .\n    == \"System.Random.Stateful\": monadic pseudo-random number interface\n    .\n    In monadic code, use 'System.Random.Stateful.uniformM' and\n    'System.Random.Stateful.uniformRM' from \"System.Random.Stateful\" to generate\n    pseudo-random numbers with a monadic pseudo-random number generator, or\n    using a monadic adapter.\n    .\n    As an example, here is how you can simulate rolls of a six-sided die using\n    'System.Random.Stateful.uniformRM':\n    .\n    >>> let rollM = uniformRM (1, 6)                 :: StatefulGen g m => g -> m Word\n    >>> let pureGen = mkStdGen 42\n    >>> runStateGen_ pureGen (replicateM 10 . rollM) :: [Word]\n    [1,1,3,2,4,5,3,4,6,2]\n    .\n    The monadic adapter 'System.Random.Stateful.runStateGen_' is used here to lift\n    the pure pseudo-random number generator @pureGen@ into the\n    'System.Random.Stateful.StatefulGen' context.\n    .\n    The monadic interface can also be used with existing monadic pseudo-random\n    number generators. In this example, we use the one provided in the\n    <https://hackage.haskell.org/package/mwc-random mwc-random> package:\n    .\n    >>> import System.Random.MWC as MWC\n    >>> let rollM = uniformRM (1, 6)       :: StatefulGen g m => g -> m Word\n    >>> monadicGen <- MWC.create\n    >>> replicateM 10 (rollM monadicGen) :: IO [Word]\n    [2,3,6,6,4,4,3,1,5,4]\n    .\n    See \"System.Random.Stateful\" for more details.\n\ncategory:           System\nbuild-type:         Simple\nextra-source-files:\n    README.md\n    CHANGELOG.md\ntested-with:         GHC == 8.0.2\n                   , GHC == 8.2.2\n                   , GHC == 8.4.4\n                   , GHC == 8.6.5\n                   , GHC == 8.8.4\n                   , GHC == 8.10.7\n                   , GHC == 9.0.2\n                   , GHC == 9.2.8\n                   , GHC == 9.4.8\n                   , GHC == 9.6.6\n                   , GHC == 9.8.4\n                   , GHC == 9.10.1\n                   , GHC == 9.12.1\n\nsource-repository head\n    type:     git\n    location: https://github.com/haskell/random.git\n\n\nlibrary\n    exposed-modules:\n        System.Random\n        System.Random.Internal\n        System.Random.Stateful\n    other-modules:\n        System.Random.Array\n        System.Random.Seed\n        System.Random.GFinite\n\n    hs-source-dirs:   src\n    default-language: Haskell2010\n    ghc-options:\n        -Wall\n        -Wincomplete-record-updates -Wincomplete-uni-patterns\n\n    build-depends:\n        base >=4.9 && <5,\n        bytestring >=0.10.4 && <0.13,\n        deepseq >=1.1 && <2,\n        mtl >=2.2 && <2.4,\n        transformers >=0.4 && <0.7,\n        splitmix >=0.1 && <0.2\n    if impl(ghc < 9.4)\n      build-depends: data-array-byte\n\ntest-suite legacy-test\n    type:             exitcode-stdio-1.0\n    main-is:          Legacy.hs\n    hs-source-dirs:   test-legacy\n    other-modules:\n        T7936\n        TestRandomIOs\n        TestRandomRs\n        Random1283\n        RangeTest\n\n    default-language: Haskell2010\n    ghc-options:\n      -with-rtsopts=-M9M\n      -Wno-deprecations\n    build-depends:\n        base,\n        containers >=0.5 && <0.8,\n        random\n\ntest-suite spec\n    type:             exitcode-stdio-1.0\n    main-is:          Spec.hs\n    hs-source-dirs:   test\n    other-modules:\n        Spec.Range\n        Spec.Run\n        Spec.Seed\n        Spec.Stateful\n\n    default-language: Haskell2010\n    ghc-options:      -Wall\n    build-depends:\n        base,\n        bytestring,\n        random,\n        smallcheck >=1.2 && <1.3,\n        stm,\n        tasty >=1.0 && <1.6,\n        tasty-smallcheck >=0.8 && <0.9,\n        tasty-hunit >=0.10 && <0.11,\n        transformers\n\n-- Note. Fails when compiled with coverage:\n-- https://github.com/haskell/random/issues/107\ntest-suite spec-inspection\n    type:             exitcode-stdio-1.0\n    main-is:          Spec.hs\n    hs-source-dirs:   test-inspection\n    default-language: Haskell2010\n    ghc-options:      -Wall\n    other-modules:\n        Spec.Inspection\n    build-depends:\n        base,\n        random,\n        tasty >=1.0 && <1.6,\n        tasty-inspection-testing\n    if impl(ghc >=9.10)\n        buildable: False\n\nbenchmark legacy-bench\n    type:             exitcode-stdio-1.0\n    main-is:          SimpleRNGBench.hs\n    hs-source-dirs:   bench-legacy\n    other-modules:    BinSearch\n    default-language: Haskell2010\n    ghc-options:\n        -Wall -O2 -threaded -rtsopts -with-rtsopts=-N -Wno-deprecations\n\n    build-depends:\n        base,\n        random,\n        rdtsc,\n        split >=0.2 && <0.3,\n        time >=1.4 && <1.13\n\nbenchmark bench\n    type:             exitcode-stdio-1.0\n    main-is:          Main.hs\n    hs-source-dirs:   bench\n    default-language: Haskell2010\n    ghc-options:      -Wall -O2\n    build-depends:\n        base,\n        mtl,\n        primitive,\n        random,\n        splitmix >=0.1 && <0.2,\n        tasty-bench\n";
  }