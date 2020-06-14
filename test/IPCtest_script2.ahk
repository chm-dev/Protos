SetTitleMatchMode, 3
DetectHiddenWindows, On
; Example: Send a string of any length from one script to another. This is a working example.
; To use it, save and run both of the following scripts then press Win+Space to show an
; InputBox that will prompt you to type in a string.

; Save the following script as "Receiver.ahk" then launch it:
#SingleInstance
OutputDebug, To ja drugi skrypt
self := WinExist("ahk_PID " DllCall("GetCurrentProcessId"))
OutputDebug, %self%

OnMessage(0x4a, "Receive_WM_COPYDATA") ; 0x4a is WM_COPYDATA
return

Receive_WM_COPYDATA(wParam, lParam)
{
    StringAddress := NumGet(lParam + 2*A_PtrSize) ; Retrieves the CopyDataStruct's lpData member.
    CopyOfData := StrGet(StringAddress) ; Copy the string out of the structure.
    ; Show it with ToolTip vs. MsgBox so we can return in a timely fashion:
    MsgBox %A_ScriptName%`nReceived the following string:`n%CopyOfData%
    return true ; Returning 1 (true) is the traditional way to acknowledge this message.
}

; Save the following script as "Sender.ahk" then launch it. After that, press the Win+Space hotkey.
TargetScriptTitle:="IPCtest.ahk"
OutputDebug, %TargetScriptTitle% 
#space:: ; Win+Space hotkey. Press it to show an InputBox for entry of a message string.
InputBox, StringToSend, Send text via WM_COPYDATA, Enter some text to Send:
    if ErrorLevel ; User pressed the Cancel button.
        return
    result := Send_WM_COPYDATA(StringToSend, "IPCtest.ahk")
    if result = FAIL
        MsgBox SendMessage failed. Does the following WinTitle exist?:`n%TargetScriptTitle%
    else if result = 0
        MsgBox Message sent but the target window responded with 0, which may mean it ignored it.
return

Send_WM_COPYDATA(ByRef StringToSend, ByRef TargetScriptTitle) ; ByRef saves a little memory in this case.
; This function sends the specified string to the specified window and returns the reply.
; The reply is 1 if the target window processed the message, or 0 if it ignored it.
{
    VarSetCapacity(CopyDataStruct, 3*A_PtrSize, 0) ; Set up the structure's memory area.
    ; First set the structure's cbData member to the size of the string, including its zero terminator:
    SizeInBytes := (StrLen(StringToSend) + 1) * (A_IsUnicode ? 2 : 1)
    NumPut(SizeInBytes, CopyDataStruct, A_PtrSize) ; OS requires that this be done.
    NumPut(&StringToSend, CopyDataStruct, 2*A_PtrSize) ; Set lpData to point to the string itself.
    Prev_DetectHiddenWindows := A_DetectHiddenWindows
    Prev_TitleMatchMode := A_TitleMatchMode
    DetectHiddenWindows On
    SetTitleMatchMode 2
    TimeOutTime = 4000 ; Optional. Milliseconds to wait for response from receiver.ahk. Default is 5000
    ; Must use SendMessage not PostMessage.
    SendMessage, 0x4a, 0, &CopyDataStruct,, %TargetScriptTitle%,,,, %TimeOutTime% ; 0x4a is WM_COPYDATA.
    DetectHiddenWindows %Prev_DetectHiddenWindows% ; Restore original setting for the caller.
    SetTitleMatchMode %Prev_TitleMatchMode% ; Same.
return ErrorLevel ; Return SendMessage's reply back to our caller.
}

; Example: See the WinLIRC client script for a demonstration of how to use OnMessage() to receive
; notification when data has arrived on a network connection.

^!f::Reload