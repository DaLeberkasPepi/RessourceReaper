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

SendMode Input
SetBatchLines, -1
SetWorkingDir %A_ScriptDir%
CoordMode, Pixel, Client
CoordMode, ToolTip, Client

global D3ScreenResolution
,NativeDiabloHeight := 1440
,NativeDiabloWidth := 3440
,l_OutputColor
,PosX
,PosY

;CONFIGURATION AREA ONLY CHANGE VALUES HERE!!!
global Percentage := 100
,Hotkey := "2"
;END OF CONFIGURATION ARE DONT CHANGE ANYTHING AFTER THAT LINE!!!


Loop
{
	GetClientWindowInfo("Diablo III", DiabloWidth, DiabloHeight, DiabloX, DiabloY)
		
	If (D3ScreenResolution != DiabloWidth*DiabloHeight)
	{
		;all needed coordinates to use the Kanais Cube, all coordinates are based on a resolution of 3440x1440 and calculated later to the used resolution
		global RessourceTop := [2282, 1228, 1]
		, RessourceBottom := [2282, 1415, 1]
		, Ressource
	
		;convert coordinates for the used resolution of Diablo III
		ConvertCoordinates(RessourceTop)
		ConvertCoordinates(RessourceBottom)
		
		PosX := RessourceTop[1]
		PosY := Round(RessourceBottom[2] - (RessourceBottom[2] - RessourceTop[2]) * (Percentage / 100), 0)
	}
	
	IfWinActive, ahk_class D3 Main Window Class
	{
		ColorTest := "0xA0A025"
		PixelSearch, , , %PosX%, %PosY%, %PosX%, %PosY%, %ColorTest%, 65
		If !Errorlevel
		{
			Send, %Hotkey%
			ToolTip, "ColorFound!!!", 300 , 10, 1
		}
		Tooltip, , , ,1
	}
}

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