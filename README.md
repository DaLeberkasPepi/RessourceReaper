# RessourceReaper

Casts Keyboard or Mouse Hotkey if Ressource (as of now only Essence) is at least on a certain percentage.

## Configuration Options
|Value|Line Number|Description|
|---|---|---|
Percentage := 90 	       |23   |everything higher than 90 or lower than 10 gives you mixed results, be aware!
UseMouse := False			   |24   |change that if you want to use mouse buttons instead of the default keyboard buttons.
KeyboardHotkey := "3" 	 |25   |this is the keyboard hotkey the script presses to cast mages.
MouseButton := "Right" 	 |26   |this is only gets used if you set "UseMouse" to True, possible values are: "Right", "Left", "Middle", "X1" or "X2".
BaseColor := "0xA0A030"	 |27   |base color, the essence color has to be inbetween this color ± variance to accept it.
ColorVariance := 60		   |28   |color variance ± based of BaseColor.
~F2::Pause					     |71   |hotkey to pause the script and therefore stop casting mages, press again to resume.
