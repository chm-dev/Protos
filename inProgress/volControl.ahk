;_________________________________________________ 
;_______User Settings_____________________________
DetectHiddenWindows, Off
; Make customisation only in this area or hotkey area only!!

; The percentage by which to raise or lower the volume each time: 
vol_Step = 8

; How long to display the volume level bar graphs: 
vol_DisplayTime = 750

; Master Volume Bar color (see the help file to use more
; precise shades):
vol_CBM=0078d7

; Wave Volume Bar color
vol_CBW=1ed760

; Background color
vol_CW=15232d

; Bar's screen position.  Use -1 to center the bar in that dimension:
vol_PosX  = -1
vol_PosY  = 900
vol_Width = 640  ; width of bar
vol_Thick = 32   ; thickness of bar

global vol_Master
global vol_Wave

winfade(w:="",t:=128,i:=1,d:=10,tc:="") {

w:=(w="")?("ahk_id " WinActive("A")):w
t:=(t>255)?255:(t<0)?0:t
WinGet,s,Transparent,%w%
s:=(s="")?255:s ;prevent trans unset bug

if (tc) {
    WinSet,TransColor, %tc% %s%,%w% 
    OutPutDebug, WinSet,TransColor, %tc% %s%,%w% 
} else {
    WinSet,Transparent,%s%,%w% 
}
i:=(s<t)?abs(i):-1*abs(i)
while(k:=(i<0)?(s>t):(s<t)&&WinExist(w)) {
    WinGet,s,Transparent,%w%
s += i
WinSet,Transparent,%s%,%w%
sleep %d%
}
}

#NoEnv  					; Recommended for performance and compatibility with future AutoHotkey releases.
; Determines whether invisible windows are "seen" by the script.

/**
*  WinFadeTo( WinTitle, [, Duration] )
*   WinTitle
*      A window title identifying the name of the target window.
*   Duration (default 1 second)
*      A number (in seconds) defining how long the animation will take to complete.
*      NOTE: The duration cannot be set to lower than 1 second.
*   Hide (disabled by default)
*      Set the visible state of the target window after fade out.
*      NOTE: Enabled by default if "DetectHiddenWindows" is set to on, otherwise disabled.
    */
WinFadeToggle(WinTitle, Duration := 1, Hide := false) {
; Declarations
LoopCount := 32 * Duration                      ; Calculated number of iterations for loop
    WinGet, WinOpacity, Transparent, %WinTitle%     ; Get transparency level of target window

; Return error if target window does not exist or is not active
If !WinExist(WinTitle) && !WinActive(WinTitle) {
    ErrorMessage := "Target window is not active or does not exist."
}

; Check "DetectHiddenWindows" state
If( A_DetectHiddenWindows = "On" ) {
    Hide := true
}

; Check target window for transparency level
If ( WinOpacity = "" ) {
    WinSet, Transparent, 255, %WinTitle% ; Set transparency of target window
}

; Set the direction of the fade (in/out)
If(WinOpacity = 255 || WinOpacity = "") {
    start := -255
} else {
    start := 0
    WinShow, %WinTitle%
    WinActivate, %WinTitle%     ; Activate target window on fade in
}

; Iterate through each change in opacity level
timer_start := A_TickCount ; Log time of fade start
Loop, % LoopCount {
    opacity := Abs(255/LoopCount * A_Index + start) ; opacity value for the current iteration
    WinSet, Transparent, %opacity%, %WinTitle%      ; Set opacity level for target window
    Sleep, % duration                               ; Pause between each iteration
}
timer_stop := A_TickCount ; Log time of fade completion

; Hide target window after fade-out completes
If(start != 0 && Hide = true) {
    WinHide, %WinTitle%
}

Return ErrorMessage
}

;#Include, Print.ahk

getLevels(){
    global vol_Master
    global vol_Wave
    ;RunWait, %A_ScriptDir%\3rdParty\soundvolumeview.exe /GetPercent Spotify.exe,, UseErrorLevel  
    RunWait, %A_ScriptDir%\3rdParty\soundvolumeview.exe /GetPercent Spotify.exe,, UseErrorLevel  
    vol_Wave:=Round(errorlevel / 10)
    OutputDebug vol_Wave %vol_Wave%
    RunWait, %A_ScriptDir%\3rdParty\soundvolumeview.exe /GetPercent Speakers,, UseErrorLevel
    vol_Master:= (errorlevel // 10)
    OutputDebug vol_Master %vol_Master%
    
}

getLevels()

; If your keyboard has multimedia buttons for Volume, you can
; try changing the below hotkeys to use them by specifying
; Volume_Up, ^Volume_Up, Volume_Down, and ^Volume_Down: 
Hotkey, #Up, vol_MasterUp      ; Win+UpArrow
Hotkey, #Down, vol_MasterDown
Hotkey, +#Up, vol_WaveUp       ; Shift+Win+UpArrow
Hotkey, +#Down, vol_WaveDown

;___________________________________________ 
;_____Auto Execute Section__________________

; DON'T CHANGE ANYTHING HERE (unless you know what you're doing).

vol_BarOptionsMaster=1:B ZH%vol_Thick% ZX0 ZY0 W%vol_Width% CB%vol_CBM% CW%vol_CW%

vol_BarOptionsWave=2:B ZH%vol_Thick% ZX0 ZY0 W%vol_Width% CB%vol_CBW% CW%vol_CW%

; If the X position has been specified, add it to the options.
; Otherwise, omit it to center the bar horizontally: 
if vol_PosX > = 0
{
    vol_BarOptionsMaster = %vol_BarOptionsMaster% X%vol_PosX%
    vol_BarOptionsWave   = %vol_BarOptionsWave% X%vol_PosX%
}

; If the Y position has been specified, add it to the options.
; Otherwise, omit it to have it calculated later: 
if vol_PosY > = 0
{
    vol_BarOptionsMaster  = %vol_BarOptionsMaster% Y%vol_PosY%
    vol_PosY_wave         = %vol_PosY%
    vol_PosY_wave        += %vol_Thick%
    vol_BarOptionsWave    = %vol_BarOptionsWave% Y%vol_PosY_wave%
}

#SingleInstance
SetBatchLines, 10ms
Return

;___________________________________________

vol_WaveUp: 
    ;SoundSet, +%vol_Step%, Wave
    Run, %A_ScriptDir%\3rdParty\soundvolumeview.exe /ChangeVolume Spotify.exe +%vol_Step%
    vol_Wave:=vol_Wave+vol_Step
    OutputDebug %vol_Wave%
    Gosub, vol_ShowBars
return

vol_WaveDown: 
    ;SoundSet, -%vol_Step%, Wave
    Run, %A_ScriptDir%\3rdParty\soundvolumeview.exe /ChangeVolume Spotify.exe -%vol_Step%
    vol_Wave:=vol_Wave-vol_Step
    OutputDebug %vol_Wave%
    Gosub, vol_ShowBars
return

vol_MasterUp: 
    ;SoundSet, +%vol_Step%
    Run, %A_ScriptDir%\3rdParty\soundvolumeview.exe /ChangeVolume Speakers +%vol_Step%
    vol_Master:=vol_Master+vol_Step
    OutputDebug %vol_Master%
    Gosub, vol_ShowBars
return

vol_MasterDown: 
    ;SoundSet, -%vol_Step%
    Run, %A_ScriptDir%\3rdParty\soundvolumeview.exe /ChangeVolume Speakers -%vol_Step%
    vol_Master:=vol_Master-vol_Step
    OutputDebug %vol_Master%
    Gosub, vol_ShowBars
return
PrintScreen:: Reload
vol_ShowBars: 
    ; To prevent the "flashing" effect, only create the bar window if it
    ; doesn't already exist:
    IfWinNotExist, vol_Wave
    {
        Progress, %vol_BarOptionsWave%, , , vol_Wave
        ;WinSet, TransColor, %vol_CW% 100, vol_Wave
        Progress Show, vol_Wave
        ;winfade("vol_Wave", 128, 1,20, vol_CW)
        ;WinFadeToggle("vol_Wave")
    }
    IfWinNotExist, vol_Master
    {
        ; Calculate position here in case screen resolution changes while
        ; the script is running: 
        if vol_PosY < 0
        {
            ; Create the Wave bar just above the Master bar: 
            WinGetPos, , vol_Wave_Posy, , , vol_Wave
            vol_Wave_Posy -= %vol_Thick%
            Progress, %vol_BarOptionsMaster% Y%vol_Wave_Posy%, , , vol_Master
        }
        else
            Progress, %vol_BarOptionsMaster%, , , vol_Master
        
        ;WinSet, TransColor, %vol_CW%, vol_Master
        ;WinFadeToggle("vol_Master")
        ;OutputDebug,  WinSet, TransColor, %vol_CW% 192, vol_Master 
        
    }
    
    
    ; Get both volumes in case the user or an external program changed them: 
    
    ;SoundGet, vol_Master, Master
    ;SoundGet, vol_Wave, Wave
    ;OutputDebug, SoundGet: %vol_Master%, %vol_Wave%
    Progress    , 1: %vol_Master%
    Progress    , 2: %vol_Wave%
    SetTimer, vol_BarOff, %vol_DisplayTime%
return

vol_BarOff: 
    SetTimer, vol_BarOff, Off
    ;    WinFadeToggle("vol_Master")
    ;    WinFadeToggle("vol_Wave")
    Progress, 1: Off
    Progress, 2: Off
    getLevels()
return