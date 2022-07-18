import XMonad
import XMonad.Config.Xfce
import XMonad.Util.EZConfig(additionalKeys)

myLauncher = "rofi -combi-modi window,drun,run -show combi -modi combi"

main = xmonad $ xfceConfig
        { terminal = "kitty"
        , modMask = mod4Mask -- optional: use Win key instead of Alt as MODi key
        } `additionalKeys`
        [ ((mod4Mask, xK_p), spawn myLauncher)
        ]
