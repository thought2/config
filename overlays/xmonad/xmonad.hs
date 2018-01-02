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
  [ ((mod4Mask, xK_f),      spawn "firefox")
  ]
