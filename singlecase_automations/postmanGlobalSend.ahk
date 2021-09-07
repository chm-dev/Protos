#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
DetectHiddenWindows, On
wt=Postman ahk_class Chrome_WidgetWin_1 ahk_exe Postman.exe

F5::
    WinGet, max, MinMax,%wt%
    if (max != 1 )
        WinMaximize, %wt%
    ControlClick, X1747 Y232, %wt%,,,, NA
    ;995, 349`
Return

^F5::WinHide, %wt%
^F6::WinShow, %wt%