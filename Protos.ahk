#Persistent 
#SingleInstance Force
#InstallKeybdHook
#InstallMouseHook
DetectHiddenWindows, On
SetTitleMatchMode, RegEx
SendMode, Event
SetWorkingDir %A_ScriptDir%
SetBatchLines -1
SetKeyDelay, 0
SetCapsLockState, AlwaysOff
SetNumLockState, Off
Menu, Tray, Icon, %A_ScriptDir%\protos.png, 1

global ClipSaved
global cmderMode := 0

global playerExe = "Spotify.exe"
global playerHWND 
playerPath = %A_AppData%\Spotify\%playerExe%
playerWinTitle = ahk_exe %playerExe% 
GroupAdd, SpotifyGrp, ahk_exe %playerExe%,,,^.?$ ;global window group holding ... only main window thanks to regex .. it is totally stupid and should be changed ;)


global browserExe = "C:\Users\chm\AppData\Local\Vivaldi\Application\vivaldi.exe --window-size=480x480 --app=chrome-extension://ihmgiclibbndffejedjimfjmfoabpcke/pages/public/window.html"
global thm

#include %A_ScriptDir%\Lib\TapHoldManager.ahk
; TapTime / Prefix can now be set here
thm := new TapHoldManager(,,,"~")
thm.Add("LAlt", Func("openLauncher"))
thm.Add("CapsLock", Func("sendMegaModifier"))
#Include %A_ScriptDir%\toggler.ahk ; it has to be after first capslock definitions

openLauncher(isHold, taps, state){
    if (taps = 2 and GetKeyState("ScrollLock", "T")=0)
        Send {LAlt Down}{BackSpace}{LAlt Up}
    Return
}

sendMegaModifier(isHold, taps, state){
    
    if (taps = 2 and state = 1 and GetKeyState("ScrollLock", "T")=0){
        OutputDebug entry: %isHold%, %taps%, %state%
        Send {Blind}{LCtrl Down}{LShift Down}{LAlt Down}
        SoundPlay %A_ScriptDir%\sounds\light_ball_02.wav
        ;SoundBeep 750, 300 
        KeyWait CapsLock, T1.4        
        OutputDebug after Loop %isHold%, %taps%, %state%
            Send {Blind}{LCtrl Up}{LShift Up}{LAlt Up}
        SoundPlay %A_ScriptDir%\sounds\light_ball_01.wav
    }   
    Return
}
releaseAllModifiers() 
{ 
    list = Control|Alt|Shift 
    Loop Parse, list, | 
    { 
        if (GetKeyState(A_LoopField)) 
            send {Blind}{%A_LoopField% up}       ; {Blind} is added.
        } 
} 

~ScrollLock::
    If (GetKeyState("ScrollLock", "T")){
        Menu, Tray, Icon, %A_ScriptDir%\protos_off.png, 1
        SoundPlay, %A_ScriptDir%\sounds\protos_off.mp3
        
    }Else {
        Menu, Tray, Icon, %A_ScriptDir%\protos.png, 1
        SoundPlay, %A_ScriptDir%\sounds\protos_on.mp3
    }
    
Return

#If, GetKeyState("ScrollLock", "T") = 0  ;only if scrolllock is off
Menu, Tray, Icon, %A_ScriptDir%\protos.png, 1

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

CapsLock & LButton::
    WinUMID := getCursorWindow()
    if (WinUMID = -1) 
        Return
    WinSet  AlwaysOnTop, Toggle, ahk_id %WinUMID%
    WinGet, exs, ExStyle, ahk_id %WinUMID%
    if (exs & 0x8) {   ;Always on top on
        WinSet, Transparent, 240, ahk_id %WinUMID%
    }else { ; AOT Off
        WinSet, Transparent, Off, ahk_id %WinUMID%
    }
Return

CapsLock & WheelDown:: 
    WinUMID := getCursorWindow()
    if WinUMID = -1
        Return  
    WinMinimize ahk_id %WinUMID%
Return

CapsLock & WheelUp:: 
    WinUMID   := getCursorWindow()
    if WinUMID = -1
        Return 
    WinMaximize ahk_id %WinUMID%
Return

CapsLock & MButton:: 
    WinUMID   := getCursorWindow()
    if WinUMID = -1
        Return 
    WinRestore ahk_id %WinUMID%
Return

CapsLock & XButton1:: 
    activateCursorWindow()
    Send #{Left}
Return

CapsLock & XButton2:: 
    WinUMID    := getCursorWindow()
    if WinUMID = -1
        Return 
    
    WinActivate, ahk_id %WinUMID%
    Send #{Right}
Return

;AppsKey & l:: 
;MsgBox l
;Return

CapsLock & r:: 
    Reload
Return

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

;^!WheelUp::Send ^!{WheelUp} ; Send {Volume_Up 3}
;^!WheelDown:: Send +!{WheelDown}
XButton1 & MButton:: 
^!MButton:: 
    Send {Volume_Mute}
Return
XButton1:: Return
XButton2:: Return
^XButton1:: Send #^{Right}
^XButton2:: Send #^{Left}
!XButton1::
    activateCursorWindow()  
    Send #+{Right}
Return
!XButton2:: 
    activateCursorWindow()
    Send #+{Left}
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

CapsLock & LWin:: 
    if (cmderMode = 0) {
        cmderMode := 1
        SoundPlay, %A_ScriptDir%\sounds\cmder_mode_on.mp3
    }else {
        cmderMode := 0
        SoundPlay, %A_ScriptDir%\sounds\cmder_mode_off.mp3
    }
Return

#If cmderMode = 1 and GetKeyState("ScrollLock", "T") = 0
    
LWin:: 
    Send {LAlt Down}``{LAlt Up}
Return
`::LWin
^`::Send ``

AppsKey:: LWin
;$+#:: LWin
;AppsKey:: LWin
#If

CapsLock & s:: 
    
    OutputDebug, %A_TitleMatchMode%, HiddenWIndows %A_DetectHiddenWindows%
    Process, Exist, Spotify.exe
    OutputDebug, %ErrorLevel% 
    
    if (ErrorLevel){
        
        
        
        grp := "ahk_group SpotifyGrp"
        WinGet, hwnd,ID, %grp%
        playerHWND = ahk_id %hwnd%
        OutputDebug, found hwnd %playerHWND%
        
        
        
        if (isWindowVisible(grp)){
            OutputDebug, is visible
            If  (WinActive(grp)){
                OutputDebug, is active, WinHide
                WinHide, %grp%                 
            } Else {
                OutputDebug, not active so restoring, just in case and activating
                WinRestore, %grp%
                WinActivate, %grp%           
            }
        }else {
            OutputDebug, is not visible - showing
            WinShow, %grp%
            WinActivate, %grp%      
        }
    }else{
        OutputDebug  not running, start
        Run, %A_AppData%\Spotify\Spotify.exe
    }  
Return
#If WinActive("ahk_group SpotifyGrp")
~Esc::WinHide, A
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
*Pause:: 
    Send {Alt Up}{Ctrl Up}{Shift Up}{LWin Up}{CapsLock Up}
    SetCapsLockState, AlwaysOff
    SoundPlay %A_ScriptDir%\sounds\release_all.mp3
Return

AppsKey & LButton:: 
    WinSet, Style, -0xC00000, A
return
;

;+Caption
AppsKey & RButton:: 
    WinSet, Style, +0xC00000, A
return
;

; Note: You can optionally release the ALT key after pressing down the mouse button
; rather than holding it down the whole time.

CapsLock & y::Run, %browserExe%
CapsLock & t::
    releaseAllModifiers()
    Send {Blind}{Ctrl down}c{Ctrl up}
    id := WinExist("Mate Translate Unpinned")
    if (!id) {
        Run, %browserExe%
        WinWait, Mate Translate Unpinned
        id := WinExist("Mate Translate Unpinned")
    }
    WinWait, ahk_id %id%
    WinActivate 
    Sleep 200
    Send {Blind}{Ctrl down}av{Ctrl up}
Return

Capslock & w:: Run, %A_AhkPath% "C:\Dev\AHK\AHK\WindowSpy.ahk"

#If WinActive("Mate Translate Unpinned")
    ~Esc:: WinClose, A
#If



~Alt & LButton:: 
    CoordMode, Mouse  ; Switch to screen/absolute coordinates.
    MouseGetPos, EWD_MouseStartX, EWD_MouseStartY, EWD_MouseWin
    WinGetPos, EWD_OriginalPosX, EWD_OriginalPosY,,, ahk_id %EWD_MouseWin%
    WinGet, EWD_WinState, MinMax, ahk_id %EWD_MouseWin%
    if EWD_WinState                                 = 0  ; Only if the window isn't maximized
        SetTimer, EWD_WatchMouse, 10 ; Track the mouse as the user drags it.
return

#If

EWD_WatchMouse: 
    GetKeyState, EWD_LButtonState, LButton, P
    if EWD_LButtonState = U  ; Button has been relseased, so drag is complete.
    {
        SetTimer, EWD_WatchMouse, off
        return
    }
    
    GetKeyState, EWD_EscapeState, Escape, P
    if EWD_EscapeState = D  ; Escape has been pressed, so drag is cancelled.
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
    SetWinDelay, -1   ; Makes the below move faster/smoother.
    WinMove, ahk_id %EWD_MouseWin%,, EWD_WinX + EWD_MouseX - EWD_MouseStartX, EWD_WinY + EWD_MouseY - EWD_MouseStartY
    EWD_MouseStartX := EWD_MouseX  ; Update for the next timer-call to this subroutine.
    EWD_MouseStartY := EWD_MouseY
return

