#NoEnv
SetTitleMatchMode, RegEx
SendMode Input
SetWorkingDir %A_ScriptDir%
#SingleInstance force

ApplicationName = Slide
IniFile = Slide.ini
;; Precision of pixel move for animation of the window
;;
;; Unique ID of the console window
TerminalHWND := -1
; TerminalWinTitle := "ahk_class Chrome_WidgetWin_1 ahk_exe extraterm.exe"
TerminalWinTitle := "manyTerm ahk_class Chrome_WidgetWin_1 ahk_exe electron.exe"
AltTerminalWinTitle := "ahk_class CASCADIA_HOSTING_WINDOW_CLASS ahk_exe WindowsTerminal.exe"
If !WinExist(TerminalWinTitle) 
    TerminalWinTitle := AltTerminalWinTitle

;TerminalPath := "C:\Utils\System\ExtraTerm\"
TerminalPath := "C:\Dev\PROJECTS\manyterm\node_modules\electron\dist\"
TerminalExe := "electron.exe"
TerminalArgs = "C:\Dev\PROJECTS\manyterm\"

;;
;; screen size
ScreenSizeX := A_ScreenWidth
ScreenSizeY := A_ScreenHeight
;; Console window position
PosX := 0
PosY := 0
TimerMovePrecision := 20
SizePercentX := 100
SizePercentY := 40
DetectHiddenWindows, Off
;
;;
;;; FUNCTIONS
;;
;;; Slide a Windows outside the screen by the top (to hide it)

Gosub LoadIniFile
Gosub FindTerminal

isWindowVisible2(WTitle){
    if not DllCall("IsWindowVisible", "UInt", WinExist(WTitle)){
        Return False
    }Else{
        Return True
    }
}

WindowSlideUp(WindowHWND)
{
    global TerminalSlideTime, PosX, PosY, OffsetBottom, TimerMovePrecision, TerminalSlideTau
    OutputDebug, %TerminalSlideTime%
    ;; move windows immediately
    SetWinDelay, -1
    
    ;; enable animation only when the timer is not null (or negative)
    if TerminalSlideTime > 0
    {
        ;; to be sure that the console window is at the right place
        WinMove, ahk_id %WindowHWND%, , %PosX%, %PosY%
        ;; get pos and window size
        WinGetPos, WinPosX, WinPosY, W, H, ahk_id %WindowHWND%
        ;; Position of window out of screen to hide it
        WinHeight := H - OffsetBottom
        PosToStop := PosY - WinHeight
        
        ;; compute move precision to set time limit
        MovePrecision := (TimerMovePrecision * WinHeight) / TerminalSlideTime
        ;; compute coef for first order filter
        FirstOrderCoef := 1 - exp(-MovePrecision / TerminalSlideTau)
        ;; init time value
        CurrentTime := 0
        
        ;; loop to move the window
        While, WinPosY > PosToStop
        {
            ;; when Tau is positive do the smooth animation
            if TerminalSlideTau > 0
            {
                ;; when time is not over
                if CurrentTime < TerminalSlideTime
                {
                    ;; first order filter the position of window (last - 2 is to pass through 99%)
                    WinPosY := WinPosY + ((PosToStop - WinPosY) * FirstOrderCoef) - 2
                }
                else
                {
                    ;; time is over set full position
                    WinPosY := PosToStop
                }
            }
            else
            {
                ;; move up the window with the precision pixel
                WinPosY := WinPosY - MovePrecision
            }
            
            ;; do not move to high
            if WinPosY > PosToStop
            {
                WinPosY := PosToStop
            }
            ;; positioning the window
            WinMove, ahk_id %WindowHWND%, , %PosX%, %WinPosY%
            ;; wait TimerMovePrecision ms (to create the animation)
            Sleep, %TimerMovePrecision%
            ;; increment time
            CurrentTime := CurrentTime + TimerMovePrecision
        }
    }
    ;; hide window from users
    WinHide, ahk_id %WindowHWND%
}
Return

;;
;;; Slide a Windows inside the screen by the top (to show it)
WindowSlideDown(WindowHWND)
{
    global TerminalSlideTime, PosX, PosY, TimerMovePrecision, TerminalSlideTau
    global OffsetTop, OffsetLeft, ScreenSizeX, ScreenSizeY
    global PosX, PosY, NbCharacterX, SizePercentX
    
    ;; move windows immediately
    SetWinDelay, -1
    
    ;; get window size
    WinGetPos, , , W, H, ahk_id %WindowHWND%
    if SizePercentX != 100
    {
        PosX := Ceil((ScreenSizeX - ((SizePercentX * ScreenSizeX) / 100)) / 2) - OffsetLeft
        OutputDebug, Ceil((%ScreenSizeX% - ((%SizePercentX% * %ScreenSizeX%) / 100)) / 2) - %OffsetLeft% 
        OutputDebug, PosX: %PosX% w: %W% h: %H%
    }
    else
    {
        PosX := -OffsetLeft
    }
    PosY := -OffsetTop
    
    ;; place the window
    WinMove, ahk_id %WindowHWND%, , %PosX%, %PosY% - %H%
    ;;
    ;; Display the hidden console window
    WinShow, ahk_id %WindowHWND%
    ;;
    ;; make active the console2 window
    WinActivate, ahk_id %WindowHWND%
    
    ;; enable animation only when the timer is not null (or negative)
    if TerminalSlideTime > 0
    {
        ;; get pos and window size
        WinGetPos, WinPosX, WinPosY, W, H, ahk_id %WindowHWND%
        ;; height of showed window
        WinHeight := H
        ;; Position of window out of screen to showit
        PosToStop := PosY
        
        ;; compute move precision to set time limit
        MovePrecision := (TimerMovePrecision * WinHeight) / TerminalSlideTime
        ;; compute coef for first order filter
        FirstOrderCoef := 1 - exp(-MovePrecision / TerminalSlideTau)
        ;; init time value
        CurrentTime := 0
        
        ;; loop to move the window
        While, WinPosY < PosToStop
        {
            ;; when Tau is positive do the smooth animation
            if TerminalSlideTau > 0
            {
                ;; when time is not over
                if CurrentTime < TerminalSlideTime
                {
                    ;; first order filter the position of window (last + 2 is to pass through 99%)
                    WinPosY := WinPosY + ((PosToStop - WinPosY) * FirstOrderCoef) + 2
                }
                else
                {
                    ;; time is over set full position
                    WinPosY := PosToStop
                }
            }
            else
            {
                ;; move up the window with the precision pixel
                WinPosY := WinPosY + MovePrecision
            }
            
            ;; do not move too down
            if WinPosY > PosToStop
            {
                WinPosY := PosToStop
            }
            ;; positioning the window
            WinMove, ahk_id %WindowHWND%, , %PosX%, %WinPosY%
            ;; wait TimerMovePrecision ms (to create the animation)
            Sleep, %TimerMovePrecision%
            ;; increment time
            CurrentTime := CurrentTime + TimerMovePrecision
        }
    }
    
    ;; to be sure that the console window is at the right place
    WinMove, ahk_id %WindowHWND%, , PosX, PosY
}
Return

;;
;;; apply alpha, always on top and remove decoration of console window
WindowDesign(WindowHWND)
{
    global TerminalAlpha, TerminalAlwaysOnTop, OffsetTop, OffsetLeft, OffsetBottom, OffsetRight, PosX, PosY, SizePercentX, SizePercentY
    ;;
    ;; styles to be remove from console window
    WS_POPUP := 0x80000000
    WS_CAPTION := 0xC00000
    WS_THICKFRAME := 0x40000
    WS_EX_CLIENTEDGE := 0x200
    
    ;; move windows immediately
    SetWinDelay, -1
    
    if TerminalAlwaysOnTop = True
    {
        ;; set the window to be always in front of other windows
        Winset, AlwaysOnTop, On, ahk_id %WindowHWND%
    }
    else
    {
        ;; set the window to be always in front of other windows
        Winset, AlwaysOnTop, Off, ahk_id %WindowHWND%
    }
    
    ;; remove almost all decoration window (do not work with cmd)
    
    ; remove only for extraterm and atom`
    WinSet, Style, % -(WS_CAPTION|WS_THICKFRAME), ahk_id %WindowHWND%
    WinSet, ExStyle, % -WS_EX_CLIENTEDGE, ahk_id %WindowHWND%
    
    ;; get window size
    ;; WinGetPos, , , W, H, ahk_id %WindowHWND%
    ;; TODO get size window decoration
    ;; set size of mask to hide window decoration
    
    ;; mask window border
    w := A_ScreenWidth * (SizePercentX/100)
    h := A_ScreenHeight * (SizePercentY/100)
    PosX := (A_ScreenWidth - w) / 2
    
    WinMove, ahk_id %WindowHWND%,,%PosX%,%PosY%,%w%, %h%
    MaskX := w - OffsetRight - OffsetLeft
    MaskY := h - OffsetBottom - OffsetTop
    WinSet, Region, %OffsetLeft%-%OffsetTop% w%MaskX% h%MaskY%, ahk_id %WindowHWND%
}
Return

^F1:: 
Gosub FindTerminal 
WindowSlideUp(TerminalHWND)
Return
^F2:: 
Gosub FindTerminal
WindowSlideDown(TerminalHWND)
Return
;^F3::TerminalHWND="0x30BC6"
;^F4::TerminalHWND="0x2709E0"

!`::
    Gosub FindTerminal
    Gosub ToggleView 
Return

!^R::Reload

LoadIniFile:
    ;; type of terminal MS/cmd or Cygwin/rxvt
    ;; IniRead, TerminalType, %IniFile%, Terminal, TerminalType, cmd
    ;; title in terminal MS/cmd Cygwin/rxvt
    ;; IniRead, TerminalTitle, %IniFile%, Terminal, TerminalTitle, QuahkeConsole
    ;;
    ;; percent size in X for the terminal window (%)
    IniRead, SizePercentX, %IniFile%, Size, SizePercentX, 100
    ;; percent size in Y for the terminal window (%)
    IniRead, SizePercentY, %IniFile%, Size, SizePercentY, 30
    ;;
    ;; font in terminal Cygwin/rxvt
    IniRead, TerminalFont, %IniFile%, Font, TerminalFont, Courier-12
    ;; Character Size in X
    IniRead, CharacterSizeX, %IniFile%, Font, CharacterSizeX, 8
    ;; Character Size in Y
    IniRead, CharacterSizeY, %IniFile%, Font, CharacterSizeY, 12
    ;;
    ;; Transparence of terminal in percent (invisible (0) to full opaque (100))
    IniRead, TerminalAlpha, %IniFile%, Display, TerminalAlpha, 80
    ;; always on top
    IniRead, TerminalAlwaysOnTop, %IniFile%, Display, TerminalAlwaysOnTop, True
    ;;
    ;; get default offset value
    ;; OffsetArray := 0
    ;; offset to remove window decoration at left
    IniRead, OffsetLeft, %IniFile%, Position, OffsetLeft, % OffsetArray[1]
    ;; offset to remove window decoration at top
    IniRead, OffsetTop, %IniFile%, Position, OffsetTop, % OffsetArray[2]
    ;; offset to remove window decoration at bottom
    IniRead, OffsetBottom, %IniFile%, Position, OffsetBottom, % OffsetArray[3]
    ;; offset to remove window decoration at right
    IniRead, OffsetRight, %IniFile%, Position, OffsetRight, % OffsetArray[4]
    ;;
    ;; time in ms of animation of hide/show console window
    IniRead, TerminalSlideTime, %IniFile%, Display, TerminalSlideTime, 300
    ;; time in ms of going to position in animation (Tau~63%, 3Tau~95%, 5Tau~99%)
    IniRead, TerminalSlideTau, %IniFile%, Display, TerminalSlideTau, 20
    ;;
    ;; foreground color in terminal Cygwin/rxvt
    IniRead, TerminalForeground, %IniFile%, Display, TerminalForeground, white
    ;; background color in terminal Cygwin/rxvt
    IniRead, TerminalBackground, %IniFile%, Display, TerminalBackground, black
    ;;
    ;; shortcut for show/hide window console
    IniRead, ShortcutShowHide, %IniFile%, Misc, ShortcutShowHide, F1
    ;;
    ;; shell in terminal Cygwin/rxvt
    IniRead, TerminalShell, %IniFile%, Misc, TerminalShell, bash
    ;; history size in terminal Cygwin/rxvt
    IniRead, TerminalHistory, %IniFile%, Misc, TerminalHistory, 5000
    ;; take default config from you config file (~/.minttyrc)
    IniRead, NoConfigMintty, %IniFile%, Misc, NoConfigMintty, False
    ;; path of Cygwin (to run rxvt)
    IniRead, ExecPath, %IniFile%, Misc, ExecPath, C:\cygwin\bin
Return

FindTerminal:
    If (TerminalHWND AND WinExist("ahk_id " . TerminalHWND))
        Return
    DetectHiddenWindows, On 
    TerminalHWND := WinExist(TerminalWinTitle) ? WinExist(TerminalWinTitle) : -1
    WindowDesign(TerminalHWND)
    DetectHiddenWindows, Off
Return

ToggleView:
    Process, Exist, %TerminalExe%
    ;OutputDebug, %ErrorLevel% 
    if (ErrorLevel){ 
        DetectHiddenWindows, On
        if !WinExist("ahk_id ".TerminalHWND)
            Gosub FindTerminal
        
        
        theiaAhkHWND = ahk_id %TerminalHWND%
        OutputDebug, found hwnd %theiaAhkHWND%
        
        if (isWindowVisible2(theiaAhkHWND)){
            OutputDebug, is visible
            If (WinActive(theiaAhkHWND)){
                OutputDebug, is active, WinSlideUp
                WindowSlideUp(TerminalHWND) ; WinHide, %thWtitle% 
            } Else {
                OutputDebug, not active so restoring, just in case and activating
                WinRestore, %theiaAhkHWND%
                WinActivate, %theiaAhkHWND% 
            }
        }else {
            OutputDebug, is not visible - showing
            WindowSlideDown(TerminalHWND) ; WinShow, %thWtitle%
            WinActivate, %theiaAhkHWND% 
        }
    }else{
        OutputDebug not running, start
        Run, "%TerminalPath%%TerminalExe%" "%TerminalArgs%", "%TerminalPath%", Hide
        
        
    } 
Return

/* 
If !WinExists("ahk_id ".TerminalHWND)
    Gosub FindTerminal

DetectHiddenWindows, Off

WindowTitle = ahk_exe Spotify.exe ;just as an example 

if (ID := WinExist(WindowTitle)){
    WinGet, state, MinMax, %WindowTitle%
    
    if (state = -1) {
        WinRestore %WindowTitle%
        WinActivate
    } Else {
        WinGetPos , X, Y, , , %WindowTitle%
        If ( WinActive(WindowTitle))
            WinMinimize, %WindowTitle%
        Else
            WinActivate, %WindowTitle%
    } 
} 

*/