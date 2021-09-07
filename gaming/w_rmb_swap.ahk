#NoEnv ; Recommended for performance and compatibility with future AutoHotkey releases.
#Persistent 
#UseHook 
; #Warn  ; Enable warnings to assist with detecting common errors.

SetTitleMatchMode, RegEx
SendMode Event ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir% ; Ensures a consistent starting directory.

;#If WinActive("ahk_exe RDR2\.exe") 

RButton::w
w::RButton

;#If

