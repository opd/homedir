import XMonad
{-import XMonad.Config.Xfce-}

{-main = xmonad xfceConfig-}
main = xmonad def
    { terminal      = "urxvt"
    , modMask       = mod4Mask
    , borderWidth   = 3
    }
