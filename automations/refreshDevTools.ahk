#SingleInstance, force
#Persistent
#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.

SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
SetTitleMatchMode, RegEx

;#If WinActive("Violentmonkey$")
    
#F5::
    WinGetActiveTitle, aWin
    WinActivate, DevTools - 
    Send ^r
    WinActivate, %aWin%
Return

;#If