#SingleInstance, Force
SendMode Input
/* SetWorkingDir, %A_ScriptDir%
FileOpen("*", "r")   ; for stdin
FileOpen("*", "w")   ; for stdout
FileOpen("**", "w")  ; for stderr
 */

!PgUp::
FileAppend, %A_DDDD% - %A_TimeSincePriorHotkey%, * ;
stdin  := FileOpen("*", "r `n") 
query := stdin.ReadLine()
MsgBox, %query%
Return
