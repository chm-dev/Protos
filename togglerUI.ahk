

IconsPath := "C:\TEMP\icons"
/*
CapsLock::
    SetTimer, showToggles, -500
showToggles:
    if (GetKeyState("CapsLock","L")){
        OutputDebug, caps 500
        WinGet, currentActive, ID, A
        ;Gui toggles:+LastFoundExist
        ;If (WinExist()) {
        Gui, toggles:Show, w%w% h%h% x0 y0 
        WinActivate, ahk_id %currentActive%
        KeyWait, %A_ThisHotkey%
        
    }
    
    
Return

ScrollLock::Gui, toggles:Show, w%w% h%h% x0 y0 
    
    
*CapsLock Up::
    SetTimer, showToggles, Off
    Gui, toggles:+LastFoundExist
    if (WinExist()){
        
        if not DllCall("IsWindowVisible", "UInt", WinExist("AutoHotkey Help")) ; WinExist() returns an HWND.
            MsgBox The window is not visible.
        
        
        Gui, toggles:Hide
        
    }
Return
*/
#Include %A_ScriptDir%\Lib\TapHoldManager.ahk

;SetCapsLockState, AlwaysOff
default_modifier = XButton1
set_modifier = XButton2
remove_modifier = LCtrl 

allowedKeys = ``,1,2,3,4,5,6,7,8,9,0,F1,F2,F3,F4,F5
allowedKeysArr := StrSplit(allowedKeys,",") 
;GUI

global windows := {}
area :=, old_area :=
w := A_ScreenWidth, h := 30
x := 0,y := 0

thm2 := new TapHoldManager(,,,"~")
thm2.Add(default_modifier " & Space", Func("ShowCurrentToggles"))

createWindow(h)

; Function declarations below

EncodeInteger( p_value, p_size, p_address, p_offset )
{
    loop, %p_size%
        DllCall( "RtlFillMemory"
    , "uint", p_address+p_offset+A_Index-1
    , "uint", 1
    , "uchar", ( p_value >> ( 8*( A_Index-1 ) ) ) & 0xFF )
}

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
    global h
    OutputDebug,%A_ThisHotkey%
    If (InStr(A_ThisHotkey, set_modifier) > 0) { ; Setting action for window to toggle
        MouseGetPos,,,WinUMID
        WinGet, currentProcessName, ProcessName, ahk_id %WinUMID%
        WinGet, currentProcessFile, ProcessPath, ahk_id %WinUMID%
        hkey_noModifiers := Trim(StrSplit(A_ThisHotkey, "&")[StrSplit(A_ThisHotkey, "&").Length()])
        OutputDebug, % hkey_noModifiers
        
        ObjRawSet(windows, hkey_noModifiers, {"winUMID": WinUMID, "processFile": currentProcessFile, "processFilename": currentProcessName, "hotkey": hkey_noModifiers})
        
        TrayTip,WOOF! , % hkey_noModifiers . ": for " . currentProcessName . " window."
        createWindow(h, true)
        ;OutputDebug %default_modifier% - %hkey_noModifiers% registered
        WinActivate, ahk_id %WinUMID%
        sleep 1000
        createWindow(h, false)
        Return
    }else { ; Toggle window 
        ; OutputDebug, 2 Toggle action - %default_modifier% + %A_ThisHotkey%
        if (windows[A_ThisHotkey]){
            WinUMID := windows[A_ThisHotkey]["WinUMID"]
            if (ID := WinExist("ahk_id " . WinUMID)){
                WinGet, state, MinMax, ahk_id %WinUMID%
                
                if (state = -1) {
                    WinRestore ahk_id %WinUMID%
                    WinActivate
                } Else {
                    WinGetPos , X, Y, , , ahk_id %WinUMID%
                    If ( WinActive("ahk_id " . WinUMID))
                        WinMinimize, ahk_id %WinUMID%
                    Else
                        WinActivate, ahk_id %WinUMID%
                } 
            }Else {
                MsgBox, Window must have been closed. Removing this slot. 
                windows.Delete(A_ThisHotkey)
                createWindow(h, true)
            }
        } Else {
            TrayTip,WOOF!, No WinUMID
        }
        
    }
    
}

createWindow(h, show:=False) {
    global w 
    
    Gui, toggles:New
    Gui, toggles:Color, 242424
    ;Gui, toggles:Margin, 2, 8
    Gui, toggles:Font, s9 Norm c999999, Segoe UI
    Gui, toggles:-MinimizeBox -MaximizeBox -SysMenu +AlwaysOnTop -Theme -Caption +Owner
    ; add listview control - will have single raw and column for each process 
    Gui, toggles:Add, ListView, x4 y5 w%w% h%h% +IconSmall +ReadOnly +0x2000 -E0x200 -0x40000 -0xC00000 +Background0x242424
    Gui toggles:+LastFound
    WinSet, Transparent, 230
    WinSet, ExStyle, +0x08000028
    ; Create ImageList for columns icons
    ImageListID := IL_Create(windows.Count())
    LV_SetImageList(ImageListID)
    LV_Delete() ; remove row if any
    
    for k, v in windows 
    {
        ; add icon to imageList - needed for listview column with icon
        IconId := IL_Add(ImageListID, v["processFile"], 1)
        if (A_Index <> IconId){
            MsgBox, % "Err: A_Index - " . A_Index . ", IconNum - " . IconId 
        }
        LV_Add("Icon" . A_Index,v["hotKey"] . ": " . v["processFileName"])
        
        
    }
    OutputDebug, Built window
    if (show){ 
        Gui, toggles:Show, w%w% h%h% x0 y0 
        OutputDebug, and shown it. 
    }
    
}

for k, v in allowedKeysArr{
    ButtonRegister(default_modifier, v)
    ButtonRegister(default_modifier, set_modifier . " & " . v)
    ;S	OutputDebug, ButtonRegister(%default_modifier%, %set_modifier% & %v%)
}

ShowCurrentToggles(isHold, taps, state){
    global w
    global h 
    
    OutputDebug, %isHold%, %taps%, %state%
    if (isHold AND state){
        WinGet, currentActive, ID, A
        OutputDebug, Hold
        Gui, toggles:Show, w%w% h%h% x0 y0 
        WinGet, currentActiveState, MinMax, ahk_id %currentActive%
        if (currentActiveState <> -1)
            WinActivate, ahk_id %currentActive% 
        KeyWait, %default_modifier%
        Return
    }
    if (state<>1){
        OutputDebug, stateOff
        Gui, toggles:Hide 
        KeyWait, %default_modifier%
        Return
    }
    
}

#s::
    FileDelete, %IconsPath%\*.png
    
    for k, v in windows 
    {
        s:=A_TickCount
        res:=v["processFile"]
        icon:=IconsPath . "\" . v["hotKey"] . "_" . v["processFileName"] . ".png" 
        RunWait, C:\Dev\AHK\Protos\tests\icoExtract\Quick_Any2Ico.exe "-res=%res%" "-icon=%icon%" -formats=128 -pngc
        OutputDebug % "time2: " . A_TickCount - s
        OutputDebug, RunWait, C:\Dev\AHK\Protos\tests\icoExtract\Quick_Any2Ico.exe "-res=%res%" "-icon=%icon%" -formats=128 -pngc
        
        
    }
    
Return
#r::Reload

