
#If WinActive("azneagirpawks04")
    
!+Enter::Send Alexmann23

!+Backspace:: 
    WinGet, transcolor, TransColor, azneagirpawks04
    ;MsgBox, %transcolor%
    If (!transcolor)
        WinSet TransColor, 05D7DE,azneagirpawks04
    Else
        WinSet TransColor, Off, azneagirpawks04
Return

#If
    
;730073, 
