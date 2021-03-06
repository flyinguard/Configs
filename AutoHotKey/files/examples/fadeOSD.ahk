;---------- Volume OSD

;------ User Variables ( Feel free to change these )

Gui_X				:= ""
Gui_Y				:= "y50"


Back_Colour			:= 0x000000
Font_Colour			:= 0xFFFFFF
BackBar_Colour		:= 0x000000
Bar_Colour			:= 0x0000FF


VolUp_Key			:= "^!="
VolDown_Key			:= "^!-"
Ammount				:= 1

Timeout				:= 2500

Max_Trans			:= 200


;------- End of user variables


Update 				:= 0

SoundGet, Vol
Curr_Vol			:= Vol

Trans 				:= Max_Trans

Gui, Color, % Back_Colour, 
Gui, Font, c%Font_Colour% s12
Gui, Add, Text, w500 Center, Volume
Gui, Font
Gui, Add, Progress, w500 vProgress c%Bar_Colour% +Background%BackBar_Colour%, % Curr_Vol
Gui, Font, c%Font_Colour% s24
SoundGet, Vol
RegExMatch( Vol, "(?<Percent>\d+)\.", rg )
Gui, Add, Text, w500 Center vVol, % rgPercent
Gui, Show, NoActivate h80 w530 %Gui_X% %Gui_Y%, Vol_OSD

WinSet, Region, w530 h105 R10-10 0-0, Vol_OSD
WinSet, Transparent, %Trans%, Vol_OSD


Gui, -Caption +AlwaysOnTop +ToolWindow +E0x20 +SysMenu
Hotkey, % VolUp_Key, Volume_Up
Hotkey, % VolDown_Key, Volume_Down
SetTimer, Update, 50

SetTimer, Fade, % "-" Timeout

return


Fade:
	While ( Trans > 0 && Update = 0)
	{	Trans -= 2
		WinSet, Transparent, % Trans, Vol_OSD
		Sleep, 5
	}
Return


Update:
	Update				:= 0
	SoundGet, Vol
	If ( Vol <> Curr_Vol )
	{	Update 			:= 1
		GuiControl,, Progress, % Vol
		RegExMatch( Vol, "(?<Percent>\d+)\.", rg )
		GuiControl,, Vol, % rgPercent
		Curr_Vol 		:= Vol
		
		While ( Trans < Max_Trans )
		{	Trans 		+= 10
			WinSet, Transparent, % Trans, Vol_OSD 
			Sleep 1
		}	
		SetTimer, Fade, % "-" Timeout
	}
Return

Volume_Down:
	SoundSet, -%Ammount%, MASTER
return


Volume_Up:
	SoundSet, +%Ammount%, MASTER
Return