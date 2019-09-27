#SingleInstance Force
#Persistent
SetWorkingDir %A_ScriptDir%
SetBatchLines -1
global ClipSaved
SetKeyDelay, 0
SetCapsLockState, AlwaysOff
Menu, Tray, Icon, %A_ScriptDir%\protos.png, 1
SetWorkingDir %A_ScriptDir% 


getCursorWindow(){
     MouseGetPos,,,WinUMID
     WinGet, pName, ProcessName, ahk_id %WinUMID%
     If (InStr(pName, "explorer") or pName = "")	
     Return -1
     Else
     Return WinUMID 
}

#Include %A_ScriptDir%\toggler.ahk
#Include %A_ScriptDir%\dimmer.ahk


CapsLock:: Return 

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
WinUMID := getCursorWindow()
if WinUMID = -1 
     Return 
WinActivate, ahk_id %WinUMID%
Send #{Left}
Return

CapsLock & XButton2:: 
WinUMID := getCursorWindow()
if WinUMID = -1 
     Return 

WinActivate, ahk_id %WinUMID%
Send #{Right}
Return
!+v::
global ClipSaved := ClipboardAll 
Clipboard = <process name="__selection__ISAAC Deloitte - TALEO UI Chrome automation" type="object" runmode="Exclusive"><stage stageid="436ee60b-0d79-4ee8-868b-f34d0083ac02" name="Action1" type="Action"><subsheetid>fbf83eaa-f7ce-4c72-ae74-91471a5f8a72</subsheetid><loginhibit /><narrative></narrative><displayx>195</displayx><displayy>-135</displayy><displaywidth>60</displaywidth><displayheight>30</displayheight><font family="Segoe UI" size="10" style="Regular" color="000000" /><inputs><input type="text" name="Css selector" expr="" /><input type="text" name="Session ID" expr="[sessionId]" /><input type="flag" name="Optional: Omit exception." narrative="Default is False" expr="" /><input type="number" name="Optional: Wait for element (ms)" expr="" /></inputs><outputs><output type="flag" name="success?" stage="" /></outputs><resource object="ChromeDriver" action="Click on element" /></stage></process>
Sleep, 50
Send {LCtrl down}v{LCtrl up}
Return

;AppsKey & l:: 
;MsgBox l
;Return

CapsLock & r::
Reload
Return

^!v:: 
SendEvent {Raw}  %Clipboard%
Return

 
CapsLock & v::

if (InStr(Clipboard, "document.query")){
SendStr := RegExReplace(Clipboard, "^""(.+)""$", "$1")
SendStr := StrReplace(SendStr, """""", """",,-1)
SendEvent {Raw} %SendStr%    
} Else {
SendStr := StrReplace(Clipboard, """", """""")
SendStr := RegExReplace(SendStr, "document\.querySelector(?:All)?\('?([^\(\)]*)'\)", "$1")
SendEvent {Raw} "%SendStr%"
}

Return





^!WheelUp::Send {Volume_Up 3}
^!WheelDown::Send {Volume_Down 3}
^!MButton::Volume_Mute
XButton1:: Return
XButton2:: Return
^XButton1:: Send #^{Right}
^XButton2:: Send #^{Left}
!XButton1:: Send #+{Right}
!XButton2:: Send #+{Left}
NumpadIns:: Send {Media_Play_Pause}
NumpadDel:: Send {Media_Stop}
NumpadEnd:: Send {Media_Prev}
NumpadDown:: Send {Media_Next}
NumpadAdd:: Send {Volume_Up 4}
NumpadSub:: Send {Volume_Down 4}

::dqs::
SendInput document.querySelector(''){Left 2}
Return

::dqsa::
SendInput document.querySelectorAll(''){Left 2}
Return

::ses::
SendInput [sessionId]
Return



;---------- EXPERIMENTS BELOW ---------------------------
CapsLock & z:: Run, "C:\Program Files (x86)\BraveSoftware\Brave-Browser\Application\chrome_proxy.exe" --profile-directory=Default --app-id=cgfennglocinhjpfenpaoimnocjogpdh

;-Caption
ScrollLock & LButton::
WinSet, Style, -0xC00000, A
return
;

;+Caption
ScrollLock & RButton::
WinSet, Style, +0xC00000, A
return
;


; Note: You can optionally release the ALT key after pressing down the mouse button
; rather than holding it down the whole time.

~Alt & LButton::
CoordMode, Mouse  ; Switch to screen/absolute coordinates.
MouseGetPos, EWD_MouseStartX, EWD_MouseStartY, EWD_MouseWin
WinGetPos, EWD_OriginalPosX, EWD_OriginalPosY,,, ahk_id %EWD_MouseWin%
WinGet, EWD_WinState, MinMax, ahk_id %EWD_MouseWin%
if EWD_WinState = 0  ; Only if the window isn't maximized
     SetTimer, EWD_WatchMouse, 10 ; Track the mouse as the user drags it.
return

EWD_WatchMouse:
GetKeyState, EWD_LButtonState, LButton, P
if EWD_LButtonState = U  ; Button has been released, so drag is complete.
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















