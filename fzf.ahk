SetTitleMatchMode, Regex
#Persistent
SetWorkingDir %A_ScriptDir%

#Include <ConsoleApp>

#If WinActive("i)([a-zA-Z]{1}:|\\)(\\[^\\/<>:\|\*\?\n]*)+$")
CapsLock & f::
    {
        ;	WinActivate, i)^([a-zA-Z]{1}:|\\)(\\[^\\/<>:\|\*\?\"\n]*)+$
        WinGetTitle, titlePath, i)^([a-zA-Z]{1}:|\\)(\\[^\\/<>:\|\*\?\"\n]*)+$
        OutputDebug, %titlePath%
        If StrLen(titlePath) < 2
            Return
        SplitPath, titlePath, fname, dir, ext, noext, drv
        
        If StrLen(ext) = 0{
            
            WinGetPos, x, y, w, h, A
            ControlGetPos, cx,cy,cw,ch,dopus.filedisplay1,ahk_exe dopus.exe
            if (cw>200 and ch>150){
                x+=cx
                y+=cy
                w:=cw
                h:=ch
            }
            OutputDebug,pwsh -c cd /D %titlePath% && fzf | Set-Variable run && Start-Process $run,,Min,cmdPid  
            
            OutputDebug, Run, %A_ComSpec% /c "cd /D %titlePath% && fzf | set run && Start-Process %run%",,Min,cmdPid
            
            Run, pwsh.exe -wd "%titlePath%" -c  fzf | Set-Variable st && Start-Process \"$st\" && Remove-Variable st,,Min,cmdPid
            
            ;Run, %A_ComSpec% /c "cd /D %titlePath% && fzf | Set-Variable run && Start-Process $run",,Min,cmdPid
            WinSet, Transparent, 0, ahk_pid %cmdPid%
            WinWait, ahk_pid %cmdPid%
            WinSet, Transparent, 0, ahk_pid %cmdPid%
            WinGet, hwnd, ID, ahk_pid %cmdPid%
            hwndB:=SubStr(hwnd,3)
            
            Run, %A_ScriptDir%\3rdParty\SetWindowCompositionAttribute.exe hwnd %hwndB% accent 3 2 CC382712 0,,Hide
            ;Run, %A_ScriptDir%\3rdParty\SetWindowCompositionAttribute.exe hwnd %hwndB% blur true
            WinSet, Style, 0x140B0000, ahk_id %hwnd%
            WinRestore, ahk_id %hwnd%
            WinMove, ahk_id %hwnd%,,%x%,%y%,%w%,%h%
            WinActivate, ahk_id %hwnd%
            WinSet, Transparent, Off, ahk_id %hwnd%
            OutputDebug, WinMove, ahk_id %hwnd%,,%x%,%y%,%w%,%h%
            WinWaitNotActive, ahk_id %hwnd%
            WinClose, ahk_id %hwnd%
            
        }
        Return
    }
    
    #If
        
    ^!r::Reload