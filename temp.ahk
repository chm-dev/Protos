
#Include, %A_ScriptDir%\automations\bp.ahk

#If WinActive("ahk_exe mstsc.exe") 
    
!+Enter::Send Alexmann23

!+Backspace:: 
    
    RDPWorkArea(40, 40)
 ;   Gosub taskbarFix
    
    WinGet, transcolor, TransColor, ahk_class TscShellContainerClass
    If (!transcolor)
        WinSet TransColor, 05d7de,ahk_class TscShellContainerClass
    Else
        WinSet TransColor, Off, ahk_class TscShellContainerClass
Return
!+=::
  ;  Gosub taskbarFix
    RDPWorkArea(40, 40)
Return
#If
    

!+=::
!+Backspace:: 
    RDPWorkArea()
Return

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
; LWin::!Home  
; ^LWin::Lwin
+Esc::!Home
!Space::!Delete

#If
    
taskbarFix:
    SysGet, w, 78
    SysGet, h, 79
    
    
    WinRestore,ahk_class TscShellContainerClass
    ;WinGetPos, x,y,w,h,ahk_class TscShellContainerClass
    x:=y:=0
    WinGetPos,,,,tbh,ahk_class Shell_TrayWnd
    nh:=h-tbh+18 ;roughly scrollbars
    nw:=w+16
    WinSet, Style, 0x16030100, ahk_class TscShellContainerClass
    
    
    WinMove, ahk_class TscShellContainerClass,, %x%, %y%,%nw%,%nh%
    
    ;WinSet, Top,, ahk_class Shell_TrayWnd
Return

SetWorkArea(left,top,right,bottom)  ; set main monitor work area ; windows are not resized!
{
    VarSetCapacity(area, 16)
    NumPut(left,  area, 0, "UInt") ; left
    NumPut(top,   area, 4, "UInt") ; top
    NumPut(right, area, 8, "UInt") ; right
    NumPut(bottom,area,12, "UInt") ; bottom
    DllCall("SystemParametersInfo", "UInt", 0x2F, "UInt", 0, "UPtr", &area, "UInt", 0) ; SPI_SETWORKAREA
}

RDPWorkArea(limittop:=0, limitbottom:=0)
{  
    vw:=A_ScreenWidth 
    ;SysGet, vw, 78
    vh:=A_ScreenHeight
    ;SysGet, vh, 79
    nh:=vh-limittop-limitbottom
    nw:=vw
    x:=0
    y:=limittop
    ;second display - hardcoded ugly af but i cant be bothered
    nw2:=vw*2
    nh2:=nh
    x2:=vw
    y2:=y
    SetWorkArea(x2, y2, nw2,nh2)
    SetWorkArea(x, y, nw,nh)
    
Return
}