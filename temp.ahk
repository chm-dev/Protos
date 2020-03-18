
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
#If WinActive("ahk_exe mstsc.exe") and GetKeyState("ScrollLock", "T") = 0 
    

!XButton1::Return
!XButton2::Return
CapsLock & WheelDown::Return
CapsLock & WheelUp::Return

Send {Alt Down}{Home Down}{Shift Down}{Right}{Shift Up}{Home Up}{Alt Up}
Return
!Tab::!PgUp
!+Tab::!PgDn
LWin::!Home
^LWin::Lwin
+Esc::!Home
!Space::!Delete

#If
    
