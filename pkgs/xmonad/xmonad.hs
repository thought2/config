import XMonad
--import XMonad.Hooks.DynamicLog
--import XMonad.Hooks.ManageDocks
--import XMonad.Util.Run(spawnPipe)
--import XMonad.Util.EZConfig(additionalKeys)
--import System.IO


main = do
  xmonad $ defaultConfig
    { focusedBorderColor = "#fc7474"
    , borderWidth        = 1
    }  
