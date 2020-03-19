global wintitle="Data Properties"
global OKButton="WindowsForms10.BUTTON.app.0.3392d59_r9_ad14"
SetControlDelay -1
SetTitleMatchMode, RegEx


setInitialValue(){
ControlGetText, text, WindowsForms10.EDIT.app.0.3392d59_r9_ad14, %wintitle%
Sleep 100
ControlSetText, WindowsForms10.EDIT.app.0.3392d59_r9_ad13, %text%, %wintitle%
Sleep 300       
ControlClick, %OKButton%, %wintitle%,,L,2,NA
Return
}


cleanInititalValue(){
ControlSetText, WindowsForms10.EDIT.app.0.3392d59_r9_ad13,, %wintitle%
Sleep 300
ControlClick, %OKButton%, %wintitle%,,L,2,NA
}

helpMsgBox(){
 MsgBox, In BluePrism, hold alt or ctrl and double click with right button on any data item.`nIf alt is held current value will be copied to initial value.`nIf ctrl is held initial value will be cleared`n`nSecond method works with manually opened data item window.`nAlt + right mouse click(anywhere in data item window) = copy current value to initial value`nAlt+middle mouse click = clear initital value.  
}
Menu, Tray, Add
Menu, Tray, Add,  How to use, helpMsgBox
NumpadClear::Reload





#If WinActive(wintitle)
global wintitle
!RButton::setInitialValue()
^RButton::cleanInititalValue()
+\::MsgBox, test ok
#If

#If WinActive("Studio")
!RButton::
^RButton::
If (A_PriorHotKey = A_ThisHotKey and A_TimeSincePriorHotkey < 500) {
Send {Click}
Sleep 100
Send {Click}
WinWait, %wintitle%,,1
if (A_ThisHotkey = "!RButton")
    setInitialValue() 
else
    cleanInititalValue()

}


Return
#If