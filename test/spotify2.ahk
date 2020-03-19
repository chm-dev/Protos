#SingleInstance Force

debugPort := 9922
spotifyExe = Spotify.exe
#Include %A_ScriptDir%\lib\Chrome.ahk
jsFunctions = 
(
var _sctrl = {};
_sctrl.volup = new KeyboardEvent('keydown', {altKey:false,
  bubbles: true,
  cancelBubble: false, 
  cancelable: true,
  charCode: 0,
  composed: true,
  ctrlKey: true,
  keyCode: 38,
  type: "keydown",
  which: 38});
  
_sctrl.voldown = new KeyboardEvent('keydown', {altKey:false,
  bubbles: true,
  cancelBubble: false, 
  cancelable: true,
  charCode: 0,
  composed: true,
  ctrlKey: true,
  keyCode: 40,
  type: "keydown",
  which: 40});
)
jsPlayToggle = $('[data-ta-id="player-button-play"]').click();
jsVolumeUp =   $('#player-volumebar').dispatchEvent(_sctrl.volup);  
jsVolumeDown =   $('#player-volumebar').dispatchEvent(_sctrl.voldown);


SpotInst := {"base": Chrome, "DebugPort": debugPort}



if !(PageInst := SpotInst.GetPage())
{
	MsgBox, Could not retrieve page!
	SpotInst.Kill()

}

PageInst.Evaluate(jsFunctions)
Hotkey, #+=, volUp
Hotkey, #+-, volDown
Hotkey, #Space, playToggle




volUp:
PageInst.Evaluate(jsVolumeUp)
return

volDown:
PageInst.Evaluate(jsVolumeDown)
return

playToggle:
PageInst.Evaluate(jsPlayToggle)V
return
