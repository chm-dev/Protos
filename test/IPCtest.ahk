#SingleInstance, Force
SendMode Input
SetWorkingDir, %A_ScriptDir%
DetectHiddenWindows, On
OutputDebug, CHAAJ
self := WinExist("Ahk_PID " DllCall("GetCurrentProcessId"))
OutputDebug, %self%

#Include %A_ScriptDir%\IPC.ahk

IPC_SetHandler("onMsg")

OnMsg(Hwnd, Data, Port, DataSize){
    OutputDebug, Data - %Data%
    OutputDebug, DataSize - %DataSize%
    OutputDebug, Port- %Port%
    OutputDebug, Hwnd - %Hwnd%
    
}
Return

^!r::Reload

^!s::IPC_Send(self,"Czefsa fsaf asfsaf saf asfasfsafsafas")
^!d::IPC_Send("0x1706e2","Czefsa fsaf asfsaf saf asfasfsafsafas")