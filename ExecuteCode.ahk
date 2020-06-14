#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.

ExecScript(Script, Wait:=true)
{
    shell := ComObjCreate("WScript.Shell")
    exec := shell.Exec("AutoHotkey.exe /ErrorStdOut *")
    exec.StdIn.Write(script)
    exec.StdIn.Close()
    if Wait
        return exec.StdOut.ReadAll()
}

; run "starter.ahk ole caramba" from Command-Line

#SingleInstance force
    
argument_count = %0%
argument_1 = %1%
argument_2 = %2%

Msgbox, You got %argument_count% Arguments and those are -> %argument_1% <- and  -> %argument_2% <-

return