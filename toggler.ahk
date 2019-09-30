#SingleInstance Force
#Persistent

default_modifier = CapsLock
set_modifier = LAlt
remove_modifier = LControl 

allowedKeys = 1,2,3,4,5,6,7,8,9,0,F1,F2,F3,F4,F5
allowedKeysArr := StrSplit(allowedKeys,",") 

global iconMargin := 10

ButtonRegister(modifier, hkey) {
     
     local fn
     fn := Func("HotkeyShouldFire").Bind(modifier)
     Hotkey If, % fn
     Hotkey % hkey, FireHotkey
}

HotkeyShouldFire(modifier, thisHotkey) {
     return GetKeyState(modifier, "P")
}

FireHotkey() {
     global default_modifier
     global set_modifier
     global windows
     If (InStr(A_ThisHotkey, set_modifier) > 0) {    ; Setting action for window to toggle
          MouseGetPos,,,WinUMID
          WinGet, currentProcessName, ProcessName, ahk_id %WinUMID%
          WinGet, currentProcessFile, ProcessPath, ahk_id %WinUMID%
          hkey_noModifiers := Trim(StrSplit(A_ThisHotkey, "&")[StrSplit(A_ThisHotkey, "&").Length()])
          OutputDebug,  % hkey_noModifiers
          
          ObjRawSet(windows, hkey_noModifiers, {"winUMID": WinUMID, "processFile": currentProcessFile, "processFilename": currentProcessName, "hotkey": hkey_noModifiers})
          
          TrayTip,WOOF! , % hkey_noModifiers . ": for " . currentProcessName . " window."
          Return
     }else {  ; Toggle window 
          OutputDebug, 2 Toggle action -  %default_modifier% + %A_ThisHotkey%
          if (windows[A_ThisHotkey]){
               WinUMID := windows[A_ThisHotkey]["WinUMID"]
               if (ID := WinExist("ahk_id " . WinUMID)){
                    WinGet, state, MinMax, ahk_id %WinUMID%
                    
                    if (state = -1) {
                         WinRestore ahk_id %WinUMID%
                         WinActivate
                    } Else {
                         ;SetTitleMatchMode, RegEx
                         ;WinGet, id, list,,,i)^$|Program\sManager
                         ;SetTitleMatchMode, 2
                         WinGetPos , X, Y, , , ahk_id %WinUMID%
                         If  ( WinActive("ahk_id " . WinUMID))
                         WinMinimize, ahk_id %WinUMID%
                         Else
                         WinActivate, ahk_id %WinUMID%
                    } 
               }Else {
                    MsgBox, Window must have been closed. Removing this slot. 
                    windows.Delete(A_ThisHotkey)
               }
          } Else {
               TrayTip,WOOF!, No WinUMID
          }
          
     }
     
}

global windows := {}

ButtonRegister(default_modifier, "LAlt & 1")

!

for k, v in allowedKeysArr{
     ButtonRegister(default_modifier, v)
     ButtonRegister(default_modifier, set_modifier . " & " . v)
     ;S	OutputDebug,  ButtonRegister(%default_modifier%, %set_modifier% & %v%)
}


GuiEscape:
GuiClose:
Gui, Destroy


ScrollLock::
w := A_ScreenWidth,h := 20
if windows.Count() <= 0
     Return

Gui +LastFoundExist
if (WinExist()) {
     Gui, Destroy
     Return
}



Gui, +LastFound
WinSet, Transparent, 200
Gui, Color, 242424
Gui, Margin, 0, 0
Gui Font, s9 Norm cFFFFFF, Segoe UI
Gui -MinimizeBox -MaximizeBox -SysMenu +AlwaysOnTop -Theme -Caption +Owner


; add listview control - will have single raw and column for each process 
Gui Add, ListView, x0 y0 w%w% h%h% +IconSmall +0x2000 -E0x200  -0x40000 -0xC00000 
+Background0x242424
DllCall("UxTheme.dll\SetWindowTheme", "Ptr", hLVItems, "WStr", "Explorer", "Ptr", 0)
; Create ImageList for columns icons
ImageListID := IL_Create(windows.Count())
LV_SetImageList(ImageListID)

for k, v in windows 
{
     ;add icon to imageList - needed for listview column with icon
     IconId := IL_Add(ImageListID, v["processFile"], 1)
     if (A_Index <> IconId){
          MsgBox, % "Err: A_Index - " . A_Index . ", IconNum - " . IconId  
     }
     LV_Add("Icon" . A_Index,v["hotKey"] . ": " .  v["processFileName"])
     
}

;     LV_InsertCol(1, )
;      Gui Add, Picture, x%x% y%y% w32 h-1 +Icon1, % v["processFile"]
;MsgBox, % default_modifier . " " . v["hotkey"] . "`n" v["processFilename"] 
;   Gui Add, Text, x%x2% y%y2% w72 +Center +0xC, % v["hotkey"] . ": " . RegExReplace(v["processFilename"], "\.[^\.]+$", "") 
;Gui Add, Text, x%x% y%y2% w100 h24, x%x% y%y% y2%y2%
;}



Gui, Show, w%w% h%h% x0 y0 




Return














































