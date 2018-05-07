{
  config,
  pkgs ? import <nixpkgs> {},
  extraPackages ? self: with self; [
    xmonad-contrib
  ]
}:
let
  colors = import ../../data/colors.nix;

  xmonadConfig = /* haskell */ ''
    import XMonad hiding ( (|||) )
    import XMonad.Util.EZConfig(additionalKeysP)
    import XMonad.Layout.NoBorders
    import XMonad.Layout.LayoutCombinators
    --import XMonad.Hooks.DynamicLog
    --import XMonad.Hooks.ManageDocks
    --import XMonad.Util.Run(spawnPipe)
    --import System.IO
    import XMonad.Layout.LayoutScreens
    import XMonad.Layout.TwoPane

--    import FloatNext

    import XMonad.Layout.FixedColumn

    --import XMonad.Layout.Gaps
    import XMonad.Layout.Spacing

    import qualified XMonad.Actions.DynamicWorkspaceOrder as DO
    import XMonad.Actions.CycleWS

    modm = mod4Mask

    main = do
      xmonad $ defaultConfig
        { focusedBorderColor = "${colors.yellow}"
        , borderWidth        = 4
        , modMask            = modm
        , layoutHook         = layout
        } `additionalKeysP` shortcuts

    shortcuts =
      [ ("M-C-f",          spawn "${pkgs.firefox}/bin/firefox")
      , ("M-C-b",          spawn "${pkgs.thunderbird}/bin/thunderbird")
      , ("M-C-s",          spawn "${pkgs.coreutils}/bin/sleep 0.2; ${pkgs.scrot}/bin/scrot -s -e 'mv $f ~/screenshots/'")
      , ("M-C-c",          spawn "${pkgs.chromium}/bin/chromium-browser")
      , ("M-C-a",          spawn "${pkgs.chromium}/bin/chromium-browser --app='http://ddg.gg'")
      , ("M-C-e",          spawn "${pkgs.emacs}/bin/emacs --no-splash")
      , ("M-C-<Return>",   spawn "${pkgs.xterm}/bin/xterm")
      , ("M-C-f",          sendMessage $ JumpToLayout "Full")
      , ("M-C-n",          spawn "${pkgs.xterm}/bin/xterm -e ${pkgs.networkmanager}/bin/nmtui")
      , ("M-S-<Space>",    virtualScreens)
      , ("M-C-S-<Space>",  rescreen)

      , ("<XF86AudioMute>", spawn "...")
      , ("<XF86AudioRaiseVolume>", spawn "${pkgs.alsaUtils}/amixer set Master '10%+'")
      , ("<XF86AudioLowerVolume>", spawn "...")

      -- cycle workspaces
      , ("M-<Left>",       DO.moveTo Prev HiddenNonEmptyWS)
      , ("M-<Right>",      DO.moveTo Next HiddenNonEmptyWS)

      ]
      where
        virtualScreens = layoutScreens 3 $ spacingWithEdge 10 $ TwoPane 0.55 0.45;

    layout = tall ||| tall2 ||| full ||| FixedColumn 1 20 80 10
      where
        tall  = Tall 1 (3/100) (1/2)
        tall2 = Mirror tall 
        full  = noBorders Full
  '';
in
pkgs.stdenv.mkDerivation {
  name = "xmonad-compiled";
  src = pkgs.writeTextDir "xmonad.hs" xmonadConfig;

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
