#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
SetTitleMatchMode, slow

WindowTitle=ShareX - Color picker
sxctrl=WindowsForms10.EDIT.app.0.36c601b_r6_ad ;15-13
scictrl=Edit ;4-6

!+v::
    ControlGetText, red, %sxctrl%15, %WindowTitle%
    ControlGetText, green, %sxctrl%14, %WindowTitle%
    ControlGetText, blue, %sxctrl%13, %WindowTitle%
    ControlSetText, %scictrl%4, %red%, Color
    ControlSetText, %scictrl%5, %green%, Color
    ControlSetText, %scictrl%6, %blue%, Color
Return

^XButton1::ControlSend,,{Enter},%WindowTitle%

#c::
ControlClick,WindowsForms10.BUTTON.app.0.36c601b_r6_ad19, %WindowTitle%
Return