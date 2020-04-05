#SingleInstance, Force
    SendMode Input

#SingleInstance, Force
    #KeyHistory, 0
SetBatchLines, -1
ListLines, Off
SendMode Input ; Forces Send and SendRaw to use SendInput buffering for speed.
SetTitleMatchMode, 3 ; A window's title must exactly match WinTitle to be a match.
SetWorkingDir, %A_ScriptDir%
SplitPath, A_ScriptName, , , , thisscriptname
#MaxThreadsPerHotkey, 1 ; no re-entrant hotkey handling

RunWaitOne(command) {
    ; WshShell object: http://msdn.microsoft.com/en-us/library/aew9yb99¬
    shell := ComObjCreate("WScript.Shell")
    ; Execute a single command via cmd.exe
    
    exec := shell.Exec("pwsh.exe  " command)
    ; Read and return the command's output
    return exec.StdOut.ReadAll()
}
res := RunWaitOne("cd \Dev\ && fzf")

MsgBox, %res%