import XMonad hiding ((|||))
import qualified XMonad.StackSet as W
import qualified Data.Map        as M

-- Useful for rofi
import XMonad.Hooks.EwmhDesktops
import XMonad.Hooks.DynamicLog
import XMonad.Hooks.ManageDocks
import XMonad.Util.Run(spawnPipe)
import XMonad.Util.SpawnOnce
import XMonad.Util.EZConfig(additionalKeys, additionalKeysP, additionalMouseBindings)
import System.IO
import System.Exit
-- Last window
import XMonad.Actions.GroupNavigation
-- Last workspace. Seems to conflict with the last window hook though so just
-- disabled it.
-- import XMonad.Actions.CycleWS
-- import XMonad.Hooks.WorkspaceHistory (workspaceHistoryHook)
import XMonad.Layout.Tabbed
import XMonad.Hooks.InsertPosition
import XMonad.Layout.SimpleDecoration (shrinkText)
-- Imitate dynamicLogXinerama layout
import XMonad.Util.WorkspaceCompare
import XMonad.Hooks.ManageHelpers
-- Order screens by physical location
import XMonad.Actions.PhysicalScreens
import Data.Default
-- For getSortByXineramaPhysicalRule
import XMonad.Layout.LayoutCombinators
-- smartBorders and noBorders
import XMonad.Layout.NoBorders
-- spacing between tiles
import XMonad.Layout.Spacing

--- Layouts
-- Resizable tile layout
import XMonad.Layout.ResizableTile
import XMonad.Layout.Minimize
-- Simple two pane layout.
import XMonad.Layout.TwoPane
import XMonad.Layout.BinarySpacePartition
import XMonad.Layout.Dwindle

import Graphics.X11.ExtraTypes.XF86

myTerminal = "kitty"
myFocusedBorderColor = "#18bcff"
myNormalBorderColor = "#7a7b7b"
myBorderWidth = 2
volumeScript = "/home/whjiang/dotfiles/volume.sh"

myTabConfig = def { activeColor = "#0e0c15"
                  , inactiveColor = "#0e0c15"
                  , urgentColor = "#0e0c15"
                  , activeBorderColor = "#18bcff"
                  , inactiveBorderColor = "#7a7b7b"
                  , urgentBorderColor = "#7a7b7b"
                  , activeTextColor = "#18bcff"
                  , inactiveTextColor = "#dbd0b9"
                  , urgentTextColor = "#dbd0b9"
                  , fontName = "xft:SF Mono:size=10:antialias=true:hinting=true"
                  }

myLayout = avoidStruts $
  noBorders (tabbed shrinkText myTabConfig)
  ||| tiled
  ||| Mirror tiled
  ||| noBorders Full
  -- ||| twopane
  -- ||| Mirror twopane
  -- ||| emptyBSP
  -- ||| Spiral R XMonad.Layout.Dwindle.CW (3/2) (11/10) -- L means the non-main windows are put to the left.

  where
     -- The last parameter is fraction to multiply the slave window heights
     -- with. Useless here.
     tiled = spacing 5 $ ResizableTall nmaster delta ratio []
     -- In this layout the second pane will only show the focused window.
     twopane = spacing 5 $ TwoPane delta ratio
     -- The default number of windows in the master pane
     nmaster = 1
     -- Default proportion of screen occupied by master pane
     ratio   = 1/2
     -- Percent of screen to increment by when resizing panes
     delta   = 3/100

myPP = def { ppCurrent = xmobarColor "#dd3dca" "" -- . wrap "[" "]"
           , ppTitle = xmobarColor "#dd3dca" "" . shorten 60
           , ppVisible = wrap "" ""
           , ppUrgent  = xmobarColor "red" "yellow"
           , ppSort = getSortByXineramaPhysicalRule def
           }

myManageHook = composeAll [ isFullscreen --> doFullFloat ]

myStartupHook :: X ()
myStartupHook = do
  spawnOnce "nitrogen --restore &"
  spawnOnce "compton &"
  spawn $ volumeScript

myKeys conf@(XConfig {XMonad.modMask = modm}) = M.fromList $

    -- launch a terminal
    [ ((modm              , xK_Return), spawn $ XMonad.terminal conf)

    , ((modm .|. shiftMask, xK_Return), spawn "launcher_colorful")

    , ((modm .|. shiftMask, xK_p     ), spawn "powermenu")

    , ((modm .|. shiftMask, xK_x     ), spawn "nvim /home/whjiang/dotfiles/.xmonad/")

    -- close focused window
    , ((modm              , xK_c     ), kill)

     -- Rotate through the available layout algorithms
    , ((modm              , xK_space ), sendMessage NextLayout)

    --  Reset the layouts on the current workspace to default
    , ((modm .|. shiftMask, xK_r), setLayout $ XMonad.layoutHook conf)
    , ((modm .|. shiftMask, xK_h), sendMessage $ JumpToLayout "Mirror Tall")
    , ((modm .|. shiftMask, xK_v), sendMessage $ JumpToLayout "Tall")
    , ((modm .|. shiftMask, xK_f), sendMessage $ JumpToLayout "Full")
    , ((modm .|. shiftMask, xK_t), sendMessage $ JumpToLayout "Tabbed Simplest")

    -- Resize viewed windows to the correct size
    , ((modm              , xK_n     ), refresh)

    -- Move focus to the next window
    , ((modm              , xK_Tab   ), windows W.focusDown)

    -- Move focus to the next window
    , ((modm              , xK_j     ), windows W.focusDown)

    -- Move focus to the previous window
    , ((modm              , xK_k     ), windows W.focusUp  )

    -- Move focus to the master window
    , ((modm              , xK_m     ), windows W.focusMaster  )

    -- Swap the focused window and the master window
    , ((modm .|. shiftMask, xK_space ), windows W.swapMaster)

    -- Swap the focused window with the next window
    , ((modm .|. shiftMask, xK_j     ), windows W.swapDown  )

    -- Swap the focused window with the previous window
    , ((modm .|. shiftMask, xK_k     ), windows W.swapUp    )

    -- Shrink the master area
    , ((modm              , xK_h     ), sendMessage Shrink)

    -- Expand the master area
    , ((modm              , xK_l     ), sendMessage Expand)

    -- Shrink and expand ratio between the secondary panes, for the ResizableTall layout
    , ((modm .|. shiftMask, xK_h     ), sendMessage MirrorShrink)
    , ((modm .|. shiftMask, xK_l     ), sendMessage MirrorExpand)

    -- Push window back into tiling
    , ((modm              , xK_t     ), withFocused $ windows . W.sink)

    -- Increment the number of windows in the master area
    , ((modm              , xK_comma ), sendMessage (IncMasterN 1))

    -- Deincrement the number of windows in the master area
    , ((modm              , xK_period), sendMessage (IncMasterN (-1)))

    -- Toggle the status bar gap
    -- Use this binding with avoidStruts from Hooks.ManageDocks.
    -- See also the statusBar function from Hooks.DynamicLog.
    , ((modm              , xK_b     ), sendMessage ToggleStruts)
    , ((modm              , xK_q     ), spawn "xmonad --recompile; killall xmobar; xmonad --restart")
    , ((modm .|. shiftMask, xK_q     ), io exitSuccess)

    -- Decrease volume
    , ((modm, xK_Page_Down), spawn $ "amixer -q set Master 5%-; " ++ volumeScript)

    -- Increase volume
    , ((modm  , xK_Page_Up), spawn $ "amixer -q set Master 5%+; " ++ volumeScript)

    -- Toggle Spotify playing:
    , ((modm   , xK_Insert), spawn $ "playerctl -p spotify play-pause")

    -- Toggle Spotify playing:
    , ((modm   , xK_Insert), spawn $ "playerctl -p spotify play-pause")
    ]

    ++
      [((m .|. modm, k), windows $ f i)
      | (i, k) <- zip (XMonad.workspaces conf) [xK_1 .. xK_9]
      , (f, m) <- [(W.greedyView, 0), (W.shift, shiftMask)]]
    ++
      [((m .|. modm, key), f sc)
      | (key, sc) <- zip [xK_a, xK_s, xK_d] [0..]
      -- Order screen by physical order instead of arbitrary numberings.
      , (f, m) <- [(viewScreen def, 0), (sendToScreen def, shiftMask)]]

main = do
    xmproc <- spawnPipe "xmobar ~/dotfiles/.xmonad/xmobar.hs"
    xmonad $ ewmh def
        { modMask = mod4Mask
        , keys = myKeys
        , manageHook = manageDocks <+> myManageHook
        , layoutHook = myLayout
        , handleEventHook = handleEventHook def <+> docksEventHook
        , logHook = dynamicLogWithPP myPP {
                                          ppOutput = hPutStrLn xmproc
                                          }
                        >> historyHook

        , terminal = myTerminal
        , startupHook = myStartupHook
        , normalBorderColor  = myNormalBorderColor
        , focusedBorderColor = myFocusedBorderColor
        , borderWidth = myBorderWidth
        }

