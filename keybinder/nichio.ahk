; ######################### AutoUpdate & Initiation #########################
	FolderPath = %A_AppData%\Nichio
	SetWorkingDir, %FolderPath%
	;PATH_SAMP_API := PathCombine(A_WorkingDir, "Open-SAMP-API.dll")
	global DirPath := FolderPath
	global SettingsPath := FolderPath "\settings.ini"
	global SAMP_API_PATH := FolderPath "\Open-SAMP-API.dll"
	
	FileCreateDir, %FolderPath%

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
		_download_to_file(api_url, api_name)
	}
	
	I_Icon = %FolderPath%\icon.ico
	;if !FileExist(I_Icon) {
		icon_url = http://nichio.de/dl/icon.ico
		icon_name = %I_Icon%
		_download_to_file(icon_url, icon_name)
	;}
	Menu, Tray, Icon, %I_Icon%
	
	#include JSON.ahk
	#include API.ahk
	
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
	global cWhite = "{FFFFFF}"
	global cYellow = "{FFD700}"
	global cOrange = "{FFA500}"
	global cLime = "{00FF00}"

; ######################### Version Settings #########################
	global KEYBINDER_VERSION = "3.3.9"
	global KEYBINDER_GENERATION = ""
	global KEYBINDER_CLIENTNAME = "Nichio Keybinder"
	global KEYBINDER_CLIENTVERSION = KEYBINDER_GENERATION KEYBINDER_VERSION
	IniWrite, %KEYBINDER_VERSION%, %SettingsPath%, Keybinder, Version
	
; ######################### Auto Updater #########################
	CheckForUpdate()
	
; ######################### Prefix & Colors #########################
	global KEYBINDER_PREFIX = cGray "["  cOrange "Nichio" cBlue "" cGray "] " cWhite
	global KEYBINDER_CHAT = cOrange
	global KEYBINDER_PREFIXERROR = cWhite ">> " cGray "["  cOrange "Nichio" cBlue "" cGray "] " cGray "[" cRed "FEHLER" cGray "]: " cWhite
	global KEYBINDER_PREFIXGREEN = cWhite ">> " cGray "["  cOrange "Nichio" cBlue "" cGray "] " cGreen
	global KEYBINDER_PREFIXRED = cWhite ">> " cGray "["  cOrange "Nichio" cBlue "" cGray "] " cRed
	
; ######################### State #########################	
	global KEYBINDER_STATE := 1
	global LOGGED_IN := 0
	global togglehp = 1
	global Detektiv = 0
	global Locing = 0
	global HANDY_STATE = 1
	global Laufscript = 1
	global autolotto := 1
	
	global WCoding = 0
	
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
	SetTimer, ChatResponder, 100
	SetTimer, PositionListener, 250
	SetTimer, BotLogic, 1000
	
	SetTimer, HPUpdater, 300
	
	SetTimer, Maintenance, 1000
	
	current_gui = 1
	AddChatMessage(KEYBINDER_PREFIXGREEN KEYBINDER_CLIENTNAME " wurde gestartet.")
; ########################## GUI 1 ##########################
	; Titel & GUI
		Gui, 1: Show, h500 w800, %KEYBINDER_CLIENTNAME% | Version: %KEYBINDER_CLIENTVERSION% 
		Gui, 1: Color, 212121

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
		Gui, 1: add, Button, -theme x320 y150 w120 h30 gLogin, Login
		Gui, 1: Add, Text, x450 y150 w400 vLoginMsg, Waiting...
		
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
			GuiControl ,, 5, "wieso_decompilsted_du_mein_keybinder_lol"
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
		
		if (Locing == 1) {
			GetCityName(p_city, 500)
			GetZoneName(p_zone, 500)
			location_string = %p_zone%
			ShowGameText(location_string, 1000, 1)
		}
		
	}
	return
	
	ChatResponder:
	if (KEYBINDER_STATE == KEYBINDER_ONLINE) {
		GetChatLine(0, ChatLine)
		GetChatLine(1, KillLine)
		GetChatLine(2, Gangkillline)
		GetPlayerName(pname, 100)
		
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
		
		If InStr(Gangkillline, "Du hast ein Verbrechen begangen! (Mord an einem Gangmitglied) Reporter: Polizeizentrale") {
			IniRead, PLAYER_KILLS, %SettingsPath%, InGame, Kills
			IniRead, MESSAGE_GANGSPRUCH, %SettingsPath%, InGame, Gangspruch
			PLAYER_KILLS++
			SendChat(MESSAGE_GANGSPRUCH " | Nr. " PLAYER_KILLS)
			ShowGameText("+1 G-Kill", 3000, 5)

			; Call API to +1 Kills
			; Call API to +1 Kills
			response_str = request=setKills&kills=%PLAYER_KILLS%
			_callAPI(response_str)
			
			IniWrite, %PLAYER_KILLS%, %SettingsPath%, InGame, Kills
			Sleep, 500
		}
		
		if InStr(ChatLine, "Sie stehen an einer Zollstation, der Zollübergang kostet $5.000! Befehl: /Zoll") {
			SendChat("/zoll")
			Sleep, 5000
		}
		
		if InStr(ChatLine, "Kaufe dir mit /Lotto ein Lottoticket für $10.000 und versuche dein Glück!") {
			if (autolotto == 1) {
				Random, LottoNummer, 1, 100
				SendChat("/lotto " LottoNummer)
				AddChatMessage("autolotto")
				
				response_str := response_str "useLotto=1" "&"
				msg(KEYBINDER_PREFIX "Es wurde automatisch ein Lotto-Ticket gekauft.")
				
			}
		}
		
		if (RegexMatch(ChatLine, "Spieler " pname " hat sich für (.*) Waffenteile (.*)", usage)) {
			
			msg(KEYBINDER_PREFIX "Du hast " usage1 " Waffenteile benutzt.")
			response_str := response_str "useWT=" usage1 "&"
			
		}
		
		if (InStr(ChatLine, "* " pname " hat sich nen Joint gedreht.")) {
			msg(KEYBINDER_PREFIX "Du hast eine Droge genommen.")
			response_str := response_str "useDrogen=1" "&"
		}
		
		if (ChatLine == "* " pname " nimmt Spice zu sich.") {
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
							msg(KEYBINDER_PREFIX cRed "HP: " cWhite dmg getHealthloseWeapon(dmg) )
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
	if (isKeybinderAvailable()) {
		if(IsPlayerInRange3D(-1857.0846,-1618.0605,21.4436, 5)) {
			SendChat("/paketentladen")
			ShowGameText("+"  (wdealerpakete * 100) " Waffenteile!", 3000, 3)
			Sleep, 10000
		} else if(IsPlayerInRange3D(2348, -2302, 14, 2)) {
			SendChat("/paketeinladen " wdealerpakete)
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
		
			AddChatMessage(cOrange "** Nichio " cWhite response.getNewMSGAuthor cGray ": " cWhite response.getNewMSG cOrange " **")
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

Enter::
		if (!isKeybinderAvailable()) {
			SendInput, {enter}
			return
		}
		
		if (IsDialogOpen()) {
			SendInput, {enter}
		}
		
		clip := ClipboardAll
		Clipboard := ""
		SendInput, {Right}a{BackSpace}^a^c ;^A{Backspace}
		Loop, 20 {
			sleep, 5
			if (Clipboard != "")
				break
		}
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

; ===== "Callback" for evaluation of commands =====

CMDyoyo(params := "") {
	AddChatMessage("sex so viel sex")
	return true
}

CMDtr(params := "") {
	AddChatMessage(KEYBINDER_PREFIX "= ")
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

CMDnc(params := "") {
		
	msg := params
	response_str = request=sendMSG&msg=%msg%
	_callAPI(response_str)
	
	return true
}

CMDhotkeys(params := "") {
	AddChatMessage(cRed "==============" cBlue " KeyBinder Hotkeys " cRed "==============" )
	AddChatMessage(cRed "F2: " cBlue "/carkey" cGray " | | " cRed "F3: " cBlue "/carlock" cGray " | | " cRed "F4: " cBlue "/motor" )
	AddChatmessage(cRed ".: " cBlue "/nimmspice" cGray " | | " cRed ",: " cBlue "/nimmdrogen" cGray " | | " cRed "F12: " cBlue "Keybinder An/Aus")
	AddChatMessage(cRed "X: " cBlue "Handy An/Aus" cGray " | | " cRed "Y: " cBlue "Multifunktionstaste" cGray " | | " cRed "+: " cBlue "Config auslesen" )
	AddChatMessage(cRed "STRG K: " cBlue "KeksBot" cGray " | | " cRed "^: " cBlue "/pickwaffe" cGray " | | " cRed "Shift: " cBlue "Laufscript" )
	AddChatMessage(cRed "STRG R: " cBlue "/frespawn" cGray " | | " cRed "-: " cBlue "-" cGray " | | " cRed "-: " cBlue "-" )
	AddChatMessage(cRed "==========================================" )
	return true
}

CMDbefehle(params := "") {
	AddChatMessage(cRed "==============" cBlue " KeyBinder Befehle " cRed "==============" )
	AddChatMessage(cRed "/ja: " cBlue "Anruf annehmen" cGray " | | " cRed "/nein: " cBlue "Mailbox" cGray " | | " cRed "/auf: " cBlue "Anruf auflegen" )
	AddChatMessage(cRed "/wl: " cBlue "/Waffenlager" cGray " | | " cRed "/sb: " cBlue "/Safebox" cGray " | | " cRed "/fsb: " cBlue "/FSafebox" )
	AddChatMessage(cRed "/find: " cBlue "AutoFind Bot" cGray " | | " cRed "/show: " cBlue "AutoShow Bot" cGray " | | " cRed "/vkwt: " cBlue "Verkaufe WT")
	AddChatMessage(cRed "/rlotto: " cBlue "Random Lotto" cGray " | | " cRed "/inv: " cBlue "/inventar" cGray " | | " cRed "/fin: " cBlue "/finanzen" )
	AddChatMessage(cRed "/location: " cBlue "Location Overlay" cGray " | | " cRed "/autowc: " cBlue "AFK Wantedcodes Farmen" )
	AddChatMessage(cRed "/laufen: " cBlue "Laufscript" cGray " | | " cRed "/vkks: " cBlue "Verkaufe Kekse" cGray " | | " cRed "/laufen: " cBlue "Laufscript")
	AddChatMessage(cRed "/skinid: " cBlue "Gib deine SkinID Aus" cGray " | | " cRed "/m4: " cBlue "Kaufe eine M4" cGray " | | " cRed "/sniper: " cBlue "Kaufe eine AWP" )
	AddChatMessage(cRed "/shotgun: " cBlue "Kaufe eine Shotgun" cGray " | | " cRed "/nc : " cBlue "Nichio-Chat" cGray " | | " cRed "/online: " cBlue "Siehe wer gerade mit dem Keybinder online ist" )
	AddChatMessage(cRed "/autohp: " cBlue "HP Updater umschalten" cGray " | | " cRed "/x : " cBlue "x" cGray " | | " cRed "/x: " cBlue "x" )
	AddChatMessage(cRed "==========================================" )
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

CMDonline(params := "") {
	objWebRequest := ComObjCreate("WinHttp.WinHttpRequest.5.1")
	
	response := _callAPI("request=getOnline")
	
	getOnline := response.getOnline
	
	Loop, Parse, getOnline, `& 
	{
		
		if (A_LoopField != "") {
			AddChatMessage(KEYBINDER_PREFIX "ID: " GetPlayerIDByName(A_LoopField) " - " A_LoopField)
		}
		
	}
	
	; // response wird im format ausgegeben => kensho.nichio&tazsuyo.nichio&
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

CMDchangelog(params := "") {
	AddChatMessage(cRed "================" cBlue " Changelog " cRed "=================" )
	AddChatMessage(cRed "/gangspruch: " cBlue "Gang Killspruch setzen" cGray " | | " cRed "/------: " cBlue "-------------------"  )
	AddChatMessage(cRed "==========================================" )
	return true
}

CMDja(params := "") {
	GetPlayerName(pname, 100)
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
	GetPlayerName(pname, 100)
	SendChat("/abnehmen")
	SendChat("Hier ist die Mailbox von " pname ".")
	SendChat("Du hast 15 Sekunden Zeit mir deine Nachricht mitzuteilen.")
	Sleep, 15000
	SendChat("/auflegen")
	return true
}

CMDauf(params := "") {
	GetPlayerName(pname, 100)
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
	AddChatMessage(KEYBINDER_PREFIX "Skin ID: " GetPlayerSkinId() )
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
	
	GetPlayerPosition(X, Y, Z)
	posstring = %X%, %Y%, %Z%
	
	IniWrite, %posstring%, savedpositions.ini, Position, %first%
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
	F12::
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
	
	F9::
	; Deine Handy-Nummer lautet: 
	SendChat("/elektromarkt")
	Sleep, 100
	SendInput, {down}{down}{down}{down}{enter}
	return
	
#if IsChatOpen() == 0 && IsDialogOpen() == 0 && IsMenuOpen() == 0 && isKeybinderAvailable()
	F2::	
	if (isKeybinderAvailable()) {
		SendChat("/carkey")
		Sleep, 100
	}
	return

	F3::
	if (isKeybinderAvailable() ) {
		SendChat("/carlock")
		Sleep, 100
	}
	return
	
	F4::
	if (isKeybinderAvailable() ) {
		SendChat("/motor")
		SendChat("/licht")
		if (GetVehicleModelId() == 521 || GetVehicleModelId() = 522) {
			SendChat("/helm")
		}
		if (GetVehicleModelID() == 416) {
			SendChat("/flock")
		}
		Sleep, 550
	}
	return
	
	X::
	if (isKeybinderAvailable() ) {
		if(HANDY_STATE == 1) {
			SendChat("/handystatus aus")
			HANDY_STATE = 0
		} else {
			SendChat("/handystatus an")
			HANDY_STATE = 1
		}
	}
	return
	
	#::
	if (isKeybinderAvailable() ) {
		AddChatMessage(cRed "==============" cBlue " KeyBinder Guide " cRed "==============" )
		AddChatMessage(cRed "/befehle: " cBlue "Befehle nachsehen" cGray " | | " cRed "/hotkeys: " cBlue "Hotkeys nachsehen" )
		AddChatMessage(cRed "/changelog: " cBlue "Changelog nachsehen" cGray " | | " cRed "/config: " cBlue "Konfiguriere den Keybinder" )
		AddChatMessage(cRed "==========================================" )
	}
	return
	
	+::
	if (isKeybinderAvailable()) {
		v := KEYBINDER_VERSION
		IniRead, k, %SettingsPath%, InGame, Kills
		IniRead, wt, %SettingsPath%, InGame, Waffendealerpakete
		IniRead, dr, %SettingsPath%, InGame, Drogendealerpakete
		IniRead, ks, %SettingsPath%, InGame, Killspruch
		IniRead, ps, %SettingsPath%, InGame, Pickspruch
		IniRead, js, %SettingsPath%, InGame, JaSpruch
		IniRead, as, %SettingsPath%, InGame, NeinSpruch
		AddChatMessage(KEYBINDER_PREFIX "Version: " v)
		AddChatMessage(KEYBINDER_PREFIX "Waffenpakete: " wt)
		AddChatMessage(KEYBINDER_PREFIX "Drogenpakete: " dr)
		AddChatMessage(KEYBINDER_PREFIX "Killspruch: " ks)
		AddChatMessage(KEYBINDER_PREFIX "Pickspruch: " ps)
		AddChatMessage(KEYBINDER_PREFIX "/Ja Spruch: " js)
		AddChatMessage(KEYBINDER_PREFIX "/auf Spruch: " as)
	}
	return
	
	Y::
	if (isKeybinderAvailable() ) {
		if (IsPlayerInRange3D(-780.301636, 505.897461, 1371.742188, 2) || IsPlayerInRange3D(960.389648, -47.607685, 1001.117188, 1)) {
			SendChat("/gangwaffen")
			SendChat("/gheilen")
		}   else if (IsPlayerInRange3D(-789.212891, 497.180267, 1371.742188, 2) || IsPlayerInRange3D(962.036377, -47.526665, 1001.117188, 1)) {
			SendChat("/FSafebox")
			; entnahme der drogen
			Sleep, 100
			SendInput, {enter}
			Sleep, 100
			SendInput, {down} {enter}
			Sleep, 100
			SendInput, 100 {enter}
			Sleep, 100
			
			; entnahme des spice
			SendInput, {down} {down} {down} {enter}
			Sleep, 100
			SendInput, {down} {enter}
			Sleep, 100
			SendInput, 100 {enter}
			Sleep, 100
			
			; schließen der fsafebox
			SendInput, {escape}
			Sleep, 100
			SendInput, {escape}
			
		} else if (IsPlayerInRange3D(-779.651245, 496.748901, 1371.749023, 2) || IsPlayerInRange3D(958.646362, -47.509190, 1001.117188, 1) ) {
			SendChat("/waffenlager")
			Sleep, 50
			SendInput, {down}
			Sleep, 50
			SendInput, {enter}
			Sleep, 50
			SendInput, {down} {enter}
			Sleep, 50
			SendInput, {down}
			Sleep, 50
			SendInput, {down}
			Sleep, 50
			SendInput, {down}
			Sleep, 50
			SendInput, {down}
			Sleep, 50
			SendInput, {down}
			Sleep, 50
			SendInput, {enter}
			Sleep, 50
			SendInput, {escape}
			Sleep, 50
			SendInput, {escape}
			Sleep, 50
			SendInput, {escape}
		} else if (IsPlayerInRange3D(918.880310,-1463.211670,2754.946045, 1)) {
			SendChat("/stadthalle")
		} else if(IsPlayerInRange3D(1339.575806,-1805.219604,13.934590, 2)) {
			SendChat("/illegalejobs")
		} else if(IsPlayerInRange3D(311.942413,-165.937866,1000.200989, 2)) {
			SendChat("/wmenu")
		} else if (IsPlayerInRange3D(379.6455,1463.2275,1080.1875, 2)) {
			SendChat("/hausupgrade")
			Sleep, 100
			SendInput, {enter}
			Sleep, 100
			SendInput, {enter}
			Sleep, 100
			SendInput, {enter}
			Sleep, 100
			SendInput, 50
			Sleep, 100
			SendInput, {enter}
			Sleep, 100
		} else if (IsPlayerInRange3D(2374.9397,-1127.2277,1050.8750, 2)) {
			SendChat("/hausupgrade")
			Sleep, 100
			SendInput, {enter}
			Sleep, 100
			SendInput, {enter}
			Sleep, 100
			SendInput, {enter}
			Sleep, 100
			SendInput, 50
			Sleep, 100
			SendInput, {enter}
			Sleep, 100
		; Cali Kartell, Triaden
		} else if (IsPlayerInRange3D(2349.243896, -1246.729004, 22.608610, 2)) {
			SendChat("/safebox waffenteile reinlegen " (wdealerpakete * 100) )
		} else if (IsPlayerInRange3D(1506.614746, -1849.940186, 13.587630, 5)) {
			SendChat("/illegalejobs")
		} else if (IsPlayerInRange3D(1228.283447, -1423.370850, 13.554800, 2)) {
			SendChat("/elektromarkt")
		} else if (IsPlayerInRange3D(942.981018, -50.991997, 1001.124573, 1)) {
			SendChat("/gangitem")
		} else if (IsPlayerInRange3D(-2726.768066, -319.328033, 7.187500, 2)) {
			SendChat("/automat")
		}
	}
	return
	
#if IsChatOpen() == 0 && IsDialogOpen() == 0 && IsMenuOpen() == 0 && isKeybinderAvailable()
; ########################## Custom Keybinds ##########################

	,::
	if (isKeybinderAvailable()) {
		SendChat("/nimmdrogen")
	}	
	return
	
	.::
	if (isKeybinderAvailable()) {
		SendChat("/nimmspice")
	}	
	return

	^K::
	if (isKeybinderAvailable() ) {
		if(KEKSBOT_STATE == 0) {
			AddChatMessage(KEYBINDER_PREFIX "KeksBot aktiviert.")
			KEKSBOT_STATE = 1
		} else {
			AddChatMessage(KEYBINDER_PREFIX "KeksBot deaktiviert.")
			KEKSBOT_STATE = 0
		}
	}
	return
	
	^R::
	if (isKeybinderAvailable() ) {
		SendChat("/frespawn")
	}
	return

	^::
	if (isKeybinderAvailable() ) {
		IniRead, p_spruch, %SettingsPath%, InGame, Pickspruch
		SendChat("/pickwaffe")
		SendChat(p_spruch)
	}
	return
	
	~Shift::
	if(IsChatOpen() == 1 || IsDialogOpen() == 1 || Laufscript == 0) {
		return
	}
	Sleep 10
	while GetKeyState("Shift", "P") {
		Send {Shift down}
		Sleep 10
		Send {Shift up}
		Sleep 10
	}
	return 
	
; ########################## HOTSTRINGS ##########################
#if IsChatOpen() == 1 && IsDialogOpen() == 0 && IsMenuOpen() == 0 && isKeybinderAvailable()
	
	getHealthloseWeapon(lost) {
		
		prefix := KEYBINDER_TEXTCOLOR spacer " || Grund?: {FF0000}"
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
			prog_name = %DirPath%\Nichio %c_ver%.exe
		
			kb_url = http://nichio.de/dl/nichio.exe
			kb_name = %DirPath%\Nichio %n_ver%.exe
			_download_to_file(kb_url, kb_name)
			FileCreateShortcut, %kb_name%, %A_Desktop%\Nichio.lnk
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
	isKeybinderAvailable() {
		if (KEYBINDER_STATE == 1) {
			
			if (WinActive("GTA:SA:MP")) {
			;if (true) {
			
				if (LOGGED_IN == 1) {
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
			
			; Saving Data to .ini
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
			
			; Trying Log In
			GuiControl ,, LoginMsg, Logging-In...
			
			; Fail / Success
			if (_validate(EmailField, use_password)) {
				login_msg_sent := false
				LOGGED_IN = 1
				GuiControl ,, LoginMsg, Successfully Logged-In
				Sleep, 500
				GuiControl ,, LoginMsg, Logged in as %EmailField%
			} else {
				login_msg_sent := false
				LOGGED_IN = 0
				GuiControl ,, LoginMsg, Login failed
			}
		}
		
	_validate(email, pw) {
		
		response := _callAPI("email=" email ":" A_ComputerName "&password=" pw)
		
		if (response.login == 1) {
			return true
		}
			
		return false
	}
	
	_sync() {
		
		; Check for internet connection
		
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
		if (LOGGED_IN == 1) {
			
			IniRead, cur_email, %SettingsPATH%, Keybinder, Email
			GetPlayerName(pname, 50)
			str = %cur_email%:%A_ComputerName%:%A_UserName%:%pname%
			
			_callAPI("query=" str)

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
	
	msg(string) {
		AddChatMessage(string)
	}
	
	