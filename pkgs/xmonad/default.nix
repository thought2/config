{
  pkgs ? import <nixpkgs> {},
  extraPackages ? self: with self; [
    xmonad-contrib
  ]
}:
let
  config = ''
    import XMonad
    import XMonad.Util.EZConfig(additionalKeys)
    --import XMonad.Hooks.DynamicLog
    --import XMonad.Hooks.ManageDocks
    --import XMonad.Util.Run(spawnPipe)
    --import System.IO


    main = do
      xmonad $ defaultConfig
        { focusedBorderColor = "#fc7474"
        , borderWidth        = 1
        , modMask            = mod4Mask
        } `additionalKeys` myKeys

    myKeys =
      [ ((mod4Mask, xK_f),      spawn "${pkgs.firefox}/bin/firefox")
      , ((mod4Mask, xK_c),      spawn "${pkgs.chromium}/bin/chromium-browser")
      , ((mod4Mask, xK_e),      spawn "${pkgs.emacs}/bin/emacs")
      ]
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
