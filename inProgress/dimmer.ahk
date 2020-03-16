#SingleInstance,Ignore
#Persistent
runspeed=0
editspeed=0

dim:
if editspeed > 200
     editspeed = 200
if editspeed < 0
     editspeed = 0

SysGet, MaxX, 59
SysGet, MaxY, 59
Gui,Destroy
Gui,color,000000
Gui, -Caption +AlwaysOnTop +E0x20 +owner
Gui,show, x0 y0 w%MaxX% h%MaxY%,Light Blocking GUI
WinSet, Transparent, %editspeed%, Light Blocking GUI
Hotkey,^Escape,end,On
return

#WheelUp::
editspeed := editspeed - 10
if editspeed < 0
     editspeed = 0
if (editspeed = 0){
     Gui,Destroy
     Return
}



WinSet, Transparent, %editspeed%, Light Blocking GUI
Return
#WheelDown:: 
editspeed := editspeed + 10
if editspeed > 200
     editspeed = 200


If !WinExist("Light Blocking GUI")
Gosub dim



WinSet, Transparent, %editspeed%, Light Blocking GUI
Return

#MButton::
Gui Destroy
return

end:
Gui,Destroy
return
