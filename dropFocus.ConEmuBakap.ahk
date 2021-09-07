#SingleInstance, Force
    
#Persistent
SetBatchLines, -1

SendMode Input ; Forces Send and SendRaw to use SendInput buffering for speed.
SetWorkingDir, %A_ScriptDir%
;SplitPath, A_ScriptName, , , , thisscriptname
;#MaxThreadsPerHotkey, 1 ; no re-entrant hotkey handling
DetectHiddenWindows, On
; SetWinDelay, -1 ; Remove short delay done automatically after every windowing command except IfWinActive and IfWinExist
; SetKeyDelay, -1, -1 ; Remove short delay done automatically after every keystroke sent by Send or ControlSend
; SetMouseDelay, -1 ; Remove short delay done automatically after Click and MouseMove/Click/Drag
SetTitleMatchMode, RegEx
#Include <OnWin>

wt:="ahk_exe (?:alacritty\.exe)|(?:mintty\.exe)"
;ce:="ahk_exe ConEmu\d*\.exe"
ce:="ahk_exe Terminus.exe ahk_class Chrome_WidgetWin_1"
;OnWin("Active", wt, Func("C"))
OnWin("NotActive", ce, Func("CT_enable"))

C(this){   
    global wt
    OutputDebug wt %wt%
    WinGet, hWnd, ID, A
    WinGetTitle, titl,  A
    OutputDebug, %  hWnd . " " . titl
    rootHWND := DllCall("user32\GetAncestor", Ptr,hWnd, UInt,2) ;GA_PARENT = 1 GA_ROOT = 2
    OutputDebug, ahk_id %rootHWND%
    WinActivate, ahk_id %rootHWND%
    WinWaitActive, ahk_id %rootHWND%
    WinGetTitle, titl, ahk_id %rootHWND%
    OutputDebug, uuu
    OnWin("Active", wt, Func("C"))
    Return
}

CT_enable(this){
    global ce  
    hwnd:=WinExist(ce)
    hwnd:=SubStr(hwnd,3)
    Run,%A_ScriptDir%\3rdParty\SetWindowCompositionAttribute.exe hwnd %hwnd% accent 2 1 22000000 0,,Hide
    Run, %A_ScriptDir%\3rdParty\SetWindowCompositionAttribute.exe hwnd %hwnd%  blur false,,Hide 
    WinSet, Transparent, 100, %ce%
    WinSet, ExStyle, +0x20,%ce%
    OnWin("Active", ce, Func("CT_disable"))
    OutputDebug, ClickThrough ON
    
    Return
}

CT_disable(this){
    global ce    
    WinSet, ExStyle, -0x20, %ce%
    WinSet, Transparent, Off, %ce%
    hwnd:=WinExist(ce)
    hwnd:=SubStr(hwnd,3)
    Run, %A_ScriptDir%\3rdParty\SetWindowCompositionAttribute.exe hwnd %hwnd% accent 3 2 df000000 0,,Hide
    Run, %A_ScriptDir%\3rdParty\SetWindowCompositionAttribute.exe hwnd %hwnd%  blur false,,Hide
    OnWin("NotActive", ce, Func("CT_enable"))
    
    OutputDebug, ClickThrough Off
    Return
}

;DEBUG KEYS
~^!d:: Reload
~^!q:: ExitApp