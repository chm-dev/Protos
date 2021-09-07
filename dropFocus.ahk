#SingleInstance, Force 
#Persistent
SetBatchLines, -1
SendMode Input ; Forces Send and SendRaw to use SendInput buffering for speed.
SetWorkingDir, %A_ScriptDir%
DetectHiddenWindows, On
SetTitleMatchMode, RegEx
#Include <OnWin>
ce:="ahk_exe extraterm.exe ahk_class Chrome_WidgetWin_1"
fadedOpacity:=50

OnWin("NotActive", ce, Func("CT_enable"))

CT_enable(this){  
    global ce 
    global fadedOpacity
    hwnd:=WinExist(ce)
    hwnd:=SubStr(hwnd,3)
    Run,%A_ScriptDir%\3rdParty\SetWindowCompositionAttribute.exe hwnd %hwnd% accent 2 1 22000000 0,,Hide
    Run, %A_ScriptDir%\3rdParty\SetWindowCompositionAttribute.exe hwnd %hwnd% blur false,,Hide 
    WinSet, Transparent, %fadedOpacity%, %ce%
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
    Run, %A_ScriptDir%\3rdParty\SetWindowCompositionAttribute.exe hwnd %hwnd% blur false,,Hide
    OnWin("NotActive", ce, Func("CT_enable"))
    
    OutputDebug, ClickThrough Off
    Return
}

#If WinExist(ce)
    
!`::
    if WinActive(ce) 
    {
        WinActivate ahk_class Progman
        WinHide, %ce% 
    }else
    {
        WinShow, %ce%
        WinActivate, %ce%
    }
    
    
Return 
#If
    ;DEBUG KEYS
~^!d:: Reload
~^!q:: ExitApp