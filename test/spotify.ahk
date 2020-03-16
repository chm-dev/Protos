#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
; SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
; Ensures a consistent starting directory.
debugPort := 9922
spotifyExe = Spotify.exe
#Include %A_ScriptDir%\lib\Chrome.ahk
KillAllProcessByName(strProcessName, strExceptPIDs="") {
    ;[Parameters]
    ;   strProcesName : the proess name to be closed. e.g. AutoHotkey.exe
    ;   strExceptPIDs : a list of eception PIDs not to be closed delimited by commas. e.g. 1234,5678,987
    ;[Return Value]
    ;   the count of closed processes.
    nCount := 0
    Loop {
        nClosedPID := False
        for process in ComObjGet("winmgmts:").ExecQuery("Select Name,ProcessID from Win32_Process Where Name='" strProcessName "'") {
            nLoopPID := process.ProcessID
            if nLoopPID not in %strExceptPIDs%
            {
                Process, Close, % process.ProcessID
                if (nClosedPID := ErrorLevel)
                    nCount++
            }
        }
    } Until !nClosedPID
    Return nCount
}




Needle := "\-\-remote-debugging-port=" . debugPort
sInstance :=

for Item in ComObjGet("winmgmts:")
		.ExecQuery("SELECT CommandLine FROM Win32_Process"
		. " WHERE Name = '" . spotifyExe . "'") {
    OutputDebug, % Item.Commandline
		if RegExMatch(Item.CommandLine, Needle, Match){
    OutputDebug, Regex Match !
			sInstance := Item.CommandLine
      break
      }
		Else 
			sInstance := false
	}


if (sInstance = false)  {
	KillAllProcessByName("Spotify.exe")
  Sleep 500
}

if (StrLen(sInstance) < 2){
 EnvGet appData, appdata
Run, %appData%\Spotify\Spotify.exe --remote-debugging-port=%debugPort%
;Run, C:\Users\chm\AppData\Local\Microsoft\WindowsApps\Spotify.exe --remote-debugging-port=%debugPort%
}

SpotInst := {"base": Chrome, "DebugPort": debugPort}



