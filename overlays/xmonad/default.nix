{
  pkgs ? import <nixpkgs> {},
  extraPackages ? self: with self; [
    xmonad-contrib
  ]
}:
let
  colors = import ../../data/colors.nix;

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

    import XMonad.Layout.FixedColumn

    --import XMonad.Layout.Gaps
    import XMonad.Layout.Spacing

    modm = mod4Mask

    main = do
      xmonad $ defaultConfig
        { focusedBorderColor = "${colors.red}"
        , borderWidth        = 4
        , modMask            = modm
        , layoutHook         = layout
        } `additionalKeys` shortcuts

    shortcuts =
      [ ((modm .|. ctrl,   xK_f),             spawn "${pkgs.firefox}/bin/firefox")                                
      , ((modm .|. ctrl,   xK_c),             spawn "${pkgs.chromium}/bin/chromium-browser")                      
      , ((modm .|. ctrl,   xK_a),             spawn "${pkgs.chromium}/bin/chromium-browser --app='http://ddg.gg'")
      -- , ((modm .|. ctrl,   xK_e),             spawn "${pkgs.emacs}/bin/emacsclient --create-frame")
      , ((modm .|. ctrl,   xK_e),             spawn "${pkgs.emacs}/bin/emacs --no-splash")
      , ((modm .|. ctrl,   xK_Return),        spawn "${pkgs.xterm}/bin/xterm")
      , ((modm .|. ctrl,   xK_t),             spawn "${pkgs.tdesktop}/bin/telegram-desktop")
      , ((modm .|. ctrl,   xK_f),             sendMessage $ JumpToLayout "Full")
      , ((modm .|. ctrl,   xK_n),             spawn "${pkgs.xterm}/bin/xterm -e ${pkgs.networkmanager}/bin/nmtui")
      , ((modm .|. shift,                     xK_space), virtualScreens)
      , ((modm .|. ctrl .|. shift, xK_space), rescreen)
      ]
      where
        virtualScreens = layoutScreens 3 $ spacingWithEdge 10 $ TwoPane 0.55 0.45
        ctrl           = controlMask
        shift          = shiftMask
        

    layout = tall ||| tall2 ||| full ||| FixedColumn 1 20 80 10
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
