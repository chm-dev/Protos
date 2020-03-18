#SingleInstance, Force
#Persistent
SetBatchLines, -1

SendMode Input ; Forces Send and SendRaw to use SendInput buffering for speed.
SetWorkingDir, %A_ScriptDir%
SplitPath, A_ScriptName, , , , thisscriptname
;#MaxThreadsPerHotkey, 1 ; no re-entrant hotkey handling
; DetectHiddenWindows, On
; SetWinDelay, -1 ; Remove short delay done automatically after every windowing command except IfWinActive and IfWinExist
; SetKeyDelay, -1, -1 ; Remove short delay done automatically after every keystroke sent by Send or ControlSend
; SetMouseDelay, -1 ; Remove short delay done automatically after Click and MouseMove/Click/Drag
SetTitleMatchMode, RegEx
#Include <OnWin>
OutputDebug, __ vz
wt:="ahk_exe (?:alacritty\.exe)|(?:mintty\.exe)"
ce:="ahk_exe ConEmu\.exe"
OnWin("Active", wt, Func("C"))
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
}

;Input, SingleKey, L1, {LControl}{RControl}{LAlt}{RAlt}{LShift}{RShift}{LWin}{RWin}{AppsKey}{F1}{F2}{F3}{F4}{F5}{F6}{F7}{F8}{F9}{F10}{F11}{F12}{Left}{Right}{Up}{Down}{Home}{End}{PgUp}{PgDn}{Del}{Ins}{BS}{CapsLock}{NumLock}{PrintScreen}{Pause}   