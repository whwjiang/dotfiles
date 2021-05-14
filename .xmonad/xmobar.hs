Config {
       font =
       "xft:SFMono Nerd Font:size=10.5:bold=true:antialias=true:hinting=true"
       , bgColor = "#0e0c15"
       , fgColor = "#dbd0b9"
       , position =     Top
   , border =       BottomB
   , borderColor =  "#646464"

   -- layout
   , sepChar =  "%"   -- delineator between plugin names and straight text
   , alignSep = "}{"  -- separator between left-right alignment
   , template = " <fc=#18bcff> </fc> %StdinReader% }{ %KCMI% | 墳 : %volume% | %date% "

   -- general behavior
   , lowerOnStart =     True    -- send to bottom of window stack on start
   , hideOnStart =      False   -- start with window unmapped (hidden)
   , allDesktops =      True    -- show on all desktops
   , overrideRedirect = True    -- set the Override Redirect flag (Xlib)
   , pickBroadest =     False   -- choose widest display (multi-monitor)
   , persistent =       True    -- enable/disable hiding (True = disabled)

   -- plugins
   --   Numbers can be automatically colored according to their value. xmobar
   --   decides color based on a three-tier/two-cutoff system, controlled by
   --   command options:
   --     --Low sets the low cutoff
   --     --High sets the high cutoff
   --
   --     --low sets the color below --Low cutoff
   --     --normal sets the color between --Low and --High cutoffs
   --     --High sets the color above --High cutoff
   --
   --   The --template option controls how the plugin is displayed. Text
   --   color can be set by enclosing in <fc></fc> tags. For more details
   --   see http://projects.haskell.org/xmobar/#system-monitor-plugins.
   , commands =
        [
        Run StdinReader

        -- weather monitor
        , Run Weather "KCMI" [ "--template", " : <skyCondition> | <fc=#dd3dca><tempF></fc>°F"
                             ] 36000

	, Run PipeReader "/tmp/.volume-pipe" "volume"	

        -- time and date indicator
        --   (%F = y-m-d date, %a = day of week, %T = h:m:s time)
        , Run Date " : %F (%a)  : %T" "date" 10

        ]
   } 
