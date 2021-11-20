; ######################### AutoUpdate & Initiation #########################
	FolderPath = %A_AppData%\Nichio
	SetWorkingDir, %FolderPath%
	;PATH_SAMP_API := PathCombine(A_WorkingDir, "Open-SAMP-API.dll")
	global DirPath := FolderPath
	global SettingsPath := FolderPath "\settings.ini"
	global SAMP_API_PATH := FolderPath "\Open-SAMP-API.dll"
	
	FileCreateDir, %FolderPath%
	
	;_getCMDbyString("Tippe /Gangwaffen zum ausrüsten")

	; Nichio Ordner wird unter %Appdata% erstellt, wenn nicht da ist keine settings.ini, und autoupdate broke
	If !FileExist(FolderPath) {
		FileCreateDir, %dir%
		If ErrorLevel
		MsgBox, 48, Error, An error ocncurred when creating the directory.`n`n%dir%
		Else MsgBox, 64, Success, Nichio Ordner wurde erstellt.`n`n%dir%
	}
	
	; wenn Open-SAMP-API.dll nicht da ist, downloade sie
	if !FileExist(SAMP_API_PATH) {
		api_url = http://nichio.de/dl/Open-SAMP-API.dll
		api_name = %SAMP_API_PATH%
		;_download_to_file(api_url, api_name) // not used anymore
	}
	
	I_Icon = %FolderPath%\icon.ico
	;if !FileExist(I_Icon) {
		icon_url = http://nichio.de/dl/icon.ico
		icon_name = %I_Icon%
		_download_to_file(icon_url, icon_name)
	;}
	Menu, Tray, Icon, %I_Icon%
	
	#include JSON.ahk
	#include DAPE-API.ahk
	
; ######################### IniRead: InGame #########################
	IniRead, PLAYER_USERNAME, %SettingsPath%, InGame, Username
	IniRead, MESSAGE_KILLSPRUCH, %SettingsPath%, InGame, Killspruch
	IniRead, wdealerpakete, %SettingsPath%, InGame, Waffendealerpakete
	IniRead, DeteCooldown, %SettingsPath%, InGame, DetektivCooldown
	
; ######################### IniRead: Visuals #########################
	global KEYBINDER_TEXTCOLOR := "{FFFFFF}"
	global KEYBINDER_SHORTNAME := "NichioBinder"
	global KEYBINDER_HIGHLIGHT := "{FF0000}"
	global KEYBINDER_PREFCOLOR := "{FFD700}"
	
	global cBlue = "{0077be}"
	global cRed = "{D34234}"
	global cGreen = "{00b200}"
	global cGray = "{D3D3D3}"
	global cBlack = "{202020}"
	global cDarkGray = "{2D2D2D}"
	global cWhite = "{FFFFFF}"
	global cYellow = "{FFD700}"
	global cOrange = "{FFA500}"
	global cLime = "{00FF00}"
	
; #######

	global fraktionen := []
	fraktionen[3] := Object("NAME", "Aztecas", "SKINS", [114, 115, 116, 156, 173, 174,175, 176, 177], "COLOR", 0x00FFCC, "COLOR2", "{00FFCC}", "GANGZONE",0x90FFEE00)
	fraktionen[1] := Object("NAME", "Grove Street", "SKINS", [65, 86, 105, 106, 107,149, 269, 270, 271], "COLOR", 0x008000, "COLOR2", "{008000}", "GANGZONE",0x9028EA00)
	fraktionen[4] := Object("NAME", "Yakuza", "SKINS", [122, 123, 169, 186,203, 204, 228], "COLOR", 0xCC9900, "COLOR2", "{CC9900}", "GANGZONE",0x90A0A0A0)
	fraktionen[7] := Object("NAME", "Triaden", "SKINS", [111, 117, 118, 120, 208, 210,224, 294], "COLOR", 0xE13759, "COLOR2", "{E13759}", "GANGZONE", 0x90FF2D00)
	fraktionen[6] := Object("NAME", "Vagos", "SKINS", [108, 109, 110, 292,298], "COLOR", 0xFFFF00, "COLOR2", "{FFFF00}", "GANGZONE", 0x9000FFFF)

	fraktionen[2] := Object("NAME", "Ballas", "SKINS", [13, 102, 103, 104,195, 293], "COLOR", 0xCC66FF, "COLOR2", "{CC66FF}", "GANGZONE", 0x90B10489)
	fraktionen[5] := Object("NAME", "LCN", "SKINS", [98, 113, 124, 125, 126, 127, 263, 272], "COLOR", 0xBEB9C8, "COLOR2", "{BEB9C8}", "GANGZONE",0x80000066)
	fraktionen[8] := Object("NAME", "CK", "SKINS", [46, 184, 185, 223, 273],"COLOR", 0xD88585, "COLOR2", "{D88585}", "GANGZONE", 0x900059AE) 
	fraktionen[9] := Object("NAME", "LSPD", "SKINS", [265, 266, 267, 280, 281, 282, 283, 284, 285, 286, 288, 300, 301, 302, 306, 307, 309, 310, 311], "COLOR", 0x6495ED, "COLOR2", "{6495ED}") 
	fraktionen[10] := Object("NAME", "NineDemons", "SKINS", [247, 248, 100, 261, 291, 158, 162, 199, 200, 201, 146], "COLOR", 0x4E9C00, "COLOR2", "{4E9C00}")

; ######################### Version Settings #########################
	global KEYBINDER_VERSION := "3.5.4"
	global KEYBINDER_GENERATION := ""
	global KEYBINDER_CLIENTNAME := "Nichio Keybinder"
	global KEYBINDER_CLIENTVERSION = KEYBINDER_GENERATION KEYBINDER_VERSION
	IniWrite, %KEYBINDER_VERSION%, %SettingsPath%, Keybinder, Version
	
; ######################### Auto Updater #########################
	CheckForUpdate()
	
; ######################### Prefix & Colors #########################
	global KEYBINDER_PREFIX := cGray "["  cOrange "Nichio" cGray "]  " cWhite
	global KEYBINDER_CHAT = cOrange
	global KEYBINDER_PREFIXERROR = cGray "["  cOrange "Nichio" cGray "]  " cGray "[" cRed "FEHLER" cGray "]: " cWhite
	global KEYBINDER_PREFIXGREEN = cGray "["  cOrange "Nichio" cGray "]  " cGreen
	global KEYBINDER_PREFIXRED = cGray "["  cOrange "Nichio" cGray "]  " cRed
	
; ######################### State #########################	
	global KEYBINDER_STATE := 1
	global KEKSBOT_STATE := 0
	global LOGGED_IN := 0
	global togglehp := 1
	global Detektiv := 0
	global Locing := 0
	global HANDY_STATE := 1
	global Laufscript := 0
	
	global veris := 0
	global WCoding := false
	global autolotto := 1
	global autohelp := true
	global AutoAnwalt := false
	global autopickup := true
	global cmdDialog := ""
	
	Time := A_NowUTC
	EnvSub, Time, 19700101000000, Seconds	; bro kp was hier passiert akzeptier es einfach für unix timestamp lol					
	global CHAT_TIMESTAMP := Time
	
	global sync_timer = 0
	
; ######################### Keybinder levels #########################	
	global KEYBINDER_ONLINE = 1
	global KEYBINDER_OFFLINE = 0
	
; ########################## TIMER ##########################
	SetTimer, KeksBot, 500
	
	SetTimer, ChatListener, 250
	SetTimer, ChatResponder, 50
	SetTimer, DialogListener, 50
	SetTimer, PositionListener, 250
	SetTimer, BotLogic, 1000
	
	SetTimer, HPUpdater, 300
	
	SetTimer, Maintenance, 1000
	
	current_gui = 1
	AddChatMessage(KEYBINDER_PREFIXGREEN KEYBINDER_CLIENTNAME " wurde gestartet.")
; ########################## GUI 1 ##########################
	; Titel & GUI
		Gui, 1: Show, h500 w800, %KEYBINDER_CLIENTNAME% | Version: %KEYBINDER_CLIENTVERSION% 
		Gui, 1: Color, 202020
		
	; Custom Title Bar
	
		;Gui, 1: -Caption +Border
		
		;Gui, 1: font, c00FF00
		;Gui, 1: font, s8 bold, Futura-Book  
		
		;Gui, 1: Add, Text, -theme x0 y0 w780 h25 0x4 gGuiMove
		;Gui, 1: add, Button, -theme x775 y0 cRed w25 h25 gGuiClose, X		

	; Font 1
		Gui, 1: font, c00FF00
		Gui, 1: font, s18 bold, Futura-Book  
	
	; Buttons & Texte
		Gui, 1: Add, Text, x50 y30,  %KEYBINDER_CLIENTNAME%                         
		Gui, 1: Add, Text, x50 y70, Version: %KEYBINDER_CLIENTVERSION%       
		Gui, 1: Add, Text, x50 y110 vSTATE w200, KeyBinder: AN                   
		
		Gui, 1: font, s14 bold, Futura-Book 
		Gui, 1: Add, Button, -theme x50 y150 gSettingsClick h30 w200, Settings
		Gui, 1: font, s18 bold cWhite, Futura-Book 
		
	; Edit Boxen
		
		
	; Save Button
		;Gui, 1: font, s14 bold cBlack, Futura-Book 
		;Gui, 1: Add, Button, -theme x680 y270 w90 h30 gGSave, Save
		;Gui, 1: Add, Button, -theme x680 y370 w90 h30 gGSave, Save
	
	; HP & Rüstung Progress Bar
		Gui, 1: font, s18 bold cBlack, Futura-Book 
		
		Gui, 1: Add, Text, w200 x50 y240 vHealthText cRed, Health:
		Gui, 1: Add, Progress, w700 h20 x50 y280 vHealthBar cRed , 50
		
		Gui, 1: Add, Text, w200 x50 y350 vArmorText c00C9FF, Armor:
		Gui, 1: Add, Progress, w700 h20 x50 y390 vArmorBar c89cff0 , 50
		
	; Font 2
		Gui, 1: font, cFFA500
		Gui, 1: font, s18 bold, Futura-Book  

	; StatusBar
		Gui, 1: font, s12 bold, Futura-Book 
		Gui, 1: Add, StatusBar, x0 y0, made by kensho.nichio
		
	; Login Field
		IniRead, kb_email, %SettingsPath%, KeyBinder, Email
		IniRead, kb_pass, %SettingsPath%, KeyBinder, Password
		
		if (kb_email == "ERROR") {
			kb_email := ""
		}
		if (kb_pass == "ERROR") {
			kb_pass := ""
		}
		
		; Email
		Gui, 1: font, s18 bold cWhite, Futura-Book 
		Gui, 1: add, Text, x320 y30, Email: 
		Gui, 1: font, cBlack s14
		Gui, 1: add, Edit, x450 y30 w300 h30 vEmailField, %kb_email%
		Gui, 1: font, cWhite
		
		; Password
		Gui, 1: font, s18 bold cWhite, Futura-Book 
		Gui, 1: add, Text, x320 y90, Password: 
		Gui, 1: font, cWhite s14
		Gui, 1: add, Edit, x450 y90 w300 h30 vPasswordField, %kb_pass%
		Gui, 1: font, cWhite s18
		
		; Login Button
		Gui, 1: font, s14
		Gui, 1: add, Button, -theme x320 y150 w120 h32 gLogin, Login
		Gui, 1: Add, Text, x450 y154 w320 h100 vLoginMsg, Waiting...
		
		; ################ Try Auto Login if something is saved in ini file
		if (kb_pass != "ERROR" && kb_email != "ERROR") {
			if (kb_pass != "" && kb_email != "") {
				_login()
			}
		}
		
; ########################## GUI 2 ##########################
		
	; Gui 2
		Gui, 2: Show, h600 w700, %KEYBINDER_CLIENTNAME% | Settings
		Gui, 2: Hide
		Gui, 2: Color, 212121
		
	; Font 1
		Gui, 2: font, cWhite
		Gui, 2: font, s14 bold, Futura-Book 
		
	; Save Button
		Gui, 2: add, Button, x250 y500 w200 h30 gSSave, Change Settings
		
	; Settings Links
		Gui, 2: add, Text, x30 y40, Waffenpakete: 
		Gui, 2: font, cBlack
		IniRead, w_p, %SettingsPath%, InGame, Waffendealerpakete
		Gui, 2: add, Text, x30 y70 w290 h30 v1, %w_p%
		Gui, 2: font, cWhite
		
		Gui, 2: add, Text, x30 y120, Kills: 
		Gui, 2: font, cBlack
		IniRead, w_p, %SettingsPath%, InGame, Kills
		Gui, 2: add, Text, x30 y150 w290 h30 v2, %w_p%
		;Gui, 2: add, Text, vKillsUpDown Range1-9999, %w_p%
		Gui, 2: font, cWhite
		
		Gui, 2: add, Text, x30 y200, Pickspruch: 
		Gui, 2: font, cBlack
		IniRead, w_p, %SettingsPath%, InGame, Pickspruch
		Gui, 2: add, Text, x30 y230 w290 h30 v3, %w_p%
		Gui, 2: font, cWhite
		
		Gui, 2: Add, text, x30 y280, Killspruch:
		Gui, 2: font, s14 bold cBlack, Futura-Book 
		IniRead, k_s, %SettingsPath%, InGame, Killspruch
		Gui, 2: Add, Text, x30 y310 h30 w300 vKillSpruch , %k_s%
		Gui, 2: font, s14 bold cWhite, Futura-Book 
		
		Gui, 2: Add, text, x30 y360, AntiCheat-Compatibility:
		Gui, 2: Add, Button, -theme x30 y400 gToggleAC vToggleAC h30 w300, ACC: Off
		
	; Settings Rechts
		Gui, 2: add, Text, x390 y40, Drogenpakete: 
		Gui, 2: font, cBlack
		IniRead, w_p, %SettingsPath%, InGame, Drogendealerpakete
		Gui, 2: add, Text, x390 y60 w290 h30 v4, %w_p%
		Gui, 2: font, cWhite
		
		Gui, 2: add, Text, x390 y120, /Ja - Spruch: 
		Gui, 2: font, cBlack
		IniRead, w_p, %SettingsPath%, InGame, JaSpruch
		
		Gui, 2: add, Text, x390 y150 w290 h30 v5 vJaspruch, %w_p%
		;Gui, 1: add, Text, x390 y250 w290 h30 v5 vJaspruch, %w_p%
		
		Gui, 2: font, cWhite
		
		Gui, 2: add, Text, x390 y200, /auf - Spruch: 
		Gui, 2: font, cBlack
		IniRead, w_p, %SettingsPath%, InGame, NeinSpruch
		Gui, 2: add, Text, x390 y230 w290 h30 v6, %w_p%
		Gui, 2: font, cWhite
		
		Gui, 2: Add, text, x390 y280, Gang-Killspruch:
		Gui, 2: font, s14 bold cBlack, Futura-Book 
		IniRead, g_s, %SettingsPath%, InGame, Gangspruch
		Gui, 2: Add, Text, x390 y310 h30 w300 vGangSpruch, %g_s%
		Gui, 2: font, s18 bold cWhite, Futura-Book 
	
	return
; ######################### Gui: Functions #########################
		GuiClose:
			AddChatMessage(KEYBINDER_PREFIXRED KEYBINDER_CLIENTNAME " wurde geschlossen.")
			ExitApp
		return
		
		Login:
			_login()
		return
		
		SSave:
			
			Run, https://nichio.de/dashboard.php
			return
			
			GuiControlGet, 1
			GuiControlGet, 2
			GuiControlGet, 3
			GuiControlGet, 4
			GuiControlGet, 5
			GuiControlGet, 6
			GuiControlGet, KillSpruch
			GuiControlGet, GangSpruch
			
			IniWrite, %1%, %SettingsPath%, InGame, Waffendealerpakete
			IniWrite, %2%, %SettingsPath%, InGame, Kills
			IniWrite, %3%, %SettingsPath%, InGame, Pickspruch
			IniWrite, %4%, %SettingsPath%, InGame, Drogendealerpakete
			IniWrite, %5%, %SettingsPath%, InGame, JaSpruch
			IniWrite, %6%, %SettingsPath%, InGame, NeinSpruch
			IniWrite, %KillSpruch%, %SettingsPath%, InGame, Killspruch
			IniWrite, %GangSpruch%, %SettingsPath%, InGame, Gangspruch
			
			GuiControl ,, 1, %1%
			GuiControl ,, 2, %2%
			GuiControl ,, 3, %3%
			GuiControl ,, 4, %4%
			GuiControl ,, 5, %5%
			GuiControl ,, 6, %6%
			GuiControl ,, KillSpruch, %KillSpruch%
			GuiControl ,, GangSpruch, %GangSpruch%
		return
		
		ToggleAC:
			if (AC_COMPATIBILITY == 0) {
				GuiControl ,, ToggleAC, ACC: An
				AC_COMPATIBILITY = 1
			} else {
				GuiControl ,, ToggleAC, ACC: Aus
				AC_COMPATIBILITY = 0
			}
		return
		
		SettingsClick: 
		
			_sync()
			
			Run, https://nichio.de
			return
			; TODO: Irgendwie GUI 2 zeigen und die settings updaten
			; aber wieso auch immer funktioniert das auch nicht
			
			Gui, 2: Show
			
			IniRead, c_wdp, %SettingsPATH%, InGame, Waffendealerpakete
			IniRead, c_k, %SettingsPATH%, InGame, Kills
			IniRead, c_ps, %SettingsPATH%, InGame, Pickspruch
			IniRead, c_ddp, %SettingsPATH%, InGame, Drogendealerpakete
			IniRead, c_js, %SettingsPATH%, InGame, JaSpruch
			IniRead, c_ns, %SettingsPATH%, InGame, NeinSpruch
			IniRead, c_ks, %SettingsPATH%, InGame, Killspruch
			IniRead, c_gs, %SettingsPATH%, InGame, Gangspruch
			
			GuiControl ,, 1, %c_wdp%
			GuiControl ,, 2, %c_k%
			GuiControl ,, 3, %c_ps%
			GuiControl ,, 4, %c_ddp%
			GuiControl ,, 5, %c_js%
			GuiControl ,, 6, %c_ns%
			GuiControl ,, KillSpruch, %c_ks%
			GuiControl ,, GangSpruch, %c_gs%
			
		
		return
		
; ########################## AUTO-FUNCTIONS ##########################
	
; ######################### HP Updater #########################	
	oldhp := GetPlayerHealth()
	oldarmor := GetPlayerArmor()
	oldhealth := GetPlayerHealth() + GetPlayerArmor()
	yup = 0

	skips_wcodes = 0
	skips_detektiv = 0
	skips_anwalt = 0
	
	previous_first_chatline := ""
	
	BotLogic:
	if (KEYBINDER_STATE == 1) {
		
		tickrate = 2 ; 4 mal die sekunde wird der timer abgerufen
		;GetChatLine(0, line)
		;msg(line)
		
		if (WCoding == 1) {
			if (skips_wcodes <= 0) {
				SendChat("/wcodes")
				skips_wcodes = 20 * 60 * tickrate
			}
			skips_wcodes--
		}
		
		if (Detektiv != 0) {
			if (skips_detektiv <= 0) {
				if (Detektiv == 1) {
					IniRead, target, %SettingsPath%, InGame, Target
					SendChat("/dfinden " target)
					Sleep, 10000
					skips_detektiv = 10 * tickrate ; 10 sekunden warten, bzw. 10 * tickrate durchläufe des timers
				} else if (Detektiv == 2) {
					IniRead, target, %SettingsPath%, InGame, Target
					IniRead, helper, %SettingsPath%, InGame, Helfer
					SendChat("/dzeigen " helper " " target)
					skips_detektiv = 10 * tickrate
				}
			}
			skips_detektiv--
		}
		
		if (AutoAnwalt == 1) {
			if (skips_anwalt <= 0) {
				SendChat("/gefangene")
				sleep, 250
				
				GetChatLine(0, line0)
				GetChatLine(1, line1)
				GetChatLine(2, line2)
				GetChatLine(3, line3)
				
				_anwalt(line0)
				_anwalt(line1)
				_anwalt(line2)
				_anwalt(line3)
				
				;Random, randAnwalt, 3, 7
				;skips_anwalt := randAnwalt * tickrate
				skips_anwalt := 0.5 * tickrate
			}
			skips_anwalt--
		}
		
		if (Locing == 1) {
			;GetCityName(p_city, 500)
			;GetZoneName(p_zone, 500)
			;location_string = %p_zone%
			;ShowGameText(location_string, 1000, 1)
		}
		
	}
	return
	
	DialogListener:
	if (isKeybinderAvailable()) {
		if (cmdDialog != "") {
			
			if (cmdDialog == "/befehle") {
				dialogText := ""
				dialogText := dialogText cBlue "Befehle" "`n"
				dialogText := dialogText cLime "/ja" cWhite " - /ja Spruch" "`n"
				dialogText := dialogText cLime "/auf" cWhite " - /auf Spruch" "`n"
				dialogText := dialogText cLime "/nein" cWhite " - 15 Sekunden Mailbox" "`n"
				dialogText := dialogText cLime "/vkwt" cWhite " - Verkaufe Waffenteile für Maxpreis" "`n"
				dialogText := dialogText cLime "/vkks" cWhite " - Verkaufe Kekse für Maxpreis" "`n"
				dialogText := dialogText cLime "/rlotto" cWhite " - Zufällige Lottozahl kaufen" "`n"
				dialogText := dialogText " " "`n"
				dialogText := dialogText cBlue "Kurze Befehle" "`n"
				dialogText := dialogText cLime "/inv" cWhite " - kurz: /inventar" "`n"
				dialogText := dialogText cLime "/fin" cWhite " - kurz: /finanzen" "`n"
				dialogText := dialogText cLime "/wl" cWhite " - kurz: /waffenlager" "`n"
				dialogText := dialogText cLime "/sb" cWhite " - kurz: /safebox" "`n"
				dialogText := dialogText cLime "/fsb" cWhite " - kurz: /fsafebox" "`n"
				dialogText := dialogText " " "`n"
				dialogText := dialogText cBlue "Bots" "`n"
				dialogText := dialogText cLime "/t" cWhite " - Bot: Detektiv ->  Target <t> setzen" "`n"
				dialogText := dialogText cLime "/h" cWhite " - Bot: Detektiv ->  Helfer <h> setzen" "`n"
				dialogText := dialogText cLime "/find" cWhite " - Bot: Detektiv -> /dfinden <t>" "`n"
				dialogText := dialogText cLime "/show" cWhite " - Bot: Detektiv ->  /dzeigen <h> <t>" "`n"
				dialogText := dialogText cLime "/autowc" cWhite " - Bot: Wantedhacker -> /wcodes" "`n"
				dialogText := dialogText cLime "/autohp" cWhite " - Bot: HP Updater im Chat" "`n"
				dialogText := dialogText cLime "/autolotto" cWhite " - Bot: Automatisches /rlotto" "`n"
				dialogText := dialogText cLime "/autopickup" cWhite " - Bot: Automatisches /pickwaffe" "`n"
				dialogText := dialogText cLime "/autohelp" cWhite " - Bot: Automatisch Checkpoint setzen wenn jemand Hilfe braucht" "`n"
				dialogText := dialogText cLime "/laufen" cWhite " - Bot: Automatisch Laufscript" "`n"
				dialogText := dialogText " " "`n"
				dialogText := dialogText cBlue "Scripts" "`n"
				dialogText := dialogText cLime "/m4" cWhite " - script: /wl -> M4 Kaufen" "`n"
				dialogText := dialogText cLime "/sniper" cWhite " - script: /wl -> Sniper Kaufen" "`n"
				dialogText := dialogText cLime "/shotgun" cWhite " - script: /wl -> Shotgun Kaufen" "`n"
				dialogText := dialogText " " "`n"
				dialogText := dialogText cBlue "Nichio Client" "`n"
				dialogText := dialogText cLime "/nc" cWhite " - Nichio Client: Internet Relay Chat" "`n"
				dialogText := dialogText cLime "/online" cWhite " - Nichio Client: List Online Users" "`n"
				dialogText := dialogText cLime "/togglecp" cWhite " - Checkpoint anzeigen an/aus (Nichio Helping Location)" "`n"
				dialogText := dialogText " " "`n"
				dialogText := dialogText cBlue "Debugging" "`n"
				dialogText := dialogText cLime "/location" cWhite " - Debug: Location Shower" "`n"
				dialogText := dialogText cLime "/gebiete" cWhite " - Debug: Gebiete auslesen" "`n"
				dialogText := dialogText cLime "/skinid" cWhite " - Debug: SkinID auslesen" "`n"
				dialogText := dialogText cLime "/savepos" cWhite " - speichere coords in savedpositions.ini" "`n"
				dialogText := dialogText cLime "/vorschlag <text>" cWhite " - Schicke mir einen Vorschlag für den Keybinder" "`n"
				dialogText := dialogText cLime "/vorschlagliste" cWhite " - Unfertige Vorschläge auslesen" "`n"
				
				showDialog(4, cRed "Nichio Keybinder Befehle", dialogText, "Done")
				
			} else if (cmdDialog == "/hotkeys") {
				;AddChatMessage(cRed "==============" cBlue " KeyBinder Hotkeys " cRed "==============" )
				;AddChatMessage(cRed "F2: " cBlue "/carkey" cGray " | | " cRed "F3: " cBlue "/carlock" cGray " | | " cRed "F4: " cBlue "/motor" )
				;AddChatmessage(cRed ".: " cBlue "/nimmspice" cGray " | | " cRed ",: " cBlue "/nimmdrogen" cGray " | | " cRed "F12: " cBlue "Keybinder An/Aus")
				;AddChatMessage(cRed "X: " cBlue "Handy An/Aus" cGray " | | " cRed "Y: " cBlue "Multifunktionstaste" cGray " | | " cRed "+: " cBlue "Config auslesen" )
				;AddChatMessage(cRed "STRG K: " cBlue "KeksBot" cGray " | | " cRed "^: " cBlue "/pickwaffe" cGray " | | " cRed "Shift: " cBlue "Laufscript" )
				;AddChatMessage(cRed "STRG R: " cBlue "/frespawn" cGray " | | " cRed "C: " cBlue "Print Fraktions Users" cGray " | | " cRed "-: " cBlue "-" )
				;AddChatMessage(cRed "==========================================" )
				
				dialogText := ""
				dialogText := dialogText cBlue "Basics" "`n"
				dialogText := dialogText cLime "F2" cWhite " - /carkeys" "`n"
				dialogText := dialogText cLime "F3" cWhite " - /carlock" "`n"
				dialogText := dialogText cLime "F4" cWhite " - /motor" "`n"
				dialogText := dialogText cLime "F12" cWhite " - Keybinder An/Aus" "`n"
				dialogText := dialogText " " "`n"
				dialogText := dialogText cBlue "Advanced" "`n"
				dialogText := dialogText cLime "." cWhite " - /nimmspice" "`n"
				dialogText := dialogText cLime "," cWhite " - /nimmdrogen" "`n"
				dialogText := dialogText cLime "X" cWhite " - /handystatus <an/aus>" "`n"
				dialogText := dialogText cLime "Y" cWhite " - Multifunktionstaste" "`n"
				dialogText := dialogText cLime "+" cWhite " - Keybinder Config" "`n"
				dialogText := dialogText cLime "#" cWhite " - Keybinder Guide" "`n"
				dialogText := dialogText cLime "^" cWhite " - Nichio Helping (Location)" "`n"
				dialogText := dialogText cLime "C" cWhite " - Fraktions-Spieler in der Naehe" "`n"
				dialogText := dialogText cLime "STRG C" cWhite " - Spieler in der Naehe" "`n"
				dialogText := dialogText cLime "STRG R" cWhite " - /frespawn" "`n"
				dialogText := dialogText cLime "STRG K" cWhite " - KeksBot" "`n"
				dialogText := dialogText cLime "Shift" cWhite " - Laufscript" "`n"

				
				showDialog(4, cRed "Nichio Keybinder Hotkeys", dialogText, "Done")
				
			} else if (cmdDialog == "/changelogs") {
				dialogText := ""
				dialogText := dialogText cBlue "Versionen" "`n"
				dialogText := dialogText cLime "1.0.0" "`n"
				dialogText := dialogText cLime "2.0.0" "`n"
				dialogText := dialogText cLime "3.0.0" "`n"
				dialogText := dialogText cLime "3.1.0" "`n"
				dialogText := dialogText cLime "3.4.6" "`n"
				dialogText := dialogText cLime "3.4.7" "`n"
				dialogText := dialogText cLime "3.4.8" "`n"
				dialogText := dialogText cLime "3.5.0" "`n"
				dialogText := dialogText cLime "3.5.1" "`n"
				
				showDialog(4, cRed "Nichio Keybinder Changelogs", dialogText, "Done")
				
			} else if (getFirstWord(cmdDialog) == "/changelog") {
				v := getSecondWord(cmdDialog)
				;msg(v)
				dialogText := ""
				
				if (v == "template") {
					dialogText := dialogText cGreen "New" "`n"
					dialogText := dialogText cLime "XXX" cWhite " - XXXXXXXXXXXX" "`n"
					dialogText := dialogText " " "`n"
					dialogText := dialogText cOrange "Changed" "`n"
					dialogText := dialogText cLime "XXX" cWhite " - XXXXXXXXXXXX" "`n"
					dialogText := dialogText " " "`n"
					dialogText := dialogText cRed "Removed" "`n"
					dialogText := dialogText cLime "XXX" cWhite " - XXXXXXXXXXXX" "`n"
					dialogText := dialogText " " "`n"
					dialogText := dialogText cBlue "Bug Fixes" "`n"
					dialogText := dialogText cLime "XXX" cWhite " - XXXXXXXXXXXX" "`n"
					dialogText := dialogText " " "`n"
					dialogText := dialogText cGray "Date: XX.YY.ZZZZ" "`n"
				}
				
				if (v == "3.5.4") {
					dialogText := dialogText cGreen "New" "`n"
					dialogText := dialogText cLime "-" cWhite " - -" "`n"
					dialogText := dialogText " " "`n"
					dialogText := dialogText cOrange "Changed" "`n"
					dialogText := dialogText cLime "-" cWhite " - -" "`n"
					dialogText := dialogText " " "`n"
					dialogText := dialogText cRed "Removed" "`n"
					dialogText := dialogText cLime "-" cWhite " - -" "`n"
					dialogText := dialogText " " "`n"
					dialogText := dialogText cBlue "Bug Fixes" "`n"
					dialogText := dialogText cLime "/autopickup" cWhite " - Maßnahmen gegen Command-Spam kick" "`n"
					dialogText := dialogText " " "`n"
					dialogText := dialogText cGray "Date: 15.11.2021" "`n"
				}
				
				if (v == "3.5.3") {
					dialogText := dialogText cGreen "New" "`n"
					dialogText := dialogText cLime "^::" cWhite " - Nichio Intern Help (Location)" "`n"
					dialogText := dialogText cLime "/togglecp:" cWhite " - Checkpoint anzeigen an/aus" "`n"
					dialogText := dialogText cLime "/autohelp:" cWhite " - Automatisch Checkpoint setzen wenn jemand Hilfe braucht" "`n" 
					dialogText := dialogText " " "`n"
					dialogText := dialogText cOrange "Changed" "`n"
					dialogText := dialogText cLime "XXX" cWhite " - XXXXXXXXXXXX" "`n"
					dialogText := dialogText " " "`n"
					dialogText := dialogText cRed "Removed" "`n"
					dialogText := dialogText cLime "XXX" cWhite " - XXXXXXXXXXXX" "`n"
					dialogText := dialogText " " "`n"
					dialogText := dialogText cBlue "Bug Fixes" "`n"
					dialogText := dialogText cLime "Y::" cWhite " - Tanke an der SH ging nicht" "`n"
					dialogText := dialogText cLime "/nc:" cWhite " - Maßnahmen gegen '/' da es zu Fehlern geführt hat." "`n"
					dialogText := dialogText cLime "/vorschlag:" cWhite " - Maßnahmen gegen '/' da es zu Fehlern geführt hat." "`n"
					dialogText := dialogText " " "`n"
					dialogText := dialogText cGray "Date: 14.11.2021" "`n"
				}
				
				if (v == "3.5.2") {
					dialogText := dialogText cGreen "New" "`n"
					dialogText := dialogText cLime "/vorschlag <text>" cWhite " - Schicke mir einen Vorschlag für den Keybinder" "`n"
					dialogText := dialogText cLime "/vorschlagliste" cWhite " - Unfertige Vorschläge auslesen" "`n"
					dialogText := dialogText " " "`n"
					dialogText := dialogText cOrange "Changed" "`n"
					dialogText := dialogText cLime "/changelog <version>" cWhite " - Changelogs haben ab jetzt ein Datum" "`n"
					dialogText := dialogText " " "`n"
					dialogText := dialogText cRed "Removed" "`n"
					dialogText := dialogText cLime "-" cWhite " - -" "`n"
					dialogText := dialogText " " "`n"
					dialogText := dialogText cBlue "Bug Fixes" "`n"
					dialogText := dialogText cLime "/online" cWhite " - ID wurde falsch angezeigt bei sich selbst" "`n"
					dialogText := dialogText " " "`n"
					dialogText := dialogText cGray "Date: 13.11.2021" "`n"
				}
				
				
				if (v == "3.5.1") {
					dialogText := dialogText cGreen "New" "`n"
					dialogText := dialogText cLime "/autopickup" cWhite " - Automatisches /Pickwaffe An/Aus" "`n"
					dialogText := dialogText " " "`n"
					dialogText := dialogText cOrange "Changed" "`n"
					dialogText := dialogText cLime "/online" cWhite " - in Dialog & Server Name" "`n"
					dialogText := dialogText cLime "^:" cWhite " - Automatisches /Pickwaffe An/Aus" "`n"
					dialogText := dialogText " " "`n"
					dialogText := dialogText cRed "Removed" "`n"
					dialogText := dialogText cLime "" cWhite " - " "`n"
					dialogText := dialogText " " "`n"
					dialogText := dialogText cBlue "Bug Fixes" "`n"
					dialogText := dialogText cLime "/nc" cWhite " - Chars werden jetzt escaped (z.B. ? & %)" "`n"
				}
				
				if (v == "3.5.0") {
					dialogText := dialogText cGreen "New" "`n"
					dialogText := dialogText cLime "Dialog Overhaul:" cWhite " - Viele Befehle haben jetzt Dialoge statt Chat Nachrichten" "`n"
					dialogText := dialogText cLime "STRG C:" cWhite " - Spieler in der Naehe auslesen" "`n"
					dialogText := dialogText cLime "/gebiete:" cWhite " - Gangfight Gebiete auslesen" "`n"
					dialogText := dialogText cLime "/changelog:" cWhite " - Jetzige Changelogs ansehen" "`n"
					dialogText := dialogText cLime "/changelog <version>:" cWhite " - Changelogs zur <version> auslesen" "`n"
					dialogText := dialogText cLime "/changelogs:" cWhite " - Mögliche Changelogs auslesen" "`n"
					dialogText := dialogText " " "`n"
					dialogText := dialogText cOrange "Changed" "`n"
					dialogText := dialogText cLime "F9: -> C:" cWhite " - Fraktions-Spieler in der Naehe auslesen" "`n"
					dialogText := dialogText " " "`n"
					dialogText := dialogText cRed "Removed" "`n"
					dialogText := dialogText cLime "-" cWhite " - -" "`n"
					dialogText := dialogText " " "`n"
					dialogText := dialogText cBlue "Bug Fixes" "`n"
					dialogText := dialogText cLime "Y:" cWhite " - Verbesserte Label Detection" "`n"
				}
				
				if (v == "3.4.8") {
					dialogText := dialogText cGreen "New" "`n"
					dialogText := dialogText cLime "F9:" cWhite " - Fraktions-Spieler in der Naehe auslesen" "`n"
					dialogText := dialogText " " "`n"
					dialogText := dialogText cOrange "Changed" "`n"
					dialogText := dialogText cLime "Y:" cWhite " - Label detection statt Position Listener" "`n"
					dialogText := dialogText " " "`n"
					dialogText := dialogText cRed "Removed" "`n"
					dialogText := dialogText cLime "-" cWhite " - -" "`n"
					dialogText := dialogText " " "`n"
					dialogText := dialogText cBlue "Bug Fixes" "`n"
					dialogText := dialogText cLime "/autoanwalt" cWhite " - Funktioniert jetzt, nicht mehr buggy" "`n"
				}
				
				if (v == "3.4.7") {
					dialogText := dialogText cGreen "New" "`n"
					dialogText := dialogText cLime "/unlockfps <true/false>" cWhite " - FPS Unlocker Added" "`n"
					dialogText := dialogText " " "`n"
					dialogText := dialogText cOrange "Changed" "`n"
					dialogText := dialogText cLime "-" cWhite " - -" "`n"
					dialogText := dialogText " " "`n"
					dialogText := dialogText cRed "Removed" "`n"
					dialogText := dialogText cLime "-" cWhite " - -" "`n"
					dialogText := dialogText " " "`n"
					dialogText := dialogText cBlue "Bug Fixes" "`n"
					dialogText := dialogText cLime "-" cWhite " - -" "`n"
				}
				
				if (v == "3.4.6") {
					dialogText := dialogText cGreen "New" "`n"
					dialogText := dialogText cLime "API Change" cWhite " - Neue API - thx @dape." "`n"
					dialogText := dialogText cLime "/autoanwalt" cWhite " - Auto Anwalt added (buggy)" "`n"
					dialogText := dialogText " " "`n"
					dialogText := dialogText cOrange "Changed" "`n"
					dialogText := dialogText cLime "-" cWhite " - -" "`n"
					dialogText := dialogText " " "`n"
					dialogText := dialogText cRed "Removed" "`n"
					dialogText := dialogText cLime "-" cWhite " - -" "`n"
					dialogText := dialogText " " "`n"
					dialogText := dialogText cBlue "Bug Fixes" "`n"
					dialogText := dialogText cLime "-" cWhite " - -" "`n"
				}
				
				if (v == "3.1.0") {
					dialogText := dialogText cGreen "New" "`n"
					dialogText := dialogText cLime "/nc <msg>" cWhite " - IRC: Nichio Chat added" "`n"
					dialogText := dialogText cLime "/autoanwalt" cWhite " - Auto Anwalt added (buggy)" "`n"
					dialogText := dialogText cLime "/autolotto" cWhite " - Auto Lotto added" "`n"
					dialogText := dialogText " " "`n"
					dialogText := dialogText cOrange "Changed" "`n"
					dialogText := dialogText cLime "-" cWhite " - -" "`n"
					dialogText := dialogText " " "`n"
					dialogText := dialogText cRed "Removed" "`n"
					dialogText := dialogText cLime "-" cWhite " - -" "`n"
					dialogText := dialogText " " "`n"
					dialogText := dialogText cBlue "Bug Fixes" "`n"
					dialogText := dialogText cLime "-" cWhite " - -" "`n"
				}
				
				if (v == "3.0.0") {
					dialogText := dialogText cGreen "New" "`n"
					dialogText := dialogText cLime "Website" cWhite " - Nichio.de Integration" "`n"
					dialogText := dialogText cLime "Cloud Saving" cWhite " - Nichio.de Settings.ini Cloud Saving" "`n"
					dialogText := dialogText " " "`n"
					dialogText := dialogText cOrange "Changed" "`n"
					dialogText := dialogText cLime "-" cWhite " - -" "`n"
					dialogText := dialogText " " "`n"
					dialogText := dialogText cRed "Removed" "`n"
					dialogText := dialogText cLime "-" cWhite " - -" "`n"
					dialogText := dialogText " " "`n"
					dialogText := dialogText cBlue "Bug Fixes" "`n"
					dialogText := dialogText cLime "-" cWhite " - -" "`n"
				}
				
				if (v == "2.0.0") {
					dialogText := dialogText cGreen "New" "`n"
					dialogText := dialogText cLime "Rebranding" cWhite " - Rebranding EzKeys to Nichio" "`n"
					dialogText := dialogText " " "`n"
					dialogText := dialogText cOrange "Changed" "`n"
					dialogText := dialogText cLime "-" cWhite " - -" "`n"
					dialogText := dialogText " " "`n"
					dialogText := dialogText cRed "Removed" "`n"
					dialogText := dialogText cLime "-" cWhite " - -" "`n"
					dialogText := dialogText " " "`n"
					dialogText := dialogText cBlue "Bug Fixes" "`n"
					dialogText := dialogText cLime "-" cWhite " - -" "`n"
				}
				
				if (v == "1.0.0") {
					dialogText := dialogText cGreen "New" "`n"
					dialogText := dialogText cLime "Release" cWhite " - EzKeys Keybinder Initial Release" "`n"
					dialogText := dialogText " " "`n"
					dialogText := dialogText cOrange "Changed" "`n"
					dialogText := dialogText cLime "-" cWhite " - -" "`n"
					dialogText := dialogText " " "`n"
					dialogText := dialogText cRed "Removed" "`n"
					dialogText := dialogText cLime "-" cWhite " - -" "`n"
					dialogText := dialogText " " "`n"
					dialogText := dialogText cBlue "Bug Fixes" "`n"
					dialogText := dialogText cLime "-" cWhite " - -" "`n"
				}
				
				showDialog(4, cRed "Nichio Keybinder Changelog v" v, dialogText, "Done")
			} else if (getFirstWord(cmdDialog) == "/online") {
			
				;getOnline := getSecondWord(cmdDialog)
				getOnline := SubStr(cmdDialog, 9) ; "/online " wird aus dem String entfernt
			
				dialogText := ""
				dialogText := dialogText cBlue "Users Online" "`n"
				
				Loop, Parse, getOnline, `& 
				{
					
					if (A_LoopField != "") {
						
						player := StrSplit(A_LoopField, ":")
						
						if (getUsername() == player[1]) {
							dialogText := dialogText cOrange player[2] cWhite " | " cLime player[1] cWhite " - " cBlue " (me)" "`n"
						} else {
							dialogText := dialogText cOrange player[2] cWhite " | " cLime player[1] cWhite " - ID: " getPlayerID(player[1])  "`n"
						}
						
						;AddChatMessage(KEYBINDER_PREFIX "ID: " getPlayerID(A_LoopField) " - " A_LoopField)
						
					}
					
				}
				
				showDialog(4, cRed "Nichio Keybinder Online-List", dialogText, "Done")
	
			} else if (cmdDialog == "/vorschlagliste") {
				response := _callAPI("request=getSuggestions")
				
				vorschlags := response.getSuggestions
			
				dialogText := ""
				dialogText := dialogText cBlue "Vorschläge" "`n"
				
				Loop, Parse, vorschlags, |||
				{
					
					if (A_LoopField != "") {
						
						current := StrSplit(A_LoopField, "\")
						
						;msg(A_LoopField)
						dialogText := dialogText cGray "Nr. " current[1] " " cOrange current[2] cGray ": " cWhite current[3] "`n"
						
					}
					
				}
				
				showDialog(4, cRed "Nichio Keybinder Online-List", dialogText, "Done")
			
			}
			
			cmdDialog := ""
		}
	}
	return
	
	ChatResponder:
	if (KEYBINDER_STATE == KEYBINDER_ONLINE) {
		GetChatLine(0, ChatLine)
		GetChatLine(1, KillLine)
		GetChatLine(2, Gangkillline)
		pname := getUsername()
		
		response_str := ""
		
		If InStr(KillLine, "Du hast ein Verbrechen begangen! (Beamten/Zivilisten Mord) Reporter: Polizeizentrale") {
			IniRead, PLAYER_KILLS, %SettingsPath%, InGame, Kills
			IniRead, MESSAGE_KILLSPRUCH, %SettingsPath%, InGame, Killspruch
			PLAYER_KILLS++
			SendChat(MESSAGE_KILLSPRUCH " | Nr. " PLAYER_KILLS)
			ShowGameText("+1 Kill", 3000, 5)
			
			; Call API to +1 Kills
			response_str = request=setKills&kills=%PLAYER_KILLS%
			_callAPI(response_str)
			
			IniWrite, %PLAYER_KILLS%, %SettingsPath%, InGame, Kills
			Sleep, 500
		}
		
		If (InStr(Gangkillline, "Du hast ein Verbrechen begangen! (Mord an einem Gangmitglied) Reporter: Polizeizentrale")){
			IniRead, PLAYER_KILLS, %SettingsPath%, InGame, Kills
			IniRead, MESSAGE_GANGSPRUCH, %SettingsPath%, InGame, Gangspruch
			PLAYER_KILLS++
			SendChat(MESSAGE_GANGSPRUCH " | Nr. " PLAYER_KILLS)
			ShowGameText("+1 G-Kill", 3000, 5)

			; Call API to +1 Kills
			response_str = request=setKills&kills=%PLAYER_KILLS%
			_callAPI(response_str)
			
			IniWrite, %PLAYER_KILLS%, %SettingsPath%, InGame, Kills
			Sleep, 500
		}
		
		if (RegExMatch(ChatLine, "->GANGFIGHTKILL<- " pname " Gangfightkill an (.*) (3P an (.*)", gf)) {
			IniRead, PLAYER_KILLS, %SettingsPath%, InGame, Kills
			IniRead, MESSAGE_GANGSPRUCH, %SettingsPath%, InGame, Gangspruch
			PLAYER_KILLS++
			SendChat(MESSAGE_GANGSPRUCH " | Nr. " PLAYER_KILLS)
			;ShowGameText("+1 G-Kill", 3000, 5)

			; Call API to +1 Kills
			response_str = request=setKills&kills=%PLAYER_KILLS%
			_callAPI(response_str)
			Sleep, 500
		}
		
		if InStr(ChatLine, "Sie stehen an einer Zollstation, der Zollübergang kostet $5.000! Befehl: /Zoll") {
			msg(KEYBINDER_PREFIX "Es wurde automatisch Zoll bezahlt.")
			SendChat("/zoll")
		}
		
		if (InStr(ChatLine, "Kaufe dir mit /Lotto ein Lottoticket") && InStr(ChatLine, "$10.000 und versuche dein")) {
			if (autolotto == 1) {
				Random, LottoNummer, 1, 100
				SendChat("/lotto " LottoNummer)
				
				response_str := response_str "useLotto=1" "&"
				msg(KEYBINDER_PREFIX "Es wurde automatisch ein Lotto-Ticket gekauft.")
				
			}
		}
		
		if (InStr(ChatLine, "Tippe nun '/Accept Anwalt' um die Befreiung anzunehmen.")) {
			SendChat("/accept anwalt")
		}
		
		if (InStr(ChatLine, "ist explodiert! Die Reperaturkosten in Höhe von $1.500 musst du manuell begleichen mit /Fahrzeugreparieren.")) {
			SendChat("/fahrzeugreparieren")
		}
		
		if (RegexMatch(ChatLine, "Spieler " pname " hat sich für (.*) Waffenteile (.*)", usage)) {
			
			previous_first_chatline := ChatLine
			msg(KEYBINDER_PREFIX "Du hast " usage1 " Waffenteile benutzt.")
			response_str := response_str "useWT=" usage1 "&"
			
		}
		
		if (RegexMatch(ChatLine, ">> (.*) hat den Verbrecher (.*) eingesperrt. <<", anwalt)) {
			;msgbox % anwalt2
		}
		
		if (RegexMatch(KillLine, "Spieler " pname " hat sich für (.*) Waffenteile (.*)", usage)) {
			
			if (!InStr(KillLine, previous_first_chatline)) {
				msg(KEYBINDER_PREFIX "Du hast " usage1 " Waffenteile benutzt.")
				response_str := response_str "useWT=" usage1 "&"
			}

		}
		
		if (InStr(ChatLine, "* " pname " hat sich nen Joint gedreht.")) {
			msg(KEYBINDER_PREFIX "Du hast eine Droge genommen.")
			response_str := response_str "useDrogen=1" "&"
		}
		
		if (InStr(ChatLine, "* " pname " nimmt Spice zu sich.")) {
			msg(KEYBINDER_PREFIX "Du hast ein Spice genommen.")
			response_str := response_str "useSpice=1" "&"
		}
		
		_callAPI(response_str)
		
		c_HP := GetPlayerHealth()
		c_AR := GetPlayerArmor()
		GuiControl,, HealthBar, %c_HP%
		GuiControl,, HealthText, Health: %c_HP%
		GuiControl,, ArmorBar, %c_AR%
		GuiControl,, ArmorText, Armor: %c_AR%
	}
	return
	
	HPUpdater:
	if (KEYBINDER_STATE == 1 && togglehp == 1) {
		
		
		
		newhp := GetPlayerHealth()
		newarmor := GetPlayerArmor()
		newhealth := GetPlayerHealth() + GetPlayerArmor()
			
			; Health
			if (newhealth != oldhealth) {
				if (newhealth  0) {
					dmg := (-1 * (oldhealth - newhealth))
					
					if (dmg != 2139094940 && dmg != -2139094940 && dmg != "") {
						if (dmg < 0) {
							cHPColor := cRed
							if (GetPlayerArmor() > 0) {
								cHPColor := cBlue
							}
							msg(KEYBINDER_PREFIX cHPColor "HP: " cWhite dmg getHealthloseWeapon(dmg) )
						}
					}
				}
				
				oldhealth := GetPlayerHealth() + GetPlayerArmor()
			}
			
			; HP ###############################################
			if (newhp != oldhp && false) {
				dmg := (oldhp - newhp)
				
				if (dmg != 2139094940 && dmg != -2139094940 && dmg != "") {
					if (dmg > 0) {
						;ShowGameText(getHealthloseWeapon(oldhp - newhp), 1000, 1)
						AddChatMessage(KEYBINDER_PREFIX "{FF0000}HP: " cWhite (-1 * (oldhp - newhp)) KEYBINDER_TEXTCOLOR  " || Wahrscheinlicher Grund: {FF0000}" getHealthloseWeapon(oldhp - newhp) )
						yup = 1
					}
				}
				
				oldhp := GetPlayerHealth()
				
			}
			
			; Armor ###############################################
			if (oldarmor != newarmor && false) {
				
				dmweste := (oldarmor - newarmor)
				if (dmweste > 0 && dmweste != -2139094940 && dmweste != 2139094940 && dmweste != "") {
					;ShowGameText(getHealthloseWeapon(oldarmor - newarmor), 1000, 1)
					AddChatMessage(KEYBINDER_PREFIX "{0077be}AP: " (-1 * (oldarmor - newarmor) ) KEYBINDER_TEXTCOLOR " || Wahrscheinlicher Grund: {0077be}" getHealthloseWeapon(oldarmor - newarmor) )
				}
				
				oldarmor := GetPlayerArmor()
				
			}
			
			; MSG ###############################################
			if (yup == 1) {
				; AddChatMessage(KEYBINDER_PREFIX "{d3d3d3} HP: " GetPlayerHealth() " | Armor: " GetPlayerArmor() )  
				yup = 0
				; Sleep, 1000
			}
			
			c_HP := GetPlayerHealth()
			c_AR := GetPlayerArmor()
			GuiControl,, HealthBar, %c_HP%
			GuiControl,, HealthText, Health: %c_HP%
			GuiControl,, ArmorBar, %c_AR%
			GuiControl,, ArmorText, Armor: %c_AR%
		}
	return
	
	PositionListener:
	if (isKeybinderAvailable(true)) {
		
		; Auto Pickup
		if (autopickup) {
			model_closest := getClosestPickupModel()
			
			if (model_closest > 320 && model_closest < 371) {
				model_distance := getDistanceToPickup(model_closest)
				if (distance < 0.5) {
					IniRead, p_spruch, %SettingsPath%, InGame, Pickspruch
					SendChat("/pickwaffe")
					SendChat(p_spruch)
					Sleep, 500
				}
			}
		}
		
		
		if(IsPlayerInRange3D(-1857.0846,-1618.0605,21.4436, 5)) {
			SendChat("/paketentladen")
			ShowGameText("+"  (wdealerpakete * 100) " Waffenteile!", 3000, 3)
			Sleep, 10000
		} else if(IsPlayerInRange3D(2348, -2302, 14, 2)) {
			SendChat("/paketeinladen " wdealerpakete)
			Sleep, 3000
		}  else if (IsPlayerInRange3D(-38.960495, 57.272049, 4.059539, 2)) {
			SendChat("/samenpaketeinladen 5")
			Sleep, 3000
		} else if (IsPlayerInRange3D(-309.866852, -2119.856201, 29.057947, 2)) {
			SendChat("/samenpaketentladen")
			Sleep, 3000
		}
		
		; / Drivein
		if(IsPlayerInRange3D(1213.9054,-903.2825,42.6253, 1)) {
			SendChat("/drivein")
			Sleep, 100
			SendChat("/me hat sich ein Snack gekauft")
			Sleep, 3000
		}
			
	}
	return
	
	ChatListener:
	if (isKeybinderAvailable()) {
		
		response_str = request=getNewMSG&chatTimestamp=%CHAT_TIMESTAMP%
		
		response := _callAPI(response_str)
		
		if (response.getNewMSGTimestamp > 0) {
			
			CHAT_TIMESTAMP := response.getNewMSGTimestamp
			
			if (InStr(response.getNewMSG, "[LOCATION]: ")) {
				
				message_split := StrSplit(response.getNewMSG, "[LOCATION]: ")
				
				coords := StrSplit(message_split[2], ",")
				
				if (autohelp) {
					NEWSetCheckpoint(coords[1], coords[2], coords[3])
				}
				
				zone := calculateZone(coords[1], coords[2], coords[3])
				city := calculateCity(coords[1], coords[2], coords[3])
				
				AddChatMessage(cRed "** Nichio " cGreen "Location " cGray response.getNewMSGAuthor cWhite ": " cWhite message_split[1] "" zone " in " city cRed " **")
			} else {
				AddChatMessage(cOrange "** Nichio " cGray response.getNewMSGAuthor cWhite ": " cWhite response.getNewMSG cOrange " **")
			}
			
		}
		
	}
	return
	
	KeksBot:
	if (KEYBINDER_STATE == 1 ) {
		if (KEKSBOT_STATE == KEYBINDER_ONLINE) {
			
			while(true) {
				i = 6
				while (i != 0) {
					if (KEKSBOT_STATE == 0) {
						return
					}
					
					GetChatLine(0, textline)
					if (InStr(textline, "Du kannst keine Kekse mehr essen, da du zuviel Leben hast.") || InStr(textline, "Du hast keine Kekse mehr.")) {
						AddChatMessage(KEYBINDER_PREFIX "KeksBot wurde deaktiviert.")
						KEKSBOT_STATE = 0
						return
					}
					
					SendChat("/isskeks")
					Sleep, 100
					i--
				}
				Sleep, 7000
			}
			
			GetChatLine(0, textline)
			if InStr(textline, "Du kannst keine Kekse mehr essen, da du zuviel Leben hast.") {
				AddChatMessage(KEYBINDER_PREFIX "KeksBot wurde deaktiviert.")
				KEKSBOT_STATE = 0
				return
			}
			
		}
	}
	return
	
	Maintenance:
		; Wenn nicht auf AC achten muss, ist AC nur an wenn SAMP offen ist, sonst deaktiviert es sich
		if (AC_COMPATIBILITY == 0) {
			if ( !WinActive("ahk_exe gta_sa.exe")) {
				Suspend, On
			} else {
				Suspend, Off
			}
		}
	
		if (sync_timer == 0) {
			; um nicht server zu überlasten, nur alle 5 sekunden die settings.ini updaten
			_sync()
			sync_timer = 5
		} else {
			sync_timer := sync_timer - 1
		}
		
		; online muss jede sekunde, weil hardcoded ist dass bei jedem aufruf +1 für playtime gemacht wird
		_online()
	return

; ########################## CUSTOM COMMANDS ######################

; ===== "Callback" for evaluation of commands =====

CMDyoyo(params := "") {
	Loop, 20 {
		msg("")
	}
	msg(getPlayerPos()[1] ", " getPlayerPos()[2] ", " getPlayerPos()[3] )
	return true
}

global cp := true
CMDtogglecp(params := "") {
	cp := !cp
	toggleCheckpoint(cp)
	return true
}

CMDvorschlag(params := "") {
	if (params == "") {
		msg(KEYBINDER_PREFIX "Benutzung: /vorschlag <text>")
		return true
	}
	
	IfInString, params, /
	{
		msg(KEYBINDER_PREFIXERROR "Bitte kein '/' benutzen.")
		return true
	}
	
	StringLen, length, params
	
	if (length > 75) {
		msg(KEYBINDER_PREFIX "Deine Nachricht ist zu lang. Maximale Länge: 75 Buchstaben. Deine Nachricht: " length)
		return true
	}
	
	_callAPI("sendSuggestion=" UrlEncode(params) )
	
	msg(KEYBINDER_PREFIX "Vorschlag gesendet: " cGray params)
	
	
	
	return true
}

CMDvorschlagliste(params := "") {
	cmdDialog := "/vorschlagliste"
	
	return true
}

CMDonline(params := "") {
	
	response := _callAPI("request=getOnline")
	
	getOnline := response.getOnline
	
	cmdDialog := "/online " getOnline
	
	; // response wird im format ausgegeben => kensho.nichio&tazsuyo.nichio&
	return true
}

CMDchangelog(params := "") {
	if (params == "") {
		msg(KEYBINDER_PREFIX "Benutzung: /changelog <version>")
		msg(KEYBINDER_PREFIX "Versionen: /changelogs")
		params := KEYBINDER_VERSION
		;return true
	}
	
	if (params == "dev")
		cmdDialog := "/changelog dev"
	else 
		cmdDialog := "/changelog " params
	
	return true
}

CMDchangelogs(params := "") {
	msg(KEYBINDER_PREFIX "3.0.0 & 3.X.X todo in Dialog")
	cmdDialog := "/changelogs"
	return true
}

CMDgebiete(params := "") {
	if (!updateGangzones())
			return

	total := 0
	arr := [0, 0, 0, 0, 0, 0, 0, 0]
	for i, fGangZ in oGangzones {
		for j, k in fraktionen {
			if (fGangZ.COLOR1 == k.GANGZONE) {
				arr[j]++
				break
			}
		}

		total := i
	}

	string := ""
	for h, m in arr
		string .= m "," h "`n"

	Sort string, NR
	AddChatMessage(KEYBINDER_PREFIX "=======GEBIETE=======")
	Loop, Parse, string, `n
	{
		if (A_LoopField == "")
			continue

		var := StrSplit(A_LoopField, ",")
		AddChatMessage(KEYBINDER_PREFIX  "" fraktionen[var[2]].NAME ": {FFFFFF}[" var[1] "/" total "]", fraktionen[var[2]].COLOR)
		Sleep, 20
	}

	AddChatMessage(KEYBINDER_PREFIX "=====================", COLOR_GREEN)
		
	return true
}

CMDunlockfps(params := "") {
	if (params == "true") {
		unlockfps(true)
	} else if (params == "false") {
		unlockfps(false)
	}
	
	return true
}

CMDgetObject(params := "") {
	msg(getClosestObjectModel())
	
	return true
}

CMDtr(params := "") {
	AddChatMessage(KEYBINDER_PREFIX "= ")
	return true
}

CMDautoanwalt(params := "") {
	AutoAnwalt := !AutoAnwalt
	if (AutoAnwalt == 1) 
		msg(KEYBINDER_PREFIX "Auto Anwalt wurde aktiviert.")
	else
		msg(KEYBINDER_PREFIX "Auto-Anwalt wurde deaktiviert.")
	return true
}

CMDautopickup(params := "") {
	autopickup := !autopickup
	if (autopickup == 1) 
		msg(KEYBINDER_PREFIX "Auto-Pickup wurde aktiviert.")
	else
		msg(KEYBINDER_PREFIX "Auto-Pickup wurde deaktiviert.")
	return true
}

CMDautohp(params := "") {
	togglehp := !togglehp
	if (togglehp == 1)
		msg(KEYBINDER_PREFIX "HP-Updater wurde angeschalten.")
	else
		msg(KEYBINDER_PREFIX "HP-Updater wurde ausgeschalten.")
	
	return true
}

CMDautolotto(params := "") {
	autolotto := !autolotto
	if (autolotto == 1)
		msg(KEYBINDER_PREFIX "Auto-Lotto wurde angeschalten.")
	else
		msg(KEYBINDER_PREFIX "Auto-Lotto wurde ausgeschalten.")
	
	return true
}

CMDautohelp(params := "") {
	autohelp := !autohelp
	if (autohelp == 1)
		msg(KEYBINDER_PREFIX "Auto-Help wurde angeschalten.")
	else
		msg(KEYBINDER_PREFIX "Auto-Help wurde ausgeschalten.")
	
	return true
}

CMDnc(params := "") {
	
	IfInString, params, /
	{
		msg(KEYBINDER_PREFIXERROR "Bitte kein '/' benutzen.")
		return true
	}
		
	msg := "" UrlEncode(params) ""
	
	;msgbox % uriEncode(params) ""
	; test? := test%0x3F
	
	;msg(msg)
	
	response_str := "request=sendMSG&msg=" msg
	_callAPI(response_str)
	
	return true
}

CMDhotkeys(params := "") {
	;AddChatMessage(cRed "==============" cBlue " KeyBinder Hotkeys " cRed "==============" )
	;AddChatMessage(cRed "F2: " cBlue "/carkey" cGray " | | " cRed "F3: " cBlue "/carlock" cGray " | | " cRed "F4: " cBlue "/motor" )
	;AddChatmessage(cRed ".: " cBlue "/nimmspice" cGray " | | " cRed ",: " cBlue "/nimmdrogen" cGray " | | " cRed "F12: " cBlue "Keybinder An/Aus")
	;AddChatMessage(cRed "X: " cBlue "Handy An/Aus" cGray " | | " cRed "Y: " cBlue "Multifunktionstaste" cGray " | | " cRed "+: " cBlue "Config auslesen" )
	;AddChatMessage(cRed "STRG K: " cBlue "KeksBot" cGray " | | " cRed "^: " cBlue "/pickwaffe" cGray " | | " cRed "Shift: " cBlue "Laufscript" )
	;AddChatMessage(cRed "STRG R: " cBlue "/frespawn" cGray " | | " cRed "C: " cBlue "Print Fraktions Users" cGray " | | " cRed "-: " cBlue "-" )
	;AddChatMessage(cRed "==========================================" )
	
	cmdDialog := "/hotkeys"
	return true
}

CMDbefehle(params := "") {
	;AddChatMessage(cRed "==============" cBlue " KeyBinder Befehle " cRed "==============" )
	;AddChatMessage(cRed "/ja: " cBlue "Anruf annehmen" cGray " | | " cRed "/nein: " cBlue "Mailbox" cGray " | | " cRed "/auf: " cBlue "Anruf auflegen" )
	;AddChatMessage(cRed "/wl: " cBlue "/Waffenlager" cGray " | | " cRed "/sb: " cBlue "/Safebox" cGray " | | " cRed "/fsb: " cBlue "/FSafebox" )
	;AddChatMessage(cRed "/find: " cBlue "AutoFind Bot" cGray " | | " cRed "/show: " cBlue "AutoShow Bot" cGray " | | " cRed "/vkwt: " cBlue "Verkaufe WT")
	;AddChatMessage(cRed "/rlotto: " cBlue "Random Lotto" cGray " | | " cRed "/inv: " cBlue "/inventar" cGray " | | " cRed "/fin: " cBlue "/finanzen" )
	;AddChatMessage(cRed "/location: " cBlue "Location Overlay" cGray " | | " cRed "/autowc: " cBlue "AFK Wantedcodes Farmen" )
	;AddChatMessage(cRed "/laufen: " cBlue "Laufscript" cGray " | | " cRed "/vkks: " cBlue "Verkaufe Kekse" cGray " | | " cRed "/laufen: " cBlue "Laufscript")
	;AddChatMessage(cRed "/skinid: " cBlue "Gib deine SkinID Aus" cGray " | | " cRed "/m4: " cBlue "Kaufe eine M4" cGray " | | " cRed "/sniper: " cBlue "Kaufe eine AWP" )
	;AddChatMessage(cRed "/shotgun: " cBlue "Kaufe eine Shotgun" cGray " | | " cRed "/nc : " cBlue "Nichio-Chat" cGray " | | " cRed "/online: " cBlue "Keybinder Online List" )
	;AddChatMessage(cRed "/autohp: " cBlue "HP Updater umschalten" cGray " | | " cRed "/gebiete : " cBlue "Gang-Gebiete auslesen" cGray " | | " cRed "/x: " cBlue "x" )
	;AddChatMessage(cRed "==========================================" )
	
	cmdDialog := "/befehle"
	return true
}

CMDconfig(params := "") {
	AddChatMessage(cRed "==============" cBlue " KeyBinder Config " cRed "==============" )
	AddChatMessage(cRed "/version: " cBlue "Version des KeyBinders" cGray " | | " cRed "/savepos: " cBlue "Speicher die Coords einer Position" )
	AddChatMessage(cRed "/h: " cBlue "Setzte dein Helfer fest" cGray " | | " cRed "/t: " cBlue "Setzte dein Ziel fest" )
	;AddChatMessage(cRed "/killspruch: " cBlue "Killspruch setzen" cGray " | | " cRed "/waffendealer: " cBlue "WaffendealerBot" )
	;AddChatMessage(cRed "/kills: " cBlue "Setze deine Kills fest" cGray " | | " cRed "/gangspruch " cBlue "Gang Killspruch setzen."  )
	;AddChatMessage(cRed "/laufen: " cBlue "Laufscript" cGray " | | " cRed "/pickspruch: " cBlue "Pickspruch festlegen"  )
	;AddChatMessage(cRed "/jaspruch: " cBlue "/ja > Spruch" cGray " | | " cRed "/aufspruch: " cBlue "/auf > Spruch"  )
	AddChatMessage(cRed "==========================================" )
	return true
}

CMDwl(params := "") {
	SendChat("/waffenlager")
	return true
}

CMDsb(params := "") {
	SendChat("/safebox")
	return true
}


CMDfsb(params := "") {
	SendChat("/fsafebox")
	return true
}

CMDm4(params := "") {
	SendChat("/Waffenlager")
	Sleep, 100
	SendInput, {down} {enter} 
	Sleep, 100
	SendInput, {down} {enter}
	Sleep, 100
	SendInput, {escape} 
	Sleep, 100
	SendInput, {escape}
	return true
}

CMDshotgun(params := "") {
	SendChat("/Waffenlager")
	Sleep, 100
	SendInput, {down} {enter} 
	Sleep, 100
	SendInput, {down} {down} {down} {down} {enter}
	Sleep, 100
	SendInput, {escape} 
	Sleep, 100
	SendInput, {escape}
	return true
}

CMDsniper(params := "") {
	SendChat("/Waffenlager")
	Sleep, 100
	SendInput, {down} {enter} 
	Sleep, 100
	SendInput, {enter}
	Sleep, 100
	SendInput, {escape} 
	Sleep, 100
	SendInput, {escape}
	return true
}

CMDchangelog_old(params := "") {
	AddChatMessage(cRed "================" cBlue " Changelog " cRed "=================" )
	AddChatMessage(cRed "/gangspruch: " cBlue "Gang Killspruch setzen" cGray " | | " cRed "/------: " cBlue "-------------------"  )
	AddChatMessage(cRed "==========================================" )
	return true
}

CMDja(params := "") {
	pname := GetUsername()
	SendChat("/abnehmen")
	IniRead, spruch, %SettingsPath%, InGame, JaSpruch
	if (spruch == "ERROR") {
		SendChat("Guten Tag! " pname " am Apparat.")
		SendChat("Wie kann ich dir helfen?")
	} else {
		SendChat(spruch)
	}
	return true
}

CMDnein(params := "") {
	pname := getUsername()
	SendChat("/abnehmen")
	SendChat("Hier ist die Mailbox von " pname ".")
	SendChat("Du hast 15 Sekunden Zeit mir deine Nachricht mitzuteilen.")
	Sleep, 15000
	SendChat("/auflegen")
	return true
}

CMDauf(params := "") {
	pname := getUsername()
	IniRead, spruch, %SettingsPath%, InGame, NeinSpruch
	if (spruch == "ERROR") {
		SendChat("Ich wünsche ihnen noch einen angenehmen Tag.")
		SendChat("Mit freundlichen Grüßen " pname ".")
	} else {
		SendChat(spruch)
	}
	SendChat("/auflegen")
	return true
}

CMDrlotto(params := "") {
	Random, randLotto, 0, 100
	SendChat("/lotto " randLotto)
	return true
}

CMDfin(params := "") {
	SendChat("/finanzen")
	return true
}

CMDinv(params := "") {
	SendChat("/inventar")
	return true
}

CMDskinid(params := "") {
	;AddChatMessage(KEYBINDER_PREFIX "Skin ID: " GetPlayerSkinId() )
	;msg("negativ sir")
	msg(getSkinID(1))
	return true
}

CMDh(params := "") {
	
	if (params == "") {
        msg(KEYBINDER_PREFIX "Benutzung: /h [user]")
		return true
	}
	
	helfer := getFirstWord(params)
	
	AddChatMessage(KEYBINDER_PREFIX "Dein Helfer ist nun: " helfer)
	IniWrite, %helfer%, %SettingsPath%, InGame, Helfer
	return true
}

CMDt(params := "") {
	
	if (params == "") {
        msg(KEYBINDER_PREFIX "Benutzung: /t [user]")
		return true
	}
	
	target := getFirstWord(params)
	
	AddChatMessage(KEYBINDER_PREFIX "Dein Ziel ist nun: " target )
	IniWrite, %target%, %SettingsPath%, InGame, Target
	return true
}

CMDlocation(params := "") {
	if (Locing == 0) {
		AddChatMessage(KEYBINDER_PREFIX "Location Updater wurde aktiviert.")
		Locing = 1
	} else {
		AddChatMessage(KEYBINDER_PREFIX "Location Updater wurde deaktiviert.")
		Locing = 0
	}
	return true
}

CMDfind(params := "") {
	if (Detektiv != 1) {
		Detektiv = 1
		AddChatMessage(KEYBINDER_PREFIX "DetektivBot (AutoFind) wurde aktiviert.")
	} else {
		Detektiv = 0
		AddChatMessage(KEYBINDER_PREFIX "DetektivBot wurde deaktiviert.")
	}
	return true
}

CMDshow(params := "") {
	if (Detektiv != 2) {
		Detektiv = 2
		AddChatMessage(KEYBINDER_PREFIX "DetektivBot (AutoShow) wurde aktiviert.")
	} else {
		Detektiv = 0
		AddChatMessage(KEYBINDER_PREFIX "DetektivBot wurde deaktiviert.")
	}
	return true
}

CMDsavepos(params := "") {
	AddChatMessage(KEYBINDER_PREFIX "Deine Position " params " wurde gespeichert." )
	
	;GetPlayerPos(X, Y, Z)
	X := GetPlayerPos[1]
	Y := GetPlayerPos[2]
	Z := GetPlayerPos[3]
	posstring = %X%, %Y%, %Z%
	
	msg(posstring)
	
	IniWrite, %posstring%, savedpositions.ini, Position, %params%
	return true
}

CMDvkwt(params := "") {
	
	target := getFirstWord(params)
	amount := getSecondWord(params)
	
	if (params == "" || target == "" || amount == "") {
        msg(KEYBINDER_PREFIX "Benutzung: /vkwt [user] [waffenteile]")
		return true
	}
	
	SendChat("/sellwaffenteile " target " " amount " " (amount * 25) )
	return true
}

CMDvkks(params := "") {
	
	target := getFirstWord(params)
	amount := getSecondWord(params)
	
	if (params == "" || target == "" || amount == "") {
        msg(KEYBINDER_PREFIX "Benutzung: /vkwt [user] [waffenteile]")
		return true
	}
	
	SendChat("/sellkekse " target " " amount " " (amount * 45))
	return true
}

CMDautowc(params := "") {
	if (WCoding == 0) {
	WCoding = 1
	AddChatMessage("On")
	} else {
		WCoding = 0
		AddChatMessage("Off")
	}
	return true
}

CMDlaufen(params := "") {
	if (Laufscript == 1) {
		AddChatMessage(KEYBINDER_PREFIX "Laufscript wurde deaktiviert.")
		Laufscript = 0
	} else {
		AddChatMessage(KEYBINDER_PREFIX "Laufscript wurde aktiviert.")
		Laufscript = 1
	}
	return true
}

CMDversion(params := "") {
	AddChatMessage(KEYBINDER_PREFIX "Version: " KEYBINDER_VERSION)
	return true
}

OnPlayerCommand(command) {
	;AddChatMessage("2 " command)
	RegExMatch(command, "/(\S*)(\s*)(.*)", var) ; var3 is passed as string of parameters
	
	; format: /cmd params params params
	
	if (!CMD%var1%(var3) && !InStr("/q/quit/save/rs/interior/fpslimit/pagesize/headmove/timestamp/dl/nametagstatus/mem/audiomsg/fontsize/ctd/rcon/idktest/", "/" . var1 . "/")) {
		return false
	}
	
	return true
}

getFirstWord(string) {
	words := StrSplit(string, A_Space)

	return words[1]
}

getSecondWord(string) {
	words := StrSplit(string, A_Space)

	return words[2]
}
	
; ########################## KEYBINDINGS ##########################
	*F12::
	if (KEYBINDER_STATE == 1) {
		AddChatMessage(KEYBINDER_PREFIXRED KEYBINDER_CLIENTNAME " Keybinder deaktiviert.")
		GuiControl,, STATE, KeyBinder: AUS
		KEYBINDER_STATE := KEYBINDER_OFFLINE
	} else {
		AddChatMessage(KEYBINDER_PREFIXGREEN KEYBINDER_CLIENTNAME " Keybinder aktiviert.")
		GuiControl,, STATE, KeyBinder: AN
		
		KEYBINDER_STATE := KEYBINDER_ONLINE
	}
	return
	
	global B := "{00C0FF}"
	global W := "{FFFFFF}"
	
	F9::
	msg ("lol")
	return
	
	*F20::
	unblockDialog()
	if (isKeybinderAvailable()) {
		;msg( getDialogID() )
		;msg( setActiveWeaponSlot() )
		
		AddChatMessage(KEYBINDER_PREFIX "=======SPECS=======")
		maxid := getMaxPlayerID() + 1
				
		loop %maxid% {
			c_id := A_Index - 1
			
			; loop for each player
			target_player_skinid := getSkinID(c_id)
			target_player_distance := getDistance(getPlayerPos(), getPlayerPosition(c_id))
			
			; wenn out of render distance dann pos == 0
			
			msg("ID: " c_id " | Skin: " target_player_skinid " | Distance: " target_player_distance " | Pos: " getPlayerPosition(c_id)[1])
			
		
		}
		
		AddChatMessage(KEYBINDER_PREFIX "====================")
		
	}
	return
	
	F7::
		;msg(getPickupModelsInDistance(2))
		
	return
	
	*F7::
		;    printWurstObj()
		;	 bumpVehicleX()
		;	 bumpVehicleY()
		

	return

#if WinActive("GTA:SA:MP")
Enter::
	if (!isKeybinderAvailable(true)) {
			SendInput, {enter}
			return
		}
		
		if (IsDialogOpen()) {
			SendInput, {enter}
		}
		
		clip := ClipboardAll
		Clipboard := ""
		SendInput, {Right}a{BackSpace}^a^c ;^A{Backspace}
		ClipWait, 0.1
		chatText := Clipboard
		Clipboard := clip

		if (chatText == -1 || chatText == "")
			return

		if (SubStr(chatText, 1, 1) == "/") {
			if (!OnPlayerCommand(chatText)) {
				SendInput, {enter}
			} else {
				if (InStr("/q/quit/save/rs/interior/fpslimit/pagesize/headmove/timestamp/dl/nametagstatus/mem/audiomsg/fontsize/ctd/rcon/idktest/", chatText)) {
					SendInput, {Enter}
				} else {
					SendInput, {Backspace}{Escape}
				}
			}
		} else {
			SendInput, {enter}
		}
return
	
#if isChatOpen() == 0 && IsDialogOpen() == 0 && IsInMenu() == 0 && isKeybinderAvailable(true)
	
	*F2::	
	if (isKeybinderAvailable(true)) {
		SendChat("/carkey")
		;Sleep, 100
		;SendInput, {down 3}
		;SendInput, {enter}
		;Sleep, 200
		;SendInput, {enter}
		;Sleep, 100
		;SendInput, {enter}
	}
	return

	*F3::
	if (isKeybinderAvailable(true) ) {
		SendChat("/carlock")
	}
	return
	
	*F4::
	if (isKeybinderAvailable(true) ) {
		SendChat("/motor")
		SendChat("/licht")
		if (GetVehicleModelId(getPlayerVehicleID(getID())) == 521 || GetVehicleModelId(getPlayerVehicleID(getID())) = 522) {
			SendChat("/helm")
		}
		if (GetVehicleModelID(getPlayerVehicleID(getID())) == 416) {
			SendChat("/flock")
		}
		Sleep, 250
	}
	return
	
	*X::
	if (isKeybinderAvailable(true) ) {
		if(HANDY_STATE == 1) {
			SendChat("/handystatus aus")
			HANDY_STATE = 0
		} else {
			SendChat("/handystatus an")
			HANDY_STATE = 1
		}
	}
	return
	
	*^C::
	if (isKeybinderAvailable()) {
		;msg( getDialogID() )
		;msg( setActiveWeaponSlot() )
		msg(KEYBINDER_PREFIX cGreen "Es wird nach Spielern in der Nähe gesucht...")
		
		Sleep, 20
		maxid := getMaxPlayerID() + 1
		player_count := 0
		player_array := []
			
				
		loop %maxid% {
			c_id := A_Index - 1
			
			target_player_skinid := getSkinID(c_id)
			target_player_position := getPlayerPosition(c_id)
			target_player_distance := Round(getDistance(target_player_position, getPlayerPos()))
			target_player_zone := calculateZone(target_player_position[1], target_player_position[2], target_player_position[3])
				
			if (target_player_skinid != -1) {
				player_count++
				player_array[player_count] := Object("DISTANCE", target_player_distance, "LOCATION", target_player_zone, "ID", c_id)
			}
			
		
		}
			
		if (player_count == 0) {
			msg(KEYBINDER_PREFIX cRed "Es wurden keine Spieler in der Nähe gefunden.")
			return
		}
		
		for index, element in player_array {
			msg(KEYBINDER_PREFIX cWhite getPlayerName(player_array[index]["ID"]) cLime " " player_array[index]["DISTANCE"] "m " cBlue player_array[index]["LOCATION"])
			Sleep, 20
		}
		
		
	}
	return
	
	*C::
	if (isKeybinderAvailable()) {
		;msg( getDialogID() )
		;msg( setActiveWeaponSlot() )
		msg(KEYBINDER_PREFIX cGreen "Es wird nach Fraktions-Spielern in der Nähe gesucht...")
		
		Sleep, 20
		maxid := getMaxPlayerID() + 1
		player_count := 0
		player_array := []
			
			for i, element in fraktionen {
				
				loop %maxid% {
				c_id := A_Index - 1
				
				target_player_skinid := getSkinID(c_id)
			
				for j, skins in element["SKINS"] {
						
					if (element["SKINS"][j] == target_player_skinid) {
						player_count++
						player_array[player_count] := Object("COLOR2", element["COLOR2"], "FRAK", element["NAME"], "ID", c_id)
					}
				
				}
			
			}
			
		}
		if (player_count == 0) {
			msg(KEYBINDER_PREFIX cRed "Es wurden keine Fraktions-Spieler in der Nähe gefunden.")
			return
		}
		
		for index, element in player_array {
			msg(KEYBINDER_PREFIX player_array[index]["COLOR2"] player_array[index]["FRAK"] cWhite " " getPlayerName(player_array[index]["ID"]) " - ID: " player_array[index]["ID"])
			Sleep, 20
		}
		
		
	}
	return
	
	*#::
	if (isKeybinderAvailable(true) ) {
		;AddChatMessage(cRed "==============" cBlue " KeyBinder Guide " cRed "==============" )
		;AddChatMessage(cRed "/befehle: " cBlue "Befehle nachsehen" cGray " | | " cRed "/hotkeys: " cBlue "Hotkeys nachsehen" )
		;AddChatMessage(cRed "/changelog: " cBlue "Changelog nachsehen" cGray " | | " cRed "/config: " cBlue "Konfiguriere den Keybinder" )
		;AddChatMessage(cRed "==========================================" )
		
		dialogText := ""
		dialogText := dialogText cLime "/befehle" cWhite " - Befehle nachsehen" "`n"
		dialogText := dialogText cLime "/hotkeys" cWhite " - Hotkeys nachsehen" "`n"
		dialogText := dialogText cLime "/changelog" cWhite " - Changelog nachsehen" "`n"
		dialogText := dialogText cLime "/config" cWhite " - Konfiguration nachsehen" "`n"
		showDialog(4, cRed "Nichio Keybinder Guide", dialogText, "Done")
	}
	return
	
	*+::
	if (isKeybinderAvailable(true)) {
		v := KEYBINDER_VERSION
		IniRead, k, %SettingsPath%, InGame, Kills
		IniRead, wt, %SettingsPath%, InGame, Waffendealerpakete
		IniRead, dr, %SettingsPath%, InGame, Drogendealerpakete
		IniRead, ks, %SettingsPath%, InGame, Killspruch
		IniRead, gs, %SettingsPath%, InGame, Gangspruch
		IniRead, ps, %SettingsPath%, InGame, Pickspruch
		IniRead, js, %SettingsPath%, InGame, JaSpruch
		IniRead, as, %SettingsPath%, InGame, NeinSpruch
		;AddChatMessage(KEYBINDER_PREFIX "Version: " v)
		;AddChatMessage(KEYBINDER_PREFIX "Waffenpakete: " wt)
		;AddChatMessage(KEYBINDER_PREFIX "Drogenpakete: " dr)
		;AddChatMessage(KEYBINDER_PREFIX "Killspruch: " ks)
		;AddChatMessage(KEYBINDER_PREFIX "Pickspruch: " ps)
		;AddChatMessage(KEYBINDER_PREFIX "/Ja Spruch: " js)
		;AddChatMessage(KEYBINDER_PREFIX "/auf Spruch: " as)
		
		dialogText := ""
		dialogText := dialogText cLime "Version" cWhite " - " v "`n"
		dialogText := dialogText cLime "Waffenpakete" cWhite " - " wt "`n"
		dialogText := dialogText cLime "Drogenpakete" cWhite " - " dr "`n"
		dialogText := dialogText " " "`n"
		dialogText := dialogText cLime "Killspruch" cWhite " - " ks "`n"
		dialogText := dialogText cLime "Gangspruch" cWhite " - " gs "`n"
		dialogText := dialogText cLime "Pickspruch" cWhite " - " ps "`n"
		dialogText := dialogText cLime "/Ja Spruch" cWhite " - " js "`n"
		dialogText := dialogText cLime "/Auf Spruch" cWhite " - " as "`n"
		showDialog(4, cRed "Nichio Keybinder Config", dialogText, "Done")
		
	}
	return
	
	*Y::
	if (isKeybinderAvailable(false) ) {
		
		lbl := getNearestLabel()
		myPos := getPlayerPos()
	
		if (getDistance([lbl.XPOS, lbl.YPOS, lbl.ZPOS], myPos) < 5.0) {
			
			if (!RegExMatch(lbl.TEXT, "(.*)/(\S+)", command))
				return		
			
			if (InStr(lbl.TEXT, "/waffenlager")) {
				SendChat("/Waffenlager")
				sendDialogResponseWait(1230, true, 1)
				sendDialogResponseWait(1233, true, 5)
				sendDialogResponseWait(1233, true, 4)
				sendDialogResponseWait(1233, true, 1)
				sendDialogResponseWait(1233, false, 1)
				sendDialogResponseWait(1230, false, 1)
				closeDialog()
			} else if (InStr(lbl.TEXT, "/fsafebox")) {
				SendChat("/FSafebox")
				; drogen
				sendDialogResponseWait(1379, true, 0)
				sendDialogResponseWait(1380, true, 1)
				sendDialogResponseWait(1382, true, 0, "200")
				; spice
				sendDialogResponseWait(1379, true, 3)
				sendDialogResponseWait(1380, true, 1)
				sendDialogResponseWait(1382, true, 0, "100")
				sendDialogResponseWait(1379, false, 0)
				
				; schließen
				closeDialog()
			} else if (InStr(lbl.TEXT, "Tankstelle")) {
				SendChat("/tanken")
			} else {
				_getCMDbyString(lbl.TEXT)
			}
			
		}
		
		;if (IsPlayerInRange3D(-780.301636, 505.897461, 1371.742188, 2) || IsPlayerInRange3D(960.441040, -47.771484, 1001.717163, 1) || IsPlayerInRange3D(508.337006, -84.919502, 999.560913, 1)) {
			;SendChat("/gangwaffen")
			;SendChat("/gheilen")
		;}   else if (IsPlayerInRange3D(-789.212891, 497.180267, 1371.742188, 2) || IsPlayerInRange3D(962.036377, -47.526665, 1001.117188, 1)) {
			
			
		;} else if (IsPlayerInRange3D(-779.651245, 496.748901, 1371.749023, 2) || IsPlayerInRange3D(958.646362, -47.509190, 1001.117188, 1) || IsPlayerInRange3D(505.660675, -81.086975, 999.560913, 1) || IsPlayerInRange3D(-38.989613, 56.992317, 4.055900, 1) ) {
			
			; hier gehts weiter
		;} else if (IsPlayerInRange3D(918.880310,-1463.211670,2754.946045, 1)) {
			;SendChat("/stadthalle")
		;} else if(IsPlayerInRange3D(1339.575806,-1805.219604,13.934590, 2)) {
			;SendChat("/illegalejobs")
		;} else if(IsPlayerInRange3D(311.942413,-165.937866,1000.200989, 2)) {
			;SendChat("/wmenu")
		;} else if (IsPlayerInRange3D(379.6455,1463.2275,1080.1875, 2)) {
			;SendChat("/hausupgrade")
			;Sleep, 100
			;SendInput, {enter}
			;Sleep, 100
			;SendInput, {enter}
			;Sleep, 100
			;SendInput, {enter}
			;Sleep, 100
			;SendInput, 50
			;Sleep, 100
			;SendInput, {enter}
			;Sleep, 100
		;} else if (IsPlayerInRange3D(2374.9397,-1127.2277,1050.8750, 2)) {
			;SendChat("/hausupgrade")
			;Sleep, 100
			;SendInput, {enter}
			;Sleep, 100
			;SendInput, {enter}
			;Sleep, 100
			;SendInput, {enter}
			;Sleep, 100
			;SendInput, 50
			;Sleep, 100
			;SendInput, {enter}
			;Sleep, 100
		; Cali Kartell, Triaden
		;} else if (IsPlayerInRange3D(2349.243896, -1246.729004, 22.608610, 2)) {
			;SendChat("/safebox waffenteile reinlegen " (wdealerpakete * 100) )
		;} else if (IsPlayerInRange3D(1506.614746, -1849.940186, 13.587630, 5)) {
			;SendChat("/illegalejobs")
		;} else if (IsPlayerInRange3D(1228.283447, -1423.370850, 13.554800, 2)) {
			;SendChat("/elektromarkt")
		;} else if (IsPlayerInRange3D(942.981018, -50.991997, 1001.124573, 1)) {
			;SendChat("/gangitem")
		;} else if (IsPlayerInRange3D(-2726.768066, -319.328033, 7.187500, 2)) {
			;SendChat("/automat")
		;}
	}
	return
	
#if IsChatOpen() == 0 && IsDialogOpen() == 0 && IsInMenu() == 0 && isKeybinderAvailable()
; ########################## Custom Keybinds ##########################

	*,::
	if (isKeybinderAvailable(true)) {
		SendChat("/nimmdrogen")
	}	
	return
	
	*.::
	if (isKeybinderAvailable(true)) {
		SendChat("/nimmspice")
	}	
	return

	*^K::
	if (isKeybinderAvailable(true) ) {
		if(KEKSBOT_STATE == 0) {
			AddChatMessage(KEYBINDER_PREFIX "KeksBot aktiviert.")
			KEKSBOT_STATE = 1
		} else {
			AddChatMessage(KEYBINDER_PREFIX "KeksBot deaktiviert.")
			KEKSBOT_STATE = 0
		}
	}
	return
	
	*^R::
	if (isKeybinderAvailable(true) ) {
		SendChat("/frespawn")
	}
	return

	*^::
	if (isKeybinderAvailable(true) ) {
		
		position := getPlayerPos()
		params := "Hilfe [LOCATION]: " position[1] "," position[2] "," position[3]
		
		msg := "" UrlEncode(params) ""
		
		response_str := "request=sendMSG&msg=" msg
		_callAPI(response_str)
		
	}
	return
	
	~Shift::
	if(IsChatOpen() || IsDialogOpen() 1 || Laufscript == 0 || IsInMenu()) {
		return
	}
	Sleep 1
	while GetKeyState("Shift", "P") {
		Send {Shift down}
		Sleep 1
		Send {Shift up}
		Sleep 1
	}
	return 
	
; ########################## HOTSTRINGS ##########################
#if IsChatOpen() == 1 && IsDialogOpen() == 0 && IsInMenu() == 0 && isKeybinderAvailable(true)
	
	getHealthloseWeapon(lost) {
		
		prefix := KEYBINDER_TEXTCOLOR spacer " || Grund: {FF0000}"
		spacer := ""
		
		if (lost > -10 && lost < 10) {
			spacer := " "
		}
		
		if(lost == -3)
			return prefix "Hunger"
		if(lost == -8)
			return prefix  "MP5"
		if(lost == -9 || lost == -10)
			return prefix  "M4/AK47"
		if(lost == -24 || lost == -25)
			return prefix  "Rifle"
		if(lost == -41 || lost == -42)
			return prefix  "Sniper"
		if(lost == -46 || lost == -44)
			return prefix  "Deagle"
		if(lost == -6 || lost == -7)
			return "" ;"Uzi"
		if(lost == -1)
			return "" ;"Tec9"
		if(lost == -5) 
			return prefix "Fallschaden"
		return ""
	}

		
	CheckForUpdate() {
		_sync()
		IniRead, c_ver, %SettingsPath%, Keybinder, Version
		url = https://nichio.de/dl/keys.ini
		v_file = %DirPath%\New_Version.ini
		
		_download_to_file(url, v_file)
		IniRead, n_ver, %v_file%, Keys, Version
		FileDelete, %v_file%
		
		if (n_ver == "ERROR") {
			; #################################################################
				Gui, 4: Show, h200 w500, %KEYBINDER_CLIENTNAME% | Auto-Updater
				Gui, 4: Color, 212121
				
				Gui, 4: font, cWhite
				Gui, 4: font, s18 bold, Arial 

				Gui, 4: add, Text,  x30 y20 , Auto-Updater: Update gefunden.
				Gui, 4: add, Text,  x30 y60 , Downloadserver: Nicht erreichbar.
				Gui, 4: add, Text,  x30 y100 , Update: Fehlgeschlagen.
			; #################################################################
		} else {
			if(c_ver != n_ver) {
			; #################################################################
				Gui, 3: Show, h200 w500, %KEYBINDER_CLIENTNAME% | Auto-Updater
				Gui, 3: Color, 212121
				
				Gui, 3: font, cWhite
				Gui, 3: font, s18 bold, Arial 

				Gui, 3: add, Text,  x30 y20 , Auto-Updater: Update gefunden.
				Gui, 3: add, Text,  x30 y60 , Downloadserver: Erreichbar.
				Gui, 3: add, Text,  x30 y100 , Update: Downloading...
			; #################################################################
			;prog_name = %DirPath%\Nichio %c_ver%.exe
		
			;kb_url = http://nichio.de/dl/nichio.exe
			;kb_name = %DirPath%\Nichio %n_ver%.exe
			;_download_to_file(kb_url, kb_name)
			;FileCreateShortcut, %kb_name%, %A_Desktop%\Nichio.lnk
			
			upd_url = http://nichio.de/dl/installer.exe
			upd_name = %DirPath%\updater.exe
			if (!FileExist(upd_name)) {
				_download_to_file(upd_url, upd_name)
			}
			
			Sleep, 250
			Run, %upd_name%
			ExitApp
			;FileDelete, %prog_name%
			; #################################################################
			Gui, 3: Hide
			; #################################################################
				Gui, 4: Show, h200 w500, %KEYBINDER_CLIENTNAME% | Auto-Updater
				Gui, 4: Color, 212121
				
				Gui, 4: font, cWhite
				Gui, 4: font, s18 bold, Arial 

				Gui, 4: add, Text,  x30 y20 , Auto-Updater: Update gefunden.
				Gui, 4: add, Text,  x30 y60 , Downloadserver: Erreichbar.
				Gui, 4: add, Text,  x30 y100 , Update: Installiert.
			; #################################################################
			Sleep, 2000
			Gui, 4: Hide
			Gui, 3: Hide
			Gui, 5: Hide
			Gui, 1: Hide
			ExitApp
		}
		}
	}
	
	PlayerInput(text){
		s := A_IsSuspended
		Suspend On
		KeyWait Enter
		SendInput t^a{backspace}%text%
		Input, var, v, {enter}
		SendInput ^a{backspace 100}{enter}
		Sleep, 20
		if(!s)
		Suspend Off
		return var
	}
	
	global login_msg_sent := false
	isKeybinderAvailable(offline := false) {
		if (KEYBINDER_STATE == 1) {
			
			if (WinActive("GTA:SA:MP")) {
				
				if (offline) {
					veris := veris + 1
					return true
				}
			
				if (LOGGED_IN == 1) {
					
					if (veris >= 5000) {
						LOGGED_IN := _validate()
						login_msg_sent := false
						veris := 0
					}
					veris := veris + 1
					
					return true
				} else {
					
					if (!login_msg_sent) {
						AddChatMessage(KEYBINDER_PREFIX "Bitte logge dich im Keybinder ein um ihn zu benutzen.")
						login_msg_sent := true
					}
					
					;Sleep, 2000
				}
			}
			
		}
		
		return false
		
	}

	;Function by Wicked
	_download_to_file(u,s){
		static r:=false,request:=comobjcreate("WinHttp.WinHttpRequest.5.1")
		if(!r||request.option(1)!=u)
			request.open("GET",u)
		;request.SetProxy(2, "XXX.XXX.XXX.XXX:PORT") ; IF YOU NEED TO SET YOUR PROXY
		request.send()
		if(request.responsetext="failed"||request.status!=200||comobjtype(request.responsestream)!=0xd)
			return false
		p:=comobjquery(request.responsestream,"{0000000c-0000-0000-C000-000000000046}")
		f:=fileopen(s,"w")
		loop{
			varsetcapacity(b,8192)
			r:=dllcall(numget(numget(p+0)+3*a_ptrsize),ptr,p,ptr,&b,uint,8192, "ptr*",c)
			f.rawwrite(&b,c)
		}until (c=0)
		objrelease(p)
		f.close()
		return request.responsetext
	}
	
	_callAPI(string) {
		
		IniRead, cur_email, %SettingsPATH%, Keybinder, Email
		IniRead, cur_pw, %SettingsPATH%, Keybinder, Password
		
		static r:=false
		
		objWebRequest:= ComObjCreate("WinHttp.WinHttpRequest.5.1")
		
		url := "http://nichio.de/api/" cur_email "/" cur_pw "/" string 
		
		objWebRequest.Open("GET", url)
		
		objWebRequest.Send()
		
		response := objWebRequest.ResponseText
		
		response := JSON.load(response)
		
		return response
		
	}
	
	_login() {
			GuiControlGet, EmailField
			GuiControlGet, PasswordField
			
			
			GuiControl ,, LoginMsg, Initiating...
			IniWrite, %EmailField%, %SettingsPath%, Keybinder, Email
			
			use_password := ""
			
			if (StrLen(PasswordField) < 32) {
				use_password := md5(PasswordField)
				if (StrLen(PasswordField) > 1) {
					IniWrite, %use_password%, %SettingsPath%, Keybinder, Password
				} else {
					empty := ""
					IniWrite, %empty%, %SettingsPath%, Keybinder, Password
				}
			} else {
				use_password := PasswordField
			}
			
			
			GuiControl ,, LoginMsg, Logging-In...
			
			
			if (_validate(EmailField, use_password)) {
				login_msg_sent := false
				LOGGED_IN = 1
				GuiControl ,, LoginMsg, Successfully Logged-In
				Sleep, 500
				GuiControl ,, LoginMsg, Logged in as: %EmailField%
			} else {
				login_msg_sent := false
				LOGGED_IN = 0
				GuiControl ,, LoginMsg, Login failed
			}
		}
		
		_validate(email := "-1", pw := "-1") {
			
		if (email == "-1" || pw == "-1") {
			IniRead, email, %SettingsPATH%, Keybinder, Email
			IniRead, pw, %SettingsPATH%, Keybinder, Password
		}
		
		response := _callAPI("email=" email ":" A_ComputerName "&password=" pw)
		
		if (response.login == 1) {
			return true
		}
			
		return false
	}
	
	_sync() {
		
		; TODO: Check for internet connection
		
		; settings db sync with settings.ini
		if (LOGGED_IN == 1) {
			response_str = request=getWaffendealerpakete:getDrogendealerpakete:getKills:getKillspruch:getGangspruch:getPickspruch:getJaspruch:getNeinspruch
			
			response := _callAPI(response_str)

			Waffen := response.getWaffendealerpakete
			Drogen := response.getDrogendealerpakete
			Kills := response.getKills
			Gang := response.getGangspruch
			Pick := response.getPickspruch
			Kill := response.getKillspruch
			Ja := response.getJaspruch
			Nein := response.getNeinspruch
			
			IniWrite, %Waffen%, %SettingsPATH%, InGame, Waffendealerpakete
			IniWrite, %Drogen%, %SettingsPATH%, InGame, Drogendealerpakete
			IniWrite, %Kills%, %SettingsPATH%, InGame, Kills
			IniWrite, %Gang%, %SettingsPATH%, InGame, Gangspruch
			IniWrite, %Pick%, %SettingsPATH%, InGame, Pickspruch
			IniWrite, %Kill%, %SettingsPATH%, InGame, Killspruch
			IniWrite, %Ja%, %SettingsPATH%, InGame, JaSpruch
			IniWrite, %Nein%, %SettingsPATH%, InGame, NeinSpruch
			
		}
		
	}
	
	_online() {
		; users db
		; msg(getServerName())
		
		if (LOGGED_IN == 1) {
			
			IniRead, cur_email, %SettingsPATH%, Keybinder, Email
			pname := GetUsername()
			server_name := getServerName()
			server_ip := getServerIP()
			server_port := getServerPort()
			str := cur_email ":" A_ComputerName ":" A_UserName ":" pname ":" server_ip ":" server_port ":" server_name

			_callAPI("query=" UrlEncode(str))

		}
	}
	
	_anwalt(string) {
		; hi ali das hier funktioniert iwie nicht ganz empfehle nicht zu benutzen
		if (InStr(string, "Sekunden [Knast]")) {
			if (RegExMatch(string, "(.*) [ID: (.*) Sekunden [Knast]", anwalt)) {
				SendChat("/befreien " getFirstWord(anwalt1))
				_anwalt("lol")
				;msg("found")
			} else {
				;msgbox % string
				;SendChat("/test")
			}
		}
	}
	
	_getCMDbyString(string) {
		;msgbox % string
		Loop, parse, string, `n
		{
			
			if (RegExMatch(A_LoopField, "(.*) /(.*)", cmd)) {
				SendChat( "/" getFirstWord(cmd2) )
			} 
			
			if (RegExMatch(A_LoopField, "(.*)/(.*)" cmd)) {
				SendChat( "/" getFirstWord(cmd2) )
			}
		}
		
	}
	
	md5(string) {    ;   // by SKAN | rewritten by jNizM
		hModule := DllCall("LoadLibrary", "Str", "advapi32.dll", "Ptr")
		, VarSetCapacity(MD5_CTX, 104, 0), DllCall("advapi32\MD5Init", "Ptr", &MD5_CTX)
		, DllCall("advapi32\MD5Update", "Ptr", &MD5_CTX, "AStr", string, "UInt", StrLen(string))
		, DllCall("advapi32\MD5Final", "Ptr", &MD5_CTX)
		loop, 16
			o .= Format("{:02" (case ? "X" : "x") "}", NumGet(MD5_CTX, 87 + A_Index, "UChar"))
		DllCall("FreeLibrary", "Ptr", hModule)
		StringLower, o,o
		return o
	}	
	
	UrlEncode( String ) { ; 	// credit to: https://www.autohotkey.com/board/topic/35660-url-encoding-function/
		OldFormat := A_FormatInteger
		SetFormat, Integer, H

		Loop, Parse, String
		{
			if A_LoopField is alnum
			{
				Out .= A_LoopField
				continue
			}
			Hex := SubStr( Asc( A_LoopField ), 3 )
			Out .= "%" . ( StrLen( Hex ) = 1 ? "0" . Hex : Hex )
		}

		SetFormat, Integer, %OldFormat%

		return Out
	}
	
	