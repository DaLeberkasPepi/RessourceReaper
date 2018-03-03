# RessourceReaper

Casts Keyboard or Mouse Hotkey if Ressource (as of now only Essence) is at least on a certain percentage.

## Configuration Options
|Value|Line Number|Description|
|---|---|---|
Percentage:=90 	       		|24   	|everything higher than 90 or lower than 10 gives you mixed results, be aware!
UseMouse:=False			   	|25   	|change that if you want to use mouse buttons instead of the default keyboard buttons.
UseHoldKey:=False				|26		|if set to "True" the script only runs when the button from "HoldKey" is pressed.
HoldKey:="Space"				|27		|key to use when "UseHoldKey" is enabled.
KeyboardHotkey:="3" 	 		|28 	|this is the keyboard hotkey the script presses to cast mages.
MouseButton:="Right" 	 		|29 	|this is only gets used if you set "UseMouse" to True, possible values are: "Right", "Left", "Middle", "X1" or "X2".
BaseColor:="0xA0A025"	 		|30 	|base color, the essence color has to be inbetween this color ± variance to accept it.
ColorVariance:=60		   		|31		|color variance ± based of BaseColor.
DebugLevel:=0					|32		|debug level, use 1 to write found and not found color to seperate files
~F2::Pause					    |105  	|hotkey to pause the script and therefore stop casting mages, press again to resume.
~ESC::ExitApp					|108	|hotkey to close the script completely.

[![paypal](https://www.paypalobjects.com/en_US/i/btn/btn_donateCC_LG.gif)](https://www.paypal.me/DaLeberkasPepi)
