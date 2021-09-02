import           System.Exit
import           System.IO

import qualified Codec.Binary.UTF8.String      as UTF8
import           XMonad
import           XMonad.Actions.CycleWS
import           XMonad.Actions.SpawnOn
import           XMonad.Config.Azerty
import           XMonad.Config.Desktop
import           XMonad.Hooks.DynamicLog
import           XMonad.Hooks.EwmhDesktops
import           XMonad.Hooks.ManageDocks
import           XMonad.Hooks.ManageHelpers     ( doCenterFloat
                                                , doFullFloat
                                                , isDialog
                                                , isFullscreen
                                                )
import           XMonad.Hooks.SetWMName
import           XMonad.Hooks.UrgencyHook
import           XMonad.ManageHook
import           XMonad.Util.EZConfig           ( additionalKeys
                                                , additionalMouseBindings
                                                )
import           XMonad.Util.Run                ( spawnPipe )

-- TODO: More layouts
import           XMonad.Layout.Cross            ( simpleCross )
---import XMonad.Layout.NoBorders
import           XMonad.Layout.Fullscreen       ( fullscreenFull )
import           XMonad.Layout.Gaps
import           XMonad.Layout.IndependentScreens
import           XMonad.Layout.MultiToggle
import           XMonad.Layout.MultiToggle.Instances
import           XMonad.Layout.ResizableTile
import           XMonad.Layout.Spacing
import           XMonad.Layout.Spiral           ( spiral )
import           XMonad.Layout.ThreeColumns

-- import XMonad.Layout.Minimize
-- import XMonad.Actions.Minimize


import           XMonad.Layout.CenteredMaster   ( centerMaster )
import           XMonad.Util.NamedScratchpad

import           Control.Monad                  ( liftM2 )
import qualified DBus                          as D
import qualified DBus.Client                   as D
import qualified Data.ByteString               as B
import qualified Data.Map                      as M
import           Graphics.X11.ExtraTypes.XF86
import qualified XMonad.StackSet               as W


myStartupHook = do
  spawn "$HOME/.xmonad/scripts/autostart.sh"
  setWMName "LG3D"

-- colours
normBord = "#4c566a"
focdBord = "#5e81ac"
fore = "#DEE3E0"
back = "#282c34"
winType = "#c678dd"

--mod4Mask= super key
--mod1Mask= alt key
--controlMask= ctrl key
--shiftMask= shift key

myModMask = mod4Mask
encodeCChar = map fromIntegral . B.unpack
myFocusFollowsMouse = False
myBorderWidth = 2
-- decimal values of hex codes
myWorkspaces =
  [ "\62057"
  , "\61728"
  , "\61635"
  , "\61872"
  , "\61716"
  , "\61926"
  , "\61501"
  , "\61508"
  , "\61443"
  , "\61642"
  ]
--myWorkspaces    = ["1","2","3","4","5","6","7","8","9","10"]
--myWorkspaces    = ["I","II","III","IV","V","VI","VII","VIII","IX","X"]

myBaseConfig = desktopConfig

-- window manipulations (use xprop to get app name/class)
myManageHook =
  composeAll
    . concat
    $ [ [isDialog --> doCenterFloat]
      , [ className =? c --> doCenterFloat | c <- myCFloats ]
      , [ title =? t --> doFloat | t <- myTFloats ]
      , [ resource =? r --> doFloat | r <- myRFloats ]
      , [ resource =? i --> doIgnore
        | i <- myIgnores
        ]
    -- , [(className =? x <||> title =? x <||> resource =? x) --> doShiftAndGo "\61612" | x <- my1Shifts]
    -- , [(className =? x <||> title =? x <||> resource =? x) --> doShiftAndGo "\61899" | x <- my2Shifts]
    -- , [(className =? x <||> title =? x <||> resource =? x) --> doShiftAndGo "\61947" | x <- my3Shifts]
      , [ (className =? x <||> title =? x <||> resource =? x)
            --> doShiftAndGo (myWorkspaces !! 3)
        | x <- my4Shifts
        ]
      , [ (className =? x <||> title =? x <||> resource =? x)
            --> doShiftAndGo (myWorkspaces !! 4)
        | x <- my5Shifts
        ]
      , [ (className =? x <||> title =? x <||> resource =? x)
            --> doShiftAndGo (myWorkspaces !! 5)
        | x <- my6Shifts
        ]
      , [ (className =? x <||> title =? x <||> resource =? x)
            --> doShiftAndGo (myWorkspaces !! 6)
        | x <- my7Shifts
        ]
      , [ (className =? x <||> title =? x <||> resource =? x)
            --> doShiftAndGo (myWorkspaces !! 7)
        | x <- my8Shifts
        ]
      , [ (className =? x <||> title =? x <||> resource =? x)
            --> doShiftAndGo (myWorkspaces !! 8)
        | x <- my9Shifts
        ]
      , [ (className =? x <||> title =? x <||> resource =? x)
            --> doShiftAndGo (myWorkspaces !! 9)
        | x <- my10Shifts
        ]
      ]
 where
  doShiftAndGo = doF . liftM2 (.) W.greedyView W.shift
  myCFloats =
    [ "Arandr"
    , "Arcolinux-calamares-tool.py"
    , "Arcolinux-tweak-tool.py"
    , "Arcolinux-welcome-app.py"
    , "Galculator"
    , "feh"
    , "mpv"
    , "Xfce4-terminal"
    , "zoom"
    , "Lutris"
    , "Riot Client"
    , "League of Legends"
    ]
  myTFloats  = ["Downloads", "Save As...", "as_toolbar", "annotate_toolbar"]
  myRFloats  = []
  myIgnores  = ["desktop_window"]
  -- my1Shifts = ["Chromium", "Vivaldi-stable", "Firefox"]
  -- my2Shifts = []
  -- my3Shifts = ["Inkscape"]
  my4Shifts  = ["Gimp", "Lutris"]
  my5Shifts  = []
  my6Shifts  = ["Spotify Premium", "spotify", "Spotify"] -- need SpotifyWM (Electron apps set class name too late)
  my7Shifts  = ["zoom", "obs"]
  my8Shifts  = ["typora"]
  my9Shifts  = ["discord"]
  my10Shifts = ["Thunderbird"]




myLayout =
  spacingRaw True (Border 0 5 5 5) True (Border 5 5 5 5) True
    $   avoidStruts
    $   mkToggle (NBFULL ?? NOBORDERS ?? EOT)
    $   tiled
    ||| Mirror tiled
    ||| spiral (6 / 7)
    ||| ThreeColMid 1 (3 / 100) (1 / 2)
    ||| Full
 where
  tiled       = Tall nmaster delta tiled_ratio
  nmaster     = 1
  delta       = 3 / 100
  tiled_ratio = 1 / 2


myMouseBindings (XConfig { XMonad.modMask = modMask }) =
  M.fromList
    $

    -- mod-button1, Set the window to floating mode and move by dragging
      [ ( (modMask, 1)
        , (\w -> focus w >> mouseMoveWindow w >> windows W.shiftMaster)
        )

    -- mod-button2, Raise the window to the top of the stack
      , ((modMask, 2), (\w -> focus w >> windows W.shiftMaster))

    -- mod-button3, Set the window to floating mode and resize by dragging
      , ( (modMask, 3)
        , (\w -> focus w >> mouseResizeWindow w >> windows W.shiftMaster)
        )
      ]


-- keys config

myKeys conf@(XConfig { XMonad.modMask = modMask }) =
  M.fromList
    $
  ----------------------------------------------------------------------
  -- SUPER + FUNCTION KEYS
       [ ((modMask, xK_b), spawn $ "thunderbird")
       , ((modMask, xK_n), spawn $ "chromium")
       , ((modMask, xK_c), namedScratchpadAction myScratchPads "calculator")
       , ((modMask, xK_f), sendMessage $ Toggle NBFULL)
       , ((modMask, xK_h), spawn $ "alacritty -e htop")
       , ((modMask, xK_q), kill)
       , ((modMask, xK_r), spawn $ "rofi -show run")
       , ((modMask, xK_t), namedScratchpadAction myScratchPads "terminal")
       , ((modMask, xK_s), namedScratchpadAction myScratchPads "spotify")
       , ((modMask, xK_y), spawn $ "polybar-msg cmd toggle") -- and resize XMonad as well?
       , ((modMask, xK_v), spawn $ "xfce4-popup-clipman")
       , ((modMask, xK_x), spawn $ "arcolinux-logout")
       , ((modMask, xK_Escape), spawn $ "xkill")
       , ((modMask, xK_Return), spawn $ "alacritty")
       , ((modMask, xK_F1), spawn $ "vivaldi-stable")
       , ((modMask, xK_F2), spawn $ "atom")
       , ((modMask, xK_F3), spawn $ "inkscape")
       , ((modMask, xK_F4), spawn $ "gimp")
       , ((modMask, xK_F5), spawn $ "meld")
       , ((modMask, xK_F6), spawn $ "vlc --video-on-top")
       , ((modMask, xK_F7), spawn $ "virtualbox")
       , ((modMask, xK_F8), spawn $ "thunar")
       , ((modMask, xK_F9), spawn $ "evolution")
       , ((modMask, xK_F10), spawn $ "spotify")
       , ((modMask, xK_F11), spawn $ "rofi -show drun -fullscreen")
       , ((modMask, xK_F12), spawn $ "rofi -show drun")

  -- FUNCTION KEYS
       , ((0, xK_F12), spawn $ "xfce4-terminal --drop-down")

  -- SUPER + SHIFT KEYS
       , ((modMask .|. shiftMask, xK_c), spawn $ "chromium")
       , ((modMask .|. shiftMask, xK_v), spawn $ "pavucontrol")
       , ((modMask .|. shiftMask, xK_Return), spawn $ "nemo")
       , ( (modMask .|. shiftMask, xK_d)
         , spawn
           $ "dmenu_run -i -nb '#191919' -nf '#fea63c' -sb '#fea63c' -sf '#191919' -fn 'NotoMonoRegular:bold:pixelsize=14'"
         )
       , ( (modMask .|. shiftMask, xK_r)
         , spawn $ "xmonad --recompile && xmonad --restart"
         )
       , ((modMask .|. shiftMask, xK_q), kill)
  -- , ((modMask .|. shiftMask , xK_x ), io (exitWith ExitSuccess))

  -- CONTROL + ALT KEYS
       , ((controlMask .|. mod1Mask, xK_Next), spawn $ "conky-rotate -n")
       , ((controlMask .|. mod1Mask, xK_Prior), spawn $ "conky-rotate -p")
       , ((controlMask .|. mod1Mask, xK_a), spawn $ "xfce4-appfinder")
       , ((controlMask .|. mod1Mask, xK_b), spawn $ "thunar")
       , ((controlMask .|. mod1Mask, xK_c), spawn $ "catfish")
       , ((controlMask .|. mod1Mask, xK_e), spawn $ "arcolinux-tweak-tool")
       , ((controlMask .|. mod1Mask, xK_f), spawn $ "firefox")
       , ( (controlMask .|. mod1Mask, xK_g)
         , spawn $ "chromium -no-default-browser-check"
         )
       , ((controlMask .|. mod1Mask, xK_i), spawn $ "nitrogen")
       , ((controlMask .|. mod1Mask, xK_k), spawn $ "arcolinux-logout")
       , ((controlMask .|. mod1Mask, xK_l), spawn $ "arcolinux-logout")
       , ((controlMask .|. mod1Mask, xK_m), spawn $ "xfce4-settings-manager")
       , ( (controlMask .|. mod1Mask, xK_o)
         , spawn $ "$HOME/.xmonad/scripts/picom-toggle.sh"
         )
       , ((controlMask .|. mod1Mask, xK_p), spawn $ "pamac-manager")
       , ((controlMask .|. mod1Mask, xK_r), spawn $ "rofi-theme-selector")
       , ((controlMask .|. mod1Mask, xK_s), spawn $ "spotify")
       , ((controlMask .|. mod1Mask, xK_t), spawn $ "urxvt")
       , ((controlMask .|. mod1Mask, xK_u), spawn $ "pavucontrol")
       , ((controlMask .|. mod1Mask, xK_v), spawn $ "vivaldi-stable")
       , ((controlMask .|. mod1Mask, xK_w), spawn $ "arcolinux-welcome-app")
       , ((controlMask .|. mod1Mask, xK_Return), spawn $ "urxvt")

  -- ALT + ... KEYS
       , ((mod1Mask, xK_f), spawn $ "variety -f")
       , ((mod1Mask, xK_n), spawn $ "variety -n")
       , ((mod1Mask, xK_p), spawn $ "variety -p")
       , ((mod1Mask, xK_r), spawn $ "xmonad --restart")
       , ((mod1Mask, xK_t), spawn $ "variety -t")
  -- , ((mod1Mask, xK_Up), spawn $ "variety --pause" )
  -- , ((mod1Mask, xK_Down), spawn $ "variety --resume" )
  -- , ((mod1Mask, xK_Left), spawn $ "variety -p" )
  -- , ((mod1Mask, xK_Right), spawn $ "variety -n" )
       , ((mod1Mask, xK_F2), spawn $ "xfce4-appfinder --collapsed")
       , ((mod1Mask, xK_F3), spawn $ "xfce4-appfinder")

  --VARIETY KEYS WITH PYWAL
       , ( (mod1Mask .|. shiftMask, xK_f)
         , spawn
           $ "variety -f && wal -i $(cat $HOME/.config/variety/wallpaper/wallpaper.jpg.txt)&"
         )
       , ( (mod1Mask .|. shiftMask, xK_n)
         , spawn
           $ "variety -n && wal -i $(cat $HOME/.config/variety/wallpaper/wallpaper.jpg.txt)&"
         )
       , ( (mod1Mask .|. shiftMask, xK_p)
         , spawn
           $ "variety -p && wal -i $(cat $HOME/.config/variety/wallpaper/wallpaper.jpg.txt)&"
         )
       , ( (mod1Mask .|. shiftMask, xK_t)
         , spawn
           $ "variety -t && wal -i $(cat $HOME/.config/variety/wallpaper/wallpaper.jpg.txt)&"
         )
       , ( (mod1Mask .|. shiftMask, xK_u)
         , spawn
           $ "wal -i $(cat $HOME/.config/variety/wallpaper/wallpaper.jpg.txt)&"
         )

  --CONTROL + SHIFT KEYS
       , ((controlMask .|. shiftMask, xK_Escape), spawn $ "xfce4-taskmanager")

  --SCREENSHOTS
       , ( (0, xK_Print)
         , spawn
           $ "scrot 'ArcoLinux-%Y-%m-%d-%s_screenshot_$wx$h.jpg' -e 'mv $f $$(xdg-user-dir PICTURES)'"
         )
       , ((modMask .|. shiftMask, xK_s), spawn $ "xfce4-screenshooter")
       , ((controlMask .|. shiftMask, xK_Print), spawn $ "gnome-screenshot -i")


  --MULTIMEDIA KEYS

  -- Mute volume
       , ((0, xF86XK_AudioMute), spawn $ "amixer -q set Master toggle")

  -- Decrease volume
       , ((0, xF86XK_AudioLowerVolume), spawn $ "amixer -q set Master 5%-")

  -- Increase volume
       , ((0, xF86XK_AudioRaiseVolume), spawn $ "amixer -q set Master 5%+")

  -- Increase brightness
       , ((0, xF86XK_MonBrightnessUp), spawn $ "xbacklight -inc 5")

  -- Decrease brightness
       , ((0, xF86XK_MonBrightnessDown), spawn $ "xbacklight -dec 5")

--  , ((0, xF86XK_AudioPlay), spawn $ "mpc toggle")
--  , ((0, xF86XK_AudioNext), spawn $ "mpc next")
--  , ((0, xF86XK_AudioPrev), spawn $ "mpc prev")
--  , ((0, xF86XK_AudioStop), spawn $ "mpc stop")
       , ((0, xF86XK_AudioPlay), spawn $ "playerctl play-pause")
       , ((0, xF86XK_AudioNext), spawn $ "playerctl next")
       , ((0, xF86XK_AudioPrev), spawn $ "playerctl previous")
       , ((0, xF86XK_AudioStop), spawn $ "playerctl stop")


  --------------------------------------------------------------------
  --  XMONAD LAYOUT KEYS

  -- Cycle through the available layout algorithms.
       , ((modMask, xK_space), sendMessage NextLayout)

  --Focus selected desktop
       , ((mod1Mask, xK_Tab), nextWS)
       , ((mod1Mask .|. shiftMask, xK_Tab), prevWS)

  --Focus selected desktop
       , ((modMask, xK_Tab), nextWS)
       , ((modMask .|. shiftMask, xK_Tab), prevWS)

  --Focus selected desktop
  -- , ((mod1Mask .|. shiftMask , xK_Left ), prevWS)

  --Focus selected desktop
  -- , ((mod1Mask .|. shiftMask , xK_Right ), nextWS)

  --  Reset the layouts on the current workspace to default.
       , ((modMask .|. shiftMask, xK_space), setLayout $ XMonad.layoutHook conf)

  -- Move focus to the next window.
       , ((modMask, xK_j), windows W.focusDown)

  -- Move focus to the previous window.
       , ((modMask, xK_k), windows W.focusUp)

  -- Move focus to the master window.
       , ((modMask .|. shiftMask, xK_m), windows W.focusMaster)

  -- Swap the focused window with the next window.
       , ((modMask .|. shiftMask, xK_j), windows W.swapDown)

  -- Swap the focused window with the next window.
       , ((controlMask .|. modMask, xK_Down), windows W.swapDown)

  -- Swap the focused window with the previous window.
       , ((modMask .|. shiftMask, xK_k), windows W.swapUp)

  -- Swap the focused window with the previous window.
       , ((controlMask .|. modMask, xK_Up), windows W.swapUp)

  -- Shrink the master area.
       , ((modMask .|. shiftMask, xK_h), sendMessage Shrink)

  -- Expand the master area.
       , ((modMask .|. shiftMask, xK_l), sendMessage Expand)

  -- Push window back into tiling.
       , ((modMask .|. shiftMask, xK_t), withFocused $ windows . W.sink)

  -- Increment the number of windows in the master area.
       , ((controlMask .|. modMask, xK_Left), sendMessage (IncMasterN 1))

  -- Decrement the number of windows in the master area.
       , ((controlMask .|. modMask, xK_Right), sendMessage (IncMasterN (-1)))
       ]
    ++

  -- mod-[1..9], Switch to workspace N
  -- mod-shift-[1..9], Move client to workspace N
       [ ((m .|. modMask, k), windows $ f i)

  --Keyboard layouts
  --qwerty users use this line
       | (i, k) <- zip
         (XMonad.workspaces conf)
         [xK_1, xK_2, xK_3, xK_4, xK_5, xK_6, xK_7, xK_8, xK_9, xK_0]

--French Azerty users use this line
-- | (i, k) <- zip (XMonad.workspaces conf) [xK_ampersand, xK_eacute, xK_quotedbl, xK_apostrophe, xK_parenleft, xK_minus, xK_egrave, xK_underscore, xK_ccedilla , xK_agrave]

--Belgian Azerty users use this line
-- | (i, k) <- zip (XMonad.workspaces conf) [xK_ampersand, xK_eacute, xK_quotedbl, xK_apostrophe, xK_parenleft, xK_section, xK_egrave, xK_exclam, xK_ccedilla, xK_agrave]
       , (f, m) <-
         [ (W.greedyView                    , 0)
         , (W.shift                         , shiftMask)
         , (\i -> W.greedyView i . W.shift i, shiftMask)
         ]
       ]

    ++
  -- mod-{w,e,r}, Switch to physical/Xinerama screens 1, 2, or 3
  -- mod-shift-{w,e,r}, Move client to screen 1, 2, or 3
       [ ( (m .|. modMask, key)
         , screenWorkspace sc >>= flip whenJust (windows . f)
         )
       | (key, sc) <- zip [xK_w, xK_e] [0 ..]
       , (f, m) <- [(W.view, 0), (W.shift, shiftMask)]
       ]



-- Scratchpad
myScratchPads :: [NamedScratchpad]
myScratchPads =
  [ NS "terminal"   spawnTerm    findTerm    manageTerm
  , NS "calculator" spawnCalc    findCalc    manageCalc
  , NS "spotify"    spawnSpotify findSpotify manageSpotify
  ]
 where
  spawnTerm  = "alacritty -t scratchterm"
  findTerm   = title =? "scratchterm"
  manageTerm = customFloating $ W.RationalRect l t w h
   where
    h = 0.9
    w = 0.9
    t = 0.95 - h
    l = 0.95 - w
  spawnCalc  = "qalculate-gtk"
  findCalc   = className =? "Qalculate-gtk"
  manageCalc = customFloating $ W.RationalRect l t w h
   where
    h = 0.5
    w = 0.4
    t = 0.75 - h
    l = 0.70 - w
  spawnSpotify  = "spotify"
  findSpotify   = className =? "Spotify"
  manageSpotify = customFloating $ W.RationalRect l t w h
   where
    h = 0.9
    w = 0.9
    t = 0.95 - h
    l = 0.95 - w


main :: IO ()
main = do

  dbus <- D.connectSession
  -- Request access to the DBus name
  D.requestName
    dbus
    (D.busName_ "org.xmonad.Log")
    [D.nameAllowReplacement, D.nameReplaceExisting, D.nameDoNotQueue]


  xmonad . ewmh $
--Keyboard layouts
--qwerty users use this line
                  myBaseConfig
--French Azerty users use this line
          --myBaseConfig { keys = azertyKeys <+> keys azertyConfig }
--Belgian Azerty users use this line
          --myBaseConfig { keys = belgianKeys <+> keys belgianConfig }
    { startupHook        = myStartupHook
    , layoutHook         = gaps [(U, 35), (D, 5), (R, 5), (L, 5)]
                           $   myLayout
                           ||| layoutHook myBaseConfig
    , manageHook         = manageSpawn
                           <+> myManageHook
                           <+> namedScratchpadManageHook myScratchPads
                           <+> manageHook myBaseConfig
    , modMask            = myModMask
    , borderWidth        = myBorderWidth
    , handleEventHook    = handleEventHook myBaseConfig <+> fullscreenEventHook
    , focusFollowsMouse  = myFocusFollowsMouse
    , workspaces         = myWorkspaces
    , focusedBorderColor = focdBord
    , normalBorderColor  = normBord
    , keys               = myKeys
    , mouseBindings      = myMouseBindings
    }
