#SingleInstance Force
#Persistent 
#InstallKeybdHook
#InstallMouseHook
#MenuMaskKey LShift

SoundPlay, %A_ScriptDir%\sounds\protos_active.mp3
Sleep 1500

DetectHiddenWindows, On 
SetTitleMatchMode, RegEx
SendMode, Event
SetWorkingDir %A_ScriptDir%
SetBatchLines -1
SetKeyDelay, 0
SetCapsLockState, AlwaysOff
SetNumLockState, Off
BlockInput, Send
CoordMode, Mouse
Menu, Tray, NoStandard
Menu, Tray, Icon, %A_ScriptDir%\protos.png, 1
Menu, Tray, Add,Start &OpacityHelper, startOpacityHelper
Menu, Tray, Add,Start W_RMB &Swapper, startWRMB
Menu, Tray, Add,Start &GameMode, startGameMode

Menu, Tray, Add
Menu, Tray, Standard
dhw := A_DetectHiddenWindows
DetectHiddenWindows On

Run "%ComSpec%" /k,, Hide, pid
while !(hConsole := WinExist("ahk_pid" pid))
    Sleep 10
DllCall("AttachConsole", "UInt", pid)
DetectHiddenWindows %dhw%

workHostname=AGIL
ClipSaved= ; this is not used ???
cmderMode=0
launcherMode=0
resizeMode=0

resizeStep=80 ;winresize

playerExe:="Spotify\.exe"
playerHWND= ; this is not used ??
playerPath=%A_AppData%\Spotify\%playerExe%
sptPath:="C:\Users\chm\scoop\shims\spt.exe"
sptHWND=
sptScale:=0.65
blur=%A_ScriptDir%\3rdParty\SetWindowCompositionAttribute.exe

playerWinTitle=ahk_exe %playerExe% 
GroupAdd, SpotifyGrp, ahk_exe %playerExe%,,,(?:^.?$)|(?:^devtools) ;global window group holding ... only main window thanks to regex .. it is totally stupid and should be changed ;)

if (InStr(A_ComputerName, workHostname, false))
    global browserExe="C:\vivaldi\Application\vivaldi.exe --window-size=480x480 --app="
else
    global browserExe="C:\Users\chm\AppData\Local\Vivaldi\Application\vivaldi.exe --window-size=480x480 --app="

global browserWebmaker = "chrome-extension://lkfkkhfhhdkiemehlpkgjeojomhpccnh/index.html" 
global browserTranslate= "chrome-extension://ihmgiclibbndffejedjimfjmfoabpcke/pages/public/window.html"
global browserREPL= "chrome-extension://ojmdmeehmpkpkkhbifimekflgmnmeihg/options.html"
global browserNotes= "https://y.chm.dev/laverna"
global browserJOIN = "chrome-extension://flejfacjooompmliegamfbpjjdlhokhj/devices.html?tab=notifications&popup=1"
global thm
;#include %A_ScriptDir%\Lib\TapHoldManager.ahk
; TapTime / Prefix can now be set here
;thm := new TapHoldManager(,,,"~")
;thm.Add("LAlt", Func("openLauncher"))
;rthm.Add("CapsLock", Func("sendMegaModifier"))

; it has to be after first capslock definitions

; these share same mouse mods+wheel actions
; #Include %A_ScriptDir%\toggler.ahk
#Include %A_ScriptDir%\volControl.ahk 
#Include %A_ScriptDir%\winresize.ahk

^!WheelUp::
    Gosub, vol_MasterUp 
Return
^!WheelDown::
    Gosub, vol_MasterDown
Return

^+WheelUp::
    Gosub, win_enlarge 
Return
^+WheelDown::
    Gosub, win_shrink 
Return

!+WheelUp::Gosub vol_WaveUp ; Shift+Win+UpArrow
!+WheelDown::Gosub vol_WaveDown
;so we have to deal with it here

if (InStr(A_ComputerName, workHostname, false))
    #Include %A_ScriptDir%\temp.ahk

openLauncher(isHold, taps, state){
    global launcherMode
    if (taps = 2 and GetKeyState("ScrollLock", "T")=0 and launcherMode=0)
        Send {LAlt Down}{BackSpace}{LAlt Up}
Return
}

sendMegaModifier(isHold, taps, state){

    if (taps = 2 and state = 1 and GetKeyState("ScrollLock", "T")=0){
        OutputDebug entry: %isHold%, %taps%, %state%
        Send {Blind}{LCtrl Down}{LShift Down}{LAlt Down}{CapsLock Up}

        SoundPlay %A_ScriptDir%\sounds\toggle_on.wav
        ;SoundBeep 750, 300 
        KeyWait CapsLock, T1.4 
        OutputDebug after Loop %isHold%, %taps%, %state%
            Send {Blind}{LCtrl Up}{LShift Up}{LAlt Up}
        SoundPlay %A_ScriptDir%\sounds\toggle_off.wav
    } 
Return 
}
releaseAllModifiers() 
{ 
    list = Control|Alt|Shift 
    Loop Parse, list, | 
    { 
        if (GetKeyState(A_LoopField)) 
            send {Blind}{%A_LoopField% up} ; {Blind} is added.
    } 
} 

isWindowVisible(WTitle){
    if not DllCall("IsWindowVisible", "UInt", WinExist(WTitle)){
        Return False
    }Else{
        Return True
    }
}
;~CapsLock:: 
;Send {LCtrl Down}{LShift Down}{LAlt Down}
;keyWait, CapsLock
;Send {LCtrl Up}{LShift Up}{LAlt Up}
;Return

getCursorWindow(){
    MouseGetPos,,,WinUMID
    WinGet, pName, ProcessName, ahk_id %WinUMID%
    If (InStr(pName, "explorer") or pName = "")
        Return -1
    Else
        Return WinUMID 
}

activateCursorWindow(){
    OutputDebug, % WinGetTitle, `% "ahk_id " . getCursorWindow()
    WinActivate, % "ahk_id " . getCursorWindow()
}
;=== BEGIN === 
; == Debug ==
CapsLock & r:: 
    Reload
Return

; == Start of script ==

CapsLock & LButton::
    WinUMID := getCursorWindow()
    if (WinUMID = -1) 
        Return
    WinSet AlwaysOnTop, Toggle, ahk_id %WinUMID%
    WinGet, exs, ExStyle, ahk_id %WinUMID%
    if (exs & 0x8) { ;Always on top on
        WinSet, Transparent, 240, ahk_id %WinUMID%
    }else { ; AOT Off
        WinSet, Transparent, Off, ahk_id %WinUMID%
    }
Return

~Home & PgUp:: 
    Suspend, Permit
    if (A_IsSuspended = 1) 
    {
        SoundPlay, %A_ScriptDir%\sounds\protos_active.mp3
        Sleep 1200
        SetCapsLockState, AlwaysOff
        Suspend, Off
    }
Return

~Home & PgDn:: 
    SoundPlay, %A_ScriptDir%\sounds\protos_suspended.mp3
    Sleep 1200
    SetCapsLockState, Off
    Suspend, On
Return

^!+End:: 
    SoundPlay, %A_ScriptDir%\sounds\protos_exiting.mp3
    Sleep 1800 
ExitApp
Return

CapsLock & '::
    hwnd:=getCursorWindow()
    hwnd:=SubStr(hwnd,3)
    Run, %A_ScriptDir%\3rdParty\SetWindowCompositionAttribute.exe hwnd %hwnd% blur false,,Hide
    Run, %A_ScriptDir%\3rdParty\SetWindowCompositionAttribute.exe hwnd %hwnd% accent 0 0 0 0,,Hide
Return

CapsLock & p:: 
    hwnd:=getCursorWindow()
    hwnd:=SubStr(hwnd,3)
    Run,%A_ScriptDir%\3rdParty\SetWindowCompositionAttribute.exe hwnd %hwnd% accent 3 0 0 0,,Hide
Return

CapsLock & [:: 
    hwnd:=getCursorWindow()
    hwnd:=SubStr(hwnd,3)
    Run, %A_ScriptDir%\3rdParty\SetWindowCompositionAttribute.exe hwnd %hwnd% accent 3 2 ee000000 0,,Hide
Return

CapsLock & ]:: 
    hwnd:=getCursorWindow()
    hwnd:=SubStr(hwnd,3)
    Run,%A_ScriptDir%\3rdParty\SetWindowCompositionAttribute.exe hwnd %hwnd% accent 3 2 e619140c 0,,Hide
Return
CapsLock & \::
    hwnd:=getCursorWindow()
    hwnd:=SubStr(hwnd,3)
    Run, %A_ScriptDir%\3rdParty\SetWindowCompositionAttribute.exe hwnd %hwnd% blur true,,Hide
Return

CapsLock & WheelDown:: 
    WinUMID := getCursorWindow()
    if WinUMID = -1
        Return 
    WinMinimize ahk_id %WinUMID%
Return

CapsLock & WheelUp:: 
    WinUMID := getCursorWindow()
    if WinUMID = -1
        Return 
    WinMaximize ahk_id %WinUMID%
Return

CapsLock & MButton:: 
    WinUMID := getCursorWindow()
    if WinUMID = -1
        Return 
    WinRestore ahk_id %WinUMID%
Return

CapsLock & XButton1::
    if (!GetKeyState("Shift"))
        activateCursorWindow()

    Send #{Left}
Return

CapsLock & XButton2:: 
    if (!GetKeyState("Shift"))
        activateCursorWindow()

    Send #{Right}

Return

LCtrl & XButton1::Send ^!{Left}
LCtrl & XButton2::Send ^!{Right}

^!v::
    SendEvent {Raw}%Clipboard%
Return 

CapsLock & v:: 
    if (InStr(Clipboard, "document.query") = 0){

        SendStr := RegExReplace(Clipboard, "^""(.+)""$", "$1")
        SendStr := StrReplace(SendStr, """""", """",,-1)
        ;MsgBox, %Clipboard%, %SendStr%
        SendEvent {Raw} document.querySelector('%SendStr%')
    } Else {
        SendStr := StrReplace(Clipboard, """", """""")
        SendStr := RegExReplace(SendStr, "document\.querySelector(?:All)?\('?([^\(\)]*)'\)", "$1")

        SendEvent "%SendStr%"
    }
Return

+!Ins::
    SendRaw % StrReplace(RunWaitOne("D:\cygwin64\bin\cygpath.exe " . Clipboard),"`n", "")
Return

XButton1 & MButton:: 
^!MButton:: 
    Send {Volume_Mute}
Return
XButton1:: Return
XButton2:: Return
^XButton1:: Send {XButton1}
^XButton2:: Send {XButton2}
!XButton1::
!+XButton1::
    if (!GetKeyState("Shift"))
        activateCursorWindow() 
    SendEvent #+{Left}
Return
!XButton2:: 
+!XButton2::
    if (!GetKeyState("Shift"))
        activateCursorWindow()
    SendEvent #+{Right}
Return
+!MButton:: 
NumpadIns:: 
    Send {Media_Play_Pause}
Return 
NumpadDel:: Send {Media_Stop}
NumpadEnd:: Send {Media_Prev}
NumpadDown:: Send {Media_Next}
NumpadAdd:: Send {Volume_Up 4}
NumpadSub:: Send {Volume_Down 4}

#v::SendEvent +!v
#+v::SendEvent #v

CapsLock & LAlt:: 
    if (cmderMode = 0) {
        cmderMode := 1
        SoundPlay, %A_ScriptDir%\sounds\cmder_mode_on.mp3
    }else {
        cmderMode := 0
        SoundPlay, %A_ScriptDir%\sounds\cmder_mode_off.mp3
    }
    Send {Blind}{CapsLock Up}
Return

#If cmderMode = 1 and GetKeyState("ScrollLock", "T") = 0 
    `::!` 
!`::Send ``
+`::~
#If

CapsLock & LWin:: 
    if (launcherMode = 0) {
        launcherMode := 1
        SoundPlay, %A_ScriptDir%\sounds\launcher_mode_on.wav
    }else {
        launcherMode := 0
        SoundPlay, %A_ScriptDir%\sounds\launcher_mode_off.wav
    }
    Send {CapsLock Up}
Return

#If launcherMode = 1 and GetKeyState("ScrollLock", "T") = 0

;to understand what is going on with LWin here check #MenuMaskKey in ahk help
~LWin:: 
    Send {Blind}{LShift}
    KeyWait, LWin 
    If (InStr(A_PriorKey,"LWin"))
        Send {LAlt Down}{BackSpace}{LAlt Up}

Return 
#If

Capslock & d::
    AA_DetectHiddenWindows := A_DetectHiddenWindows 
    DetectHiddenWindows, On
    WindowTitle = ahk_id %sptHWND%
    if (WinExist(WindowTitle)){
        mm:=MouseMonitorInfo() ; we will use to put the window on monitor where mouse is
        if (isWindowVisible(WindowTitle)){
            OutputDebug, is visible
            If (WinActive(WindowTitle)){
                OutputDebug, is active, WinHide
                WinHide, %WindowTitle% 
            } Else {
                OutputDebug, not active so restoring, just in case and activating
                WinRestore, %WindowTitle%
                ;move to mouse monitor
                Gosub SptPositionSet
                WinActivate, %WindowTitle% 
            }
        }else {
            OutputDebug, is not visible - showing
            WinShow, %WindowTitle%
            Gosub SptPositionSet
            WinActivate, %WindowTitle% 
        }
    }else{
        OutputDebug not running, start
        Gosub StartSpt
    } 
Return

CapsLock & s::
    ; WinGet, num, Count, ahk_group SpotifyGrp
    ; OutputDebug, %A_TitleMatchMode%, HiddenWIndows %A_DetectHiddenWindows%
    Process, Exist, Spotify.exe

    ;OutputDebug, %ErrorLevel% 

    if (ErrorLevel){ 
        sWinTitle := "(?:Spotify Premium)|(?:[^\s]+\s-\s[^\s]+).* ahk_exe Spotify.exe"

        if (isWindowVisible(sWinTitle)){
            OutputDebug, is visible
            If (WinActive(sWinTitle)){
                OutputDebug, is active, WinHide
                WinHide, %sWinTitle% 
            } Else {
                OutputDebug, not active so restoring, just in case and activating
                WinRestore, %sWinTitle%
                WinActivate, %sWinTitle% 
            }
        }else {
            OutputDebug, is not visible - showing
            WinShow, %sWinTitle%
            WinActivate, %sWinTitle% 
        }
    }else{
        OutputDebug not running, start
        Run, Spotify.exe
    } 
Return

~F4 & ~RButton::
    WinGet,pName, ProcessName, A
forcekill:=GetKeyState("Shift") ? "/F" : "F"
    Run taskkill /IM %pName%,,Hide
Return

#If WinActive("ahk_group SpotifyGrp") or WinActive("ahk_id " sptHWND)
    ~Esc::WinHide, A
#If

#If WinActive("ahk_exe dopus.exe")
    MButton::Send {Enter}
#If

::dqs:: 
    SendInput document.querySelector(''){Left 2}
Return

::dqsa:: 
    SendInput document.querySelectorAll(''){Left 2}
Return

::ses:: 
    SendInput [sessionId]
Return

::rcv:: 
    SendInput rcon callvote 
Return

::cq3:: 
    SendInput connect q3.click
Return

::@gm:: 
    SendInput chmielciu@gmail.com
Return

::@al:: 
    SendInput tomasz.chmielewski@alexmann.com 
Return

;---------- EXPERIMENTS BELOW ---------------------------
SC056::
Send !{SC056}
Return

CapsLock & BackSpace::
LWin & BackSpace:: 
    Suspend, Permit
    if (A_IsSuspended){
        Run, explorer.exe
        Suspend, Off
        SoundPlay %A_ScriptDir%\sounds\game_mode_off.mp3
    }
    Else{
        Run, taskkill /IM explorer.exe /F
        Suspend, On
        SoundPlay %A_ScriptDir%\sounds\game_mode_on.mp3
    }
Return

*Pause:: 
    Send {Alt Up}{Ctrl Up}{Shift Up}{LWin Up}{CapsLock Up}{XButton1 Up}{XButton2 Up}
    SetCapsLockState, Off
    SetCapsLockState, AlwaysOff
    SoundPlay %A_ScriptDir%\sounds\release_all.mp3
Return

~AppsKey & LButton:: 
    WinSet, Style, -0xC00000, A
return

;+Caption
~AppsKey & RButton:: 
    WinSet, Style, +0xC00000, A
return
;

; Note: You can optionally release the ALT key after pressing down the mouse button
; rather than holding it down the whole time.
CapsLock & j::Run, %browserExe%%browserJoin%
CapsLock & y::Run, %browserExe%%browserTranslate%
CapsLock & t::
    releaseAllModifiers()

    Send {Blind}{Ctrl down}c{Ctrl up}
    id := WinExist("Mate Translate Unpinned")
    if (!id) {
        Run, %browserExe%%browserTranslate%
        WinWait, Mate Translate Unpinned
        id := WinExist("Mate Translate Unpinned")
    }
    WinWait, ahk_id %id%
    WinActivate, ahk_id %id% 
    Sleep 100
    Send {Tab}
    Send ^a
    Send {Blind}%clipboard%
Return
CapsLock & n::
    Run, %browserExe%%browserNotes%
    if (GetKeyState("Shift")){
        WinActivate, Laverna
        WinWaitActive, Laverna
        Send c
        Sleep 150
        SendPlay ^v
    }
Return

!^w:: 
    If (id:=WinExist("Window Spy ahk_class AutoHotkeyGUI")) 
    {

        WinActivate, ahk_id %id%
    }
    else
        Run,%A_ScriptDir%\3rdParty\WindowSpy.ahk
Return

CapsLock & 0:: Run, %browserExe%%browserWebmaker%
Capslock & w:: 
    If (id:=WinExist("WinSpy ahk_class AutoHotkeyGUI")) 
    {
        if (WinActive("WinSpy ahk_class AutoHotkeyGUI")){
            WinClose, A
        }else 
        WinActivate, ahk_id %id%
    }
    else
        Run,%A_ScriptDir%\3rdParty\WinSpy.ahk ; "C:\Dev\AHK\AHK\WindowSpy.ahk"
Return

~RCtrl & AppsKey::
    wt=ahk_class NotifyIconOverflowWindow
    MouseGetPos,x,y
    WinMove,%wt%,,%x%, %y%
    WinShow, %wt%
Return

#If WinActive("ahk_class NotifyIconOverflowWindow") or isWindowVisible("ahk_class NotifyIconOverflowWindow")

~RCtrl & AppsKey::
~Esc::
    WinHide, ahk_class NotifyIconOverflowWindow
Return
#If

#If WinActive("Mate Translate Unpinned")
    ~Esc:: WinClose, A
#If

~Alt & LButton:: 
    CoordMode, Mouse ; Switch to screen/absolute coordinates.
    MouseGetPos, EWD_MouseStartX, EWD_MouseStartY, EWD_MouseWin
    WinGetPos, EWD_OriginalPosX, EWD_OriginalPosY,,, ahk_id %EWD_MouseWin%
    WinGet, EWD_WinState, MinMax, ahk_id %EWD_MouseWin%
    if EWD_WinState = 0 ; Only if the window isn't maximized
        SetTimer, EWD_WatchMouse, 10 ; Track the mouse as the user drags it.
return

#If

#F1::
    Process, Exist, DMT.exe
    If (ErrorLevel)
        SendEvent, {LWin Down}{LAlt Down}{F1}{LWin Up}{LAlt Up}
    Else 
        Send {LWin Down}{F1}{LWin Up}
Return

EWD_WatchMouse: 
    GetKeyState, EWD_LButtonState, LButton, P
    if EWD_LButtonState = U ; Button has been relseased, so drag is complete.
    {
        SetTimer, EWD_WatchMouse, off
        return
    }

    GetKeyState, EWD_EscapeState, Escape, P
    if EWD_EscapeState = D ; Escape has been pressed, so drag is cancelled.
    {
        SetTimer, EWD_WatchMouse, off
        WinMove, ahk_id %EWD_MouseWin%,, %EWD_OriginalPosX%, %EWD_OriginalPosY%
        return
    }

    ; Otherwise, reposition the window to match the change in mouse coordinates
    ; caused by the user having dragged the mouse: 
    CoordMode, Mouse
    MouseGetPos, EWD_MouseX, EWD_MouseY
    WinGetPos, EWD_WinX, EWD_WinY,,, ahk_id %EWD_MouseWin%
    SetWinDelay, -1 ; Makes the below move faster/smoother.
    WinMove, ahk_id %EWD_MouseWin%,, EWD_WinX + EWD_MouseX - EWD_MouseStartX, EWD_WinY + EWD_MouseY - EWD_MouseStartY
    EWD_MouseStartX := EWD_MouseX ; Update for the next timer-call to this subroutine.
    EWD_MouseStartY := EWD_MouseY
return

startOpacityHelper:
    Run, %A_ScriptDir%\automations\opacityDebugHelper.ahk, %A_ScriptDir%, Min
Return
startWRMB:
    Run, %A_ScriptDir%\gaming\w_rmb_swap.ahk, %A_ScriptDir%\gaming\, Min
Return
startGameMode:
    Run, %A_ScriptDir%\gaming\gameMode.ahk, %A_ScriptDir%\gaming\, Min
Return

StartSpt:
    Run,%sptPath%,,Min,sptPID
    WinWait, ahk_pid %sptPID%
    WinGet, sptHWND, ID, ahk_pid %sptPID%
    blurhwnd:=SubStr(sptHWND,3) 
    WinSet, Style, 0x90000000, ahk_id %sptHWND%
    RunWait, %blur% hwnd %blurhwnd% accent 3 2 99000000 0
    WinRestore, ahk_id %sptHWND%
    Gosub SptPositionSet
    ;WinSet, Region, w%w% h%h% R, ahk_id %sptHWND%
    OnWin("NotActive", ahk_id %sptHWND%, Func("hideSPT"))
Return

SptPositionSet:
    mm:=MouseMonitorInfo()
    w := Floor(mm["w"] * sptScale)
    h := Floor(w/2) ; Floor(A_ScreenHeight * 0.75)
    x := Floor((A_ScreenWidth - w) / 2 )+ Floor(mm["left"])
    y := Floor((A_ScreenHeight - h) / 2 )+ Floor(mm["top"])
    WinMove, ahk_id %sptHWND%,, %x%, %y%, %w%, %h%
    OutputDebug WinMove, ahk_id %sptHWND%,, %x%, %y%, %w%, %h% 
Return

hideSPT(){
    WinHide, ahk_id %sptHWND%
Return
}

RunWaitOne(command) {
    ; WshShell object: http://msdn.microsoft.com/en-us/library/aew9yb99¬
    shell := ComObjCreate("WScript.Shell")
    ; Execute a single command via cmd.exe
    exec := shell.Exec(ComSpec " /C " command)
    ; Read and return the command's output
return exec.StdOut.ReadAll()
}

