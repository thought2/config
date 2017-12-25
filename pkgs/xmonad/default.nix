{
  pkgs ? import <nixpkgs> {},
  extraPackages ? self: with self; [
    xmonad-contrib
  ]
}:
let
  temp = /* clojure */ ''
    (def x 33) 
  '';
  config = /* haskell */ ''
    import XMonad hiding ( (|||) )
    import XMonad.Util.EZConfig(additionalKeys)
    import XMonad.Layout.NoBorders
    import XMonad.Layout.LayoutCombinators
    --import XMonad.Hooks.DynamicLog
    --import XMonad.Hooks.ManageDocks
    --import XMonad.Util.Run(spawnPipe)
    --import System.IO
    import XMonad.Layout.LayoutScreens
    import XMonad.Layout.TwoPane

    --import XMonad.Layout.Gaps
    import XMonad.Layout.Spacing
    
    main = do
      xmonad $ defaultConfig
        { focusedBorderColor = "#fc7474"
        , borderWidth        = 4
        , modMask            = mod4Mask
        , layoutHook         = layout
        } `additionalKeys` shortcuts

    shortcuts =
      [ ((mod .|. ctrl,   xK_f),             spawn "${pkgs.firefox}/bin/firefox")                                
      , ((mod .|. ctrl,   xK_c),             spawn "${pkgs.chromium}/bin/chromium-browser")                      
      , ((mod .|. ctrl,   xK_a),             spawn "${pkgs.chromium}/bin/chromium-browser --app='http://ddg.gg'")
      , ((mod .|. ctrl,   xK_e),             spawn "${pkgs.emacs}/bin/emacs")                                    
      , ((mod .|. ctrl,   xK_Return),        spawn "${pkgs.xterm}/bin/xterm")
      , ((mod .|. ctrl,   xK_f),             sendMessage $ JumpToLayout "Full")
      
      , ((mod .|. shift,                     xK_space), virtualScreens)
      , ((mod .|. ctrl .|. shift, xK_space), rescreen)
      ]
      where
        virtualScreens = layoutScreens 2 $ spacingWithEdge 10 $ TwoPane 0.55 0.45
        mod            = mod4Mask
        ctrl           = controlMask
        shift          = shiftMask
        
    

    layout = tall ||| tall2 ||| full
      where
        tall  = Tall 1 (3/100) (1/2)
        tall2 = Mirror tall 
        full  = noBorders Full
  '';
in
pkgs.stdenv.mkDerivation {
  name = "xmonad-compiled";
  src = pkgs.writeTextDir "xmonad.hs" config;

  buildInputs = [
    (pkgs.haskellPackages.ghcWithPackages (self: [ self.xmonad ] ++ extraPackages self))
  ];

  buildPhase = ''
    ghc --make xmonad.hs
  '';

  installPhase = ''
    mkdir -p $out/bin
    mv xmonad $out/bin
  '';
}
