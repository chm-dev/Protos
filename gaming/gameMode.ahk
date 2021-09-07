#NoEnv ; Recommended for performance and compatibility with future AutoHotkey releases.
#Persistent 
#UseHook 
; #Warn  ; Enable warnings to assist with detecting common errors.
SetTitleMatchMode, 1
SendMode Event ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir% ; Ensures a consistent starting directory.
Menu, Tray, Icon, %A_ScriptDir%\Assets\playing.ico

;#If WinActive("ahk_exe RDR2.exe") or WinActive("ahk_exe DaysGone.exe")

LAlt & Tab::
  Send {Tab Down}
  KeyWait, Tab
  Send {Tab Up}
return

; Disable Windows Key + Tab
#Tab::Return

; Disable Left Windows Key
LWin::Return

LWin & q:: ExitApp
LWin & BackSpace:: 
  Suspend, Permit
  MsgBox, %A_IsSuspended%
  if (A_IsSuspended){
    Run, explorer.exe
    Suspend, Off
  }
  Else{
    Run, taskkill /IM explorer.exe /F
    Suspend, On
  }
Return

