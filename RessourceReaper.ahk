;========================================================================
;
; RessourceReaper
;
; casts hotkey when sssence is on certain percentage
;
; Created by DaLeberkasPepi
;   https://github.com/DaLeberkasPepi
;
; Last Update: 2018-02-25 15:30 GMT+1
;
;========================================================================

#NoEnv
#IfWinActive, ahk_class D3 Main Window Class
#SingleInstance Force
#MaxThreadsPerHotkey 20
#Persistent

CoordMode, Pixel, Client
CoordMode, ToolTip, Client

;CONFIGURATION AREA ONLY CHANGE VALUES HERE!!!
global Percentage := 92 	;EVERYTHING HIGHER THAN 90 OR LOWER THAN 10 GIVES YOU MIXED RESULTS, BE AWARE
,UseMouse := False			;CHANGE THAT IF YOU WANT TO USE MOUSE BUTTONS INSTEAD OF THE DEFAULT KEYBOARD BUTTONS
,UseHoldKey := False		;IF SET TO "True" THE SCRIPT ONLY RUNS WHEN THE BUTTON FROM "HoldKey" IS PRESSED
,HoldKey := "Space"			;KEY TO USE WHEN "UseHoldKey" IS ENABLED
,KeyboardHotkey := "3" 		;THIS IS THE HOTKEY THE SCRIPT PRESSES TO CAST MAGES
,MouseButton := "Right" 	;THIS ONLY GET USED IF YOU SET Mouse := to True, POSSIBLE VALUES ARE: "Right", "Left", "Middle", "X1" or "X2"
,BaseColor := "0xA0A031"	;BASE COLOR THE ESSENCE COLOR HAS TO BE INBETWEEN THIS COLOR ± VARIANCE TO ACCEPT IT
,ColorVariance := 60		;COLOR VARIANCE ± BASED OF BASECOLOR
,DebugLevel := 0			;DEBUG LEVEL, USE 1 TO WRITE FOUND AND NOT FOUND COLORS TO SEPERATE FILES
;TO CHANGE THE HOTKEY FOR PAUSE GO TO LINE 105, DEFAULT IS "F2"
;END OF CONFIGURATION ARE DONT CHANGE ANYTHING AFTER THAT LINE!!!´

global D3ScreenResolution
,NativeDiabloHeight := 1440
,NativeDiabloWidth := 3440
,Toggle

Loop
{
	While (GetKeyState(HoldKey, "P")) || UseHoldKey == 0
	{
		GetClientWindowInfo("Diablo III", DiabloWidth, DiabloHeight, DiabloX, DiabloY)
			
		If (D3ScreenResolution != DiabloWidth*DiabloHeight)
		{
			;all needed coordinates to use the Kanais Cube, all coordinates are based on a resolution of 3440x1440 and calculated later to the used resolution
			global RessourceTop := [2282, 1238, 1]
			, RessourceBottom := [2282, 1405, 1]
			,PosX
			,PosY
		
			;convert coordinates for the used resolution of Diablo III
			ConvertCoordinates(RessourceTop)
			ConvertCoordinates(RessourceBottom)
			
			PosX := RessourceTop[1]
			PosY := Round(RessourceBottom[2] - (RessourceBottom[2] - RessourceTop[2]) * (Percentage / 100), 0)
		}
		
		IfWinActive, ahk_class D3 Main Window Class
		{
			PixelSearch, , , %PosX%, %PosY%, %PosX%, %PosY%, %BaseColor%, %ColorVariance%
			If !Errorlevel
			{
				If DebugLevel
				{
					PixelGetColor, FoundColor, %PosX%, %PosY%,
					Blue := "0x" SubStr(FoundColor,3,2) ;substr is to get the piece
					Blue := Blue + 0 ;add 0 is to convert it to the current number format
					Green := "0x" SubStr(FoundColor,5,2)
					Green := Green + 0
					Red := "0x" SubStr(FoundColor,7,2)
					Red := Red + 0
					FileAppend, %Blue% %Green% %Red%`n, ColorFound.txt
				}
				
				If UseMouse
					Click, %MouseButton%
				
				else
					Send, %KeyboardHotkey%
			}
			Else 
			{
				If DebugLevel
				{
					PixelGetColor, FoundColor, %PosX%, %PosY%,
					Blue := "0x" SubStr(FoundColor,3,2) ;substr is to get the piece
					Blue := Blue + 0 ;add 0 is to convert it to the current number format
					Green := "0x" SubStr(FoundColor,5,2)
					Green := Green + 0
					Red := "0x" SubStr(FoundColor,7,2)
					Red := Red + 0
					FileAppend, %Blue% %Green% %Red%`n, ColorNotFound.txt
				}
			}
		}
	}
}
Return

~F2::Pause					;HOTKEY TO PAUSE THE SCRIPT AND THEREFORE STOP CASTING MAGES, PRESS AGAIN TO RESUME
Return

~ESC::ExitApp				;HOTKEY TO CLOSE THE SCRIPT COMPLETELY
Return

ConvertCoordinates(ByRef Array)
{
	GetClientWindowInfo("Diablo III", DiabloWidth, DiabloHeight, DiabloX, DiabloY)
	
	D3ScreenResolution := DiabloWidth*DiabloHeight
	
	Position := Array[3]

	;Pixel is always relative to the middle of the Diablo III window
	If (Position == 1)
  	Array[1] := Round(Array[1]*DiabloHeight/NativeDiabloHeight+(DiabloWidth-NativeDiabloWidth*DiabloHeight/NativeDiabloHeight)/2, 0)

	;Pixel is always relative to the left side of the Diablo III window or just relative to the Diablo III windowheight
	If Else (Position == 2 || Position == 4)
		Array[1] := Round(Array[1]*(DiabloHeight/NativeDiabloHeight), 0)

	;Pixel is always relative to the right side of the Diablo III window
	If Else (Position == 3)
		Array[1] := Round(DiabloWidth-(NativeDiabloWidth-Array[1])*DiabloHeight/NativeDiabloHeight, 0)

	Array[2] := Round(Array[2]*(DiabloHeight/NativeDiabloHeight), 0)
}

GetClientWindowInfo(ClientWindow, ByRef ClientWidth, ByRef ClientHeight, ByRef ClientX, ByRef ClientY)
{
	hwnd := WinExist(ClientWindow)
	VarSetCapacity(rc, 16)
	DllCall("GetClientRect", "uint", hwnd, "uint", &rc)
	ClientWidth := NumGet(rc, 8, "int")
	ClientHeight := NumGet(rc, 12, "int")

	WinGetPos, WindowX, WindowY, WindowWidth, WindowHeight, %ClientWindow%
	ClientX := Floor(WindowX + (WindowWidth - ClientWidth) / 2)
	ClientY := Floor(WindowY + (WindowHeight - ClientHeight - (WindowWidth - ClientWidth) / 2))
}