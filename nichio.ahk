#include API.ahk	
	
; ######################### IniRead: InGame #########################
	IniRead, PLAYER_USERNAME, settings.ini, InGame, Username
	IniRead, MESSAGE_KILLSPRUCH, settings.ini, InGame, Killspruch
	IniRead, wdealerpakete, settings.ini, InGame, Waffendealerpakete
	IniRead, DeteCooldown, settings.ini, InGame, DetektivCooldown
	
; ######################### IniRead: Visuals #########################
	KEYBINDER_TEXTCOLOR = {FFFFFF}
	KEYBINDER_SHORTNAME = NichioBinder
	KEYBINDER_HIGHLIGHT = {FF0000}
	KEYBINDER_PREFCOLOR = {FFD700}
	
	cBlue = {0077be}
	cRed ={FF0000}
	cGreen = {00b200} 
	cGray = {D3D3D3}
	cWhite = {FFFFFF}
	cYellow = {FFD700}
	cOrange = {FFA500}
	cLime = {00FF00}

; ######################### Version Settings #########################
	global KEYBINDER_VERSION ="2.5"
	global KEYBINDER_GENERATION = ""
	global KEYBINDER_CLIENTNAME = "Nichio-Binder"
	global KEYBINDER_CLIENTVERSION = KEYBINDER_GENERATION KEYBINDER_VERSION
	IniWrite, %KEYBINDER_VERSION%, settings.ini, Keybinder, Version
	
; ######################### Auto Updater #########################
	; CheckForUpdate()
	
; ######################### Prefix & Colors #########################
	global KEYBINDER_PREFIX = cWhite ">> " cGray "["  cOrange "Nichio" cBlue "" cGray "] " cWhite
	global KEYBINDER_PREFIXERROR = cWhite ">> " cGray "["  cOrange "Nichio" cBlue "" cGray "] " cGray "[" cRed "FEHLER" cGray "]: " cWhite
	global KEYBINDER_PREFIXGREEN = cWhite ">> " cGray "["  cOrange "Nichio" cBlue "" cGray "] " cGreen
	global KEYBINDER_PREFIXRED = cWhite ">> " cGray "["  cOrange "Nichio" cBlue "" cGray "] " cRed
	
; ######################### State #########################	
	global KEYBINDER_STATE := 1
	global togglehp = 1
	global Detektiv = 0
	global Locing = 0
	global KEKSBOT_STATE = 0
	global SPICEBOT_STATE = 0
	global HANDY_STATE =1
	global Laufscript = 1
	global WCoding = 0
	
; ######################### Keybinder levels #########################	
	global KEYBINDER_ONLINE = 1
	global KEYBINDER_OFFLINE = 0
	
; ########################## TIMER ##########################
	SetTimer, KeksBot, 100
	SetTimer, HPUpdater, 100
	SetTimer, Waffendealer,100
	SetTimer, Killz�hler, 100
	SetTimer, DetektivBot, 100
	SetTimer, Locationing, 100
	SetTimer, AutoWcoding, 100
	
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
		Gui, 1: Add, Text, x50 y110 vSTATE w300, KeyBinder: AN                   
		
		Gui, 1: font, s14 bold, Futura-Book 
		Gui, 1: Add, Button, -theme x50 y150 gSettingsClick h30 w200, Settings
		Gui, 1: font, s18 bold cWhite, Futura-Book 
		
	; Edit Boxen
		Gui, 1: Add, text, x50 y230, Killspruch:
		Gui, 1: font, s14 bold cBlack, Futura-Book 
		IniRead, k_s, settings.ini, InGame, Killspruch
		Gui, 1: Add, Edit, x50 y270 h30 w600 vKillSpruch , %k_s%
		Gui, 1: font, s18 bold cWhite, Futura-Book 
		
		Gui, 1: Add, text, x50 y330, Gang-Killspruch:
		Gui, 1: font, s14 bold cBlack, Futura-Book 
		IniRead, g_s, settings.ini, InGame, Gangspruch
		Gui, 1: Add, Edit, x50 y370 h30 w600 vGangSpruch, %g_s%
		Gui, 1: font, s18 bold cWhite, Futura-Book 
		
	; Save Button
		Gui, 1: font, s14 bold cBlack, Futura-Book 
		Gui, 1: Add, Button, -theme x680 y270 w90 h30 gGSave, Save
		Gui, 1: Add, Button, -theme x680 y370 w90 h30 gGSave, Save
	
	; HP & R�stung Progress Bar
		Gui, 1: font, s18 bold cBlack, Futura-Book 
		Gui, 1: Add, Text, w200 x350 y30 vArmorText c00C9FF, Armor:
		Gui, 1: Add, Progress, w400 h20 x350 y70 vArmorBar c89cff0 , 50
		
		Gui, 1: Add, Text, w200 x350 y110 vHealthText cRed, Health:
		Gui, 1: Add, Progress, w400 h20 x350 y150 vHealthBar cRed , 50
		
	; Font 2
		Gui, 1: font, cFFA500
		Gui, 1: font, s18 bold, Futura-Book  

	; StatusBar
		Gui, 1: font, s12 bold, Futura-Book 
		Gui, 1: Add, StatusBar, x0 y0, made by kensho.nichio
	
		
; ########################## GUI 2 ##########################
		
	; Gui 2
		Gui, 2: Show, h400 w700, %KEYBINDER_CLIENTNAME% | Settings
		Gui, 2: Color, 212121
		Gui, 2: Hide
		
	; Font 1
		Gui, 2: font, cWhite
		Gui, 2: font, s14 bold, Futura-Book 
		
	; Save Button
		Gui, 2: add, Button, x250 y350 w200 h30 gSSave, Save Settings
		
	; Settings Links
		Gui, 2: add, Text, x30 y40, Waffenpakete: 
		Gui, 2: font, cBlack
		IniRead, w_p, settings.ini, InGame, Waffendealerpakete
		Gui, 2: add, Edit, x30 y80 w290 h30 v1, %w_p%
		Gui, 2: add, UpDown, vWDUpDown Range1-25, %w_p%
		Gui, 2: font, cWhite
		
		Gui, 2: add, Text, x30 y120, Kills: 
		Gui, 2: font, cBlack
		IniRead, w_p, settings.ini, InGame, Kills
		Gui, 2: add, Edit, x30 y160 w290 h30 v2, %w_p%
		Gui, 2: add, UpDown, vKillsUpDown Range1-9999, %w_p%
		Gui, 2: font, cWhite
		
		Gui, 2: add, Text, x30 y200, Pickspruch: 
		Gui, 2: font, cBlack
		IniRead, w_p, settings.ini, InGame, Pickspruch
		Gui, 2: add, Edit, x30 y240 w290 h30 v3, %w_p%
		Gui, 2: font, cWhite
		
	; Settings Rechts
		Gui, 2: add, Text, x390 y40, Drogenpakete: 
		Gui, 2: font, cBlack
		IniRead, w_p, settings.ini, InGame, Drogendealerpakete
		Gui, 2: add, Edit, x390 y80 w290 h30 v4, %w_p%
		Gui, 2: add, UpDown, vDRUpDown Range1-25, %w_p%
		Gui, 2: font, cWhite
		
		Gui, 2: add, Text, x390 y120, /Ja - Spruch: 
		Gui, 2: font, cBlack
		IniRead, w_p, settings.ini, InGame, JaSpruch
		Gui, 2: add, Edit, x390 y160 w290 h30 v5, %w_p%
		Gui, 2: font, cWhite
		
		Gui, 2: add, Text, x390 y200, /auf - Spruch: 
		Gui, 2: font, cBlack
		IniRead, w_p, settings.ini, InGame, NeinSpruch
		Gui, 2: add, Edit, x390 y240 w290 h30 v6, %w_p%
		Gui, 2: font, cWhite
		
	
	
	return
; ######################### Gui: Functions #########################
		GuiClose:
			AddChatMessage(KEYBINDER_PREFIXRED KEYBINDER_CLIENTNAME " wurde geschlossen.")
			ExitApp
		return
		
		GSave:
			GuiControlGet, KillSpruch
			GuiControlGet, GangSpruch
			IniWrite, %KillSpruch%, settings.ini, InGame, Killspruch
			IniWrite, %GangSpruch%, settings.ini, InGame, Gangspruch
		return
		
		SSave:
			GuiControlGet, 1
			GuiControlGet, 2
			GuiControlGet, 3
			GuiControlGet, 4
			GuiControlGet, 5
			GuiControlGet, 6
			
			IniWrite, %1%, settings.ini, InGame, Waffendealerpakete
			IniWrite, %2%, settings.ini, InGame, Kills
			IniWrite, %3%, settings.ini, InGame, Pickspruch
			IniWrite, %4%, settings.ini, InGame, Drogendealerpakete
			IniWrite, %5%, settings.ini, InGame, JaSpruch
			IniWrite, %6%, settings.ini, InGame, NeinSpruch
		return
		
		SettingsClick:
			Gui, 2: Show
		return
		
; ########################## AUTO-FUNCTIONS ##########################
	
; ######################### HP Updater #########################	
	oldhp := GetPlayerHealth()
	oldarmor := GetPlayerArmor()
	yup = 0
	
	Locationing:
	if (KEYBINDER_STATE == 1) {
		if (Locing == 1) {
			GetCityName(p_city, 500)
			GetZoneName(p_zone, 500)
			location_string = %p_zone%
			ShowGameText(location_string, 2000, 1)
		}
	}
	return
	
	AutoWcoding:
	if (WCoding == 0) 
		return
	SendChat("/wcodes")
	Sleep, 1200000
	return
	
	DetektivBot:
	if (KEYBINDER_STATE == 1) {
		IniRead, helper, settings.ini, InGame, Helfer
		IniRead, target, settings.ini, InGame, Target
		if (Detektiv == 1) {
			SendChat("/dfinden " target)
			Sleep, 10000
		} else if (Detektiv == 2) {
			SendChat("/dzeigen " helper " " target)
			Sleep, 10000
		}
	}
	return
	
	HPUpdater:
	if (KEYBINDER_STATE == 1 && togglehp == 1) {
		newhp := GetPlayerHealth()
		newarmor := GetPlayerArmor()
			
			; HP ###############################################
			if (newhp != oldhp) {
				dmg := (oldhp - newhp)
				
				if (dmg != 2139094940 && dmg != -2139094940 && dmg != "") {
					if (dmg > 0) {
						;ShowGameText(getHealthloseWeapon(oldhp - newhp), 1000, 1)
						AddChatMessage(KEYBINDER_PREFIX "{FF0000}HP: " (-1 * (oldhp - newhp)) KEYBINDER_TEXTCOLOR " || Wahrscheinlicher Grund: {FF0000}" getHealthloseWeapon(oldhp - newhp) )
						yup = 1
					}
				}
				
				oldhp := GetPlayerHealth()
				
			}
			
			; Armor ###############################################
			if (oldarmor != newarmor) {
				
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
	
	Killz�hler:
	if (KEYBINDER_STATE == KEYBINDER_ONLINE) {
		GetChatLine(1, KillLine)
		If InStr(KillLine, "Du hast ein Verbrechen begangen! (Beamten/Zivilisten Mord) Reporter: Polizeizentrale") {
			IniRead, PLAYER_KILLS, settings.ini, InGame, Kills
			IniRead, MESSAGE_KILLSPRUCH, settings.ini, InGame, Killspruch
			PLAYER_KILLS++
			SendChat(MESSAGE_KILLSPRUCH " | Nr. " PLAYER_KILLS)
			ShowGameText("+1 Kill", 3000, 5)
			IniWrite, %PLAYER_KILLS%, settings.ini, InGame, Kills
			Sleep, 500
		}
		If InStr(KillLine, "Du hast ein Verbrechen begangen! (Mord an einem Gangmitglied) Reporter: Polizeizentrale") {
			IniRead, PLAYER_KILLS, settings.ini, InGame, Kills
			IniRead, MESSAGE_GANGSPRUCH, settings.ini, InGame, Gangspruch
			PLAYER_KILLS++
			SendChat(MESSAGE_GANGSPRUCH " | Nr. " PLAYER_KILLS)
			ShowGameText("+1 G-Kill", 3000, 5)
			IniWrite, %PLAYER_KILLS%, settings.ini, InGame, Kills
			Sleep, 500
		}
		
		; AutoZoll
		GetChatLine(0, ZollLine)
		if InStr(ZollLine, "Sie stehen an einer Zollstation, der Zoll�bergang kostet $500! Befehl: /Zoll") {
			SendChat("/zoll")
			Sleep, 5000
		}
		
		c_HP := GetPlayerHealth()
		c_AR := GetPlayerArmor()
		GuiControl,, HealthBar, %c_HP%
		GuiControl,, HealthText, Health: %c_HP%
		GuiControl,, ArmorBar, %c_AR%
		GuiControl,, ArmorText, Armor: %c_AR%
	}
	return
	
	KeksBot:
	if (KEYBINDER_STATE == 1 ) {
		if (KEKSBOT_STATE == KEYBINDER_ONLINE) {
			
			while(GetPlayerHealth() < 90) {
				i = 6
				while (i != 0) {
					if (KEKSBOT_STATE == 0) {
						return
					}
					
					if (GetPlayerHealth() > 90 || GetPlayerHealth() == 90) {
						AddChatMessage(KEYBINDER_PREFIXERROR "Du hast zu viele HP um Kekse zu essen!")
						AddChatMessage(KEYBINDER_PREFIX "Der KeksBot wurde deaktiviert.")
						KEKSBOT_STATE = 0
						return
					}
					SendChat("/isskeks")
					Sleep, 100
					i--
				}
				Sleep, 7000
			}
			
			if (GetPlayerHealth() > 90 || GetPlayerHealth() == 90) {
				AddChatMessage(KEYBINDER_PREFIXERROR "Du hast zu viele HP um Kekse zu essen!")
				AddChatMessage(KEYBINDER_PREFIX "Der KeksBot wurde deaktiviert.")
				KEKSBOT_STATE = 0
				return
			}
			
		}
	}
	return
	
	Waffendealer:
	if (KEYBINDER_STATE == 1) {
		if(IsPlayerInRange3D(-1857.0846,-1618.0605,21.4436, 5)) {
				SendChat("/paketentladen")
				ShowGameText("+"  (wdealerpakete * 100) " Waffenteile!", 3000, 3)
				Sleep, 10000
			} else if(IsPlayerInRange3D(2348, -2302, 14, 2)) {
				SendChat("/paketeinladen " wdealerpakete)
				Sleep, 3000
			}
	}
	return
	
; ########################## KEYBINDINGS ##########################
	F12::
	if (KEYBINDER_STATE == 1 ) {
		AddChatMessage(KEYBINDER_PREFIXRED KEYBINDER_CLIENTNAME " Keybinder deaktiviert.")
		GuiControl,, STATE, KeyBinder: AUS
		KEYBINDER_STATE := KEYBINDER_OFFLINE
	} else {
		AddChatMessage(KEYBINDER_PREFIXGREEN KEYBINDER_CLIENTNAME " Keybinder aktiviert.")
		GuiControl,, STATE, KeyBinder: AN
		KEYBINDER_STATE := KEYBINDER_ONLINE
	}
	return
	
#if IsChatOpen() == 0 && IsDialogOpen() == 0 && IsMenuOpen() == 0 && KEYBINDER_STATE == 1
	F2::	
	if (KEYBINDER_STATE == 1 ) {
		SendChat("/carkey")
		Sleep, 100
	}
	return

	F3::
	if (KEYBINDER_STATE == 1 ) {
		SendChat("/carlock")
		Sleep, 100
	}
	return
	
	F4::
	if (KEYBINDER_STATE == 1 ) {
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
	
	F12::
	if (KEYBINDER_STATE == 1 ) {
		SendChat("/safebox waffenteile reinlegen " (wdealerpakete * 100) )
	}
	return
	
	X::
	if (KEYBINDER_STATE == 1 ) {
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
	if (KEYBINDER_STATE == 1 ) {
		AddChatMessage(cRed "==============" cBlue " KeyBinder Guide " cRed "==============" )
		AddChatMessage(cRed "/befehle: " cBlue "Befehle nachsehen" cGray " | | " cRed "/hotkeys: " cBlue "Hotkeys nachsehen" )
		AddChatMessage(cRed "/changelog: " cBlue "Changelog nachsehen" cGray " | | " cRed "/config: " cBlue "Konfiguriere den Keybinder" )
		AddChatMessage(cRed "==========================================" )
	}
	return
	
	+::
	if (KEYBINDER_STATE == 1) {
		v := KEYBINDER_VERSION
		IniRead, k, settings.ini, InGame, Kills
		IniRead, wt, settings.ini, InGame, Waffendealerpakete
		IniRead, dr, settings.ini, InGame, Drogendealerpakete
		IniRead, ks, settings.ini, InGame, Killspruch
		IniRead, ps, settings.ini, InGame, Pickspruch
		IniRead, js, settings.ini, InGame, JaSpruch
		IniRead, as, settings.ini, InGame, NeinSpruch
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
	if (KEYBINDER_STATE == 1 ) {
		if (IsPlayerInRange3D(330.9746,1128.3850,1083.8828, 2)) {
			SendChat("/gangwaffen")
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
		}
	}
	return
	
	NumpadSub::
	if (KEYBINDER_STATE == 1) {
		SendChat("/nimmdrogen")
	}	
	return
	
	NumpadAdd::
	if (KEYBINDER_STATE == 1) {
		SendChat("/nimmspice")
	}	
	return
	
; ########################## Custom Keybinds ##########################
#if IsChatOpen() == 0 && IsDialogOpen() == 0 && IsMenuOpen() == 0 && KEYBINDER_STATE == 1

	^K::
	if (KEYBINDER_STATE == 1 ) {
		if(KEKSBOT_STATE == 0) {
			AddChatMessage(KEYBINDER_PREFIX "KeksBot aktiviert.")
			KEKSBOT_STATE = 1
		} else {
			AddChatMessage(KEYBINDER_PREFIX "KeksBot deaktiviert.")
			KEKSBOT_STATE = 0
		}
	}
	return

	^::
	if (KEYBINDER_STATE == 1 ) {
		IniRead, p_spruch, settings.ini, InGame, Pickspruch
		SendChat("/pickwaffe")
		SendChat(p_spruch)
	}
	return
	
	~Shift::
	if(IsChatOpen() == 1 || IsDialogOpen() == 1 || Laufscript == 0) {
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
#if IsChatOpen() == 1 && IsDialogOpen() == 0 && IsMenuOpen() == 0 && KEYBINDER_STATE == 1
	:?:/hotkeys::
	if (KEYBINDER_STATE == 1) {
		AddChatMessage(cRed "==============" cBlue " KeyBinder Guide " cRed "==============" )
		AddChatMessage(cRed "F2: " cBlue "/carkey" cGray " | | " cRed "F3: " cBlue "/carlock" cGray " | | " cRed "F4: " cBlue "/motor" )
		AddChatmessage(cRed "NP-: " cBlue "/nimmspice" cGray " | | " cRed "NP+: " cBlue "/nimmdrogen" cGray " | | " cRed "F12: " cBlue "Keybinder An/Aus")
		AddChatMessage(cRed "X: " cBlue "Handy An/Aus" cGray " | | " cRed "Y: " cBlue "Multifunktionstaste" cGray " | | " cRed "+: " cBlue "Config auslesen" )
		AddChatMessage(cRed "STRG K: " cBlue "KeksBot" cGray " | | " cRed "^: " cBlue "/pickwaffe" cGray " | | " cRed "Shift: " cBlue "Laufscript" )
		AddChatMessage(cRed "==========================================" )
	}
	return
	
	:?:/befehle::
	if (KEYBINDER_STATE == 1) {
		AddChatMessage(cRed "==============" cBlue " KeyBinder Guide " cRed "==============" )
		AddChatMessage(cRed "/ja: " cBlue "Anruf annehmen" cGray " | | " cRed "/nein: " cBlue "Mailbox" cGray " | | " cRed "/auf: " cBlue "Anruf auflegen" )
		AddChatMessage(cRed "/h: " cBlue "Setzte dein Helfer fest" cGray " | | " cRed "/t: " cBlue "Setzte dein Ziel fest" )
		AddChatMessage(cRed "/find: " cBlue "AutoFind Bot" cGray " | | " cRed "/show: " cBlue "AutoShow Bot" cGray " | | " cRed "/vkwt: " cBlue "Verkaufe WT")
		AddChatMessage(cRed "/rlotto: " cBlue "Random Lotto" cGray " | | " cRed "/inv: " cBlue "/inventar" cGray " | | " cRed "/fin: " cBlue "/finanzen" )
		AddChatMessage(cRed "/location: " cBlue "Location Overlay" cGray " | | " cRed "/relog: " cBlue "Start dein Spiel neu" )
		AddChatMessage(cRed "/laufen: " cBlue "Laufscript" cGray " | | " cRed "/rechner: " cBlue "Rechne etwas aus"  )
		AddChatMessage(cRed "==========================================" )
	}
	return
	
	:?:/config::
	if (KEYBINDER_STATE == 1) {
		AddChatMessage(cRed "==============" cBlue " KeyBinder Guide " cRed "==============" )
		AddChatMessage(cRed "/killspruch: " cBlue "Killspruch setzen" cGray " | | " cRed "/waffendealer: " cBlue "WaffendealerBot" )
		AddChatMessage(cRed "/kills: " cBlue "Setze deine Kills fest" cGray " | | " cRed "/gangspruch " cBlue "Gang Killspruch setzen."  )
		AddChatMessage(cRed "/laufen: " cBlue "Laufscript" cGray " | | " cRed "/pickspruch: " cBlue "Pickspruch festlegen"  )
		AddChatMessage(cRed "/jaspruch: " cBlue "/ja > Spruch" cGray " | | " cRed "/aufspruch: " cBlue "/auf > Spruch"  )
		AddChatMessage(cRed "==========================================" )
	}
	return
	
	:?:/changelog::
	if (KEYBINDER_STATE == 1) {
		AddChatMessage(cRed "================" cBlue " Changelog " cRed "=================" )
		AddChatMessage(cRed "/gangspruch: " cBlue "Gang Killspruch setzen" cGray " | | " cRed "/------: " cBlue "-------------------"  )
		AddChatMessage(cRed "==========================================" )
	}
	return

	:?:/ja::
	if (KEYBINDER_STATE == 1 ) {
		GetPlayerName(pname, 100)
		SendChat("/abnehmen")
		IniRead, spruch, settings.ini, InGame, JaSpruch
		if (spruch == "ERROR") {
			SendChat("Guten Tag! " pname " am Apparat.")
			SendChat("Wie kann ich dir helfen?")
		} else {
			SendChat(spruch)
		}
	}
	return
	
	:?:/nein::
	if (KEYBINDER_STATE == 1 ) {
		GetPlayerName(pname, 100)
		SendChat("/abnehmen")
		SendChat("Hier ist die Mailbox von " pname ".")
		SendChat("Du hast 15 Sekunden Zeit mir deine Nachricht mitzuteilen.")
		Sleep, 15000
		SendChat("/auflegen")
	}
	return
	
	:?:/auf::
	if (KEYBINDER_STATE == 1 ) {
		GetPlayerName(pname, 100)
		IniRead, spruch, settings.ini, InGame, NeinSpruch
		if (spruch == "ERROR") {
			SendChat("Ich w�nsche ihnen noch einen angenehmen Tag.")
			SendChat("Mit freundlichen Gr��en " pname ".")
		} else {
			SendChat(spruch)
		}
		SendChat("/auflegen")
	}
	return
	
	:?:/rlotto::
	if (KEYBINDER_STATE == 1 ) {
		Random, randLotto, 0, 100
		SendChat("/lotto " randLotto)
	}
	return
	
	:?:/fin::
	if (KEYBINDER_STATE == 1 ) {
		SendChat("/finanzen")
	}
	return
	
	:?:/inv::
	if (KEYBINDER_STATE == 1 ) {
		SendChat("/inventar")
	}
	return

	:?:/skinid::
	if (KEYBINDER_STATE == 1 ) {
		AddChatMessage(KEYBINDER_PREFIX "Skin ID: " GetPlayerSkinId() )
	}
	return
	
	:?:/h::
	if (KEYBINDER_STATE == 1 ) {
		helfer := PlayerInput("Helfer: ")
		AddChatMessage(KEYBINDER_PREFIX "Dein Helfer ist nun: " helfer )
		IniWrite, %helfer%, settings.ini, InGame, Helfer
	}
	return
	
	:?:/t::
	if (KEYBINDER_STATE == 1 ) {
		target := PlayerInput("Target: ")
		AddChatMessage(KEYBINDER_PREFIX "Dein Ziel ist nun: " target )
		IniWrite, %target%, settings.ini, InGame, Target
	}
	return
	
	:?:/location::
	if (KEYBINDER_STATE == 1 ) {
		if (Locing == 0) {
			AddChatMessage(KEYBINDER_PREFIX "Location Updater wurde aktiviert.")
			Locing = 1
		} else {
			AddChatMessage(KEYBINDER_PREFIX "Location Updater wurde deaktiviert.")
			Locing = 0
		}
	}	
	return
	
	:?:/find::
	if (KEYBINDER_STATE == 1 ) {
		if (Detektiv != 1) {
			Detektiv = 1
			AddChatMessage(KEYBINDER_PREFIX "DetektivBot (AutoFind) wurde aktiviert.")
		} else {
			Detektiv = 0
			AddChatMessage(KEYBINDER_PREFIX "DetektivBot wurde deaktiviert.")
		}
	}
	return
	
	:?:/show::
	if (KEYBINDER_STATE == 1 ) {
		if (Detektiv != 2) {
			Detektiv = 2
			AddChatMessage(KEYBINDER_PREFIX "DetektivBot (AutoShow) wurde aktiviert.")
		} else {
			Detektiv = 0
			AddChatMessage(KEYBINDER_PREFIX "DetektivBot wurde deaktiviert.")
		}
	}
	return
	
	:?:/kills::
	if (KEYBINDER_STATE == 1 ) {
		kills := PlayerInput("Kills: ")
		AddChatMessage(KEYBINDER_PREFIX "Deine Kills wurden auf " kills " gesetzt." )
		IniWrite, %kills%, settings.ini, InGame, Kills
	}
	return
	
	:?:/killspruch::
	if (KEYBINDER_STATE == 1 ) {
		kills := PlayerInput("Killspruch: ")
		AddChatMessage(KEYBINDER_PREFIX "Dein Killspruch wurde auf " kills " gesetzt." )
		IniWrite, %kills%, settings.ini, InGame, Killspruch
	}
	return
	
	:?:/gangspruch::
	if (KEYBINDER_STATE == 1 ) {
		kills := PlayerInput("Gang Killspruch: ")
		AddChatMessage(KEYBINDER_PREFIX "Dein Gang-Killspruch wurde auf " kills " gesetzt." )
		IniWrite, %kills%, settings.ini, InGame, Gangspruch
	}
	return
	
	:?:/pickspruch::
	if (KEYBINDER_STATE == 1 ) {
		kills := PlayerInput("Pickspruch: ")
		AddChatMessage(KEYBINDER_PREFIX "Dein Pickspruch wurde auf " kills " gesetzt." )
		IniWrite, %kills%, settings.ini, InGame, Pickspruch
	}
	return
	
	:?:/jaspruch::
	if (KEYBINDER_STATE == 1 ) {
		kills := PlayerInput("/Ja Spruch: ")
		AddChatMessage(KEYBINDER_PREFIX "Dein /ja Spruch wurde auf " kills " gesetzt." )
		IniWrite, %kills%, settings.ini, InGame, JaSpruch
	}
	return
	
	:?:/aufspruch::
	if (KEYBINDER_STATE == 1 ) {
		kills := PlayerInput("/nein Spruch: ")
		AddChatMessage(KEYBINDER_PREFIX "Dein /nein Spruch wurde auf " kills " gesetzt." )
		IniWrite, %kills%, settings.ini, InGame, NeinSpruch
	}
	return
	
	:?:/waffendealer::
	if (KEYBINDER_STATE == 1 ) {
		kills := PlayerInput("Pakete: ")
		AddChatMessage(KEYBINDER_PREFIX "Deine Pakete wurden auf " kills " gesetzt." )
		IniWrite, %kills%, settings.ini, InGame, Waffendealerpakete
	}
	return
	
	:?:/savepos::
	if (KEYBINDER_STATE == 1 ) {
		kills := PlayerInput("Positionsname: ")
		AddChatMessage(KEYBINDER_PREFIX "Deine Position " kills " wurde gespeichert." )
		
		GetPlayerPosition(X, Y, Z)
		posstring = %X%, %Y%, %Z%
		
		IniWrite, %posstring%, savedpositions.ini, Position, %kills%
	}
	return
	
	:?:/vkwt::
	if (KEYBINDER_STATE == 1 ) {
		anzahl  := PlayerInput("Waffenteile: ")
		kunde  := PlayerInput("K�ufer: ")
		SendChat("/sellwaffenteile " kunde " " anzahl " " (anzahl * 25) )
	}
	return
	
	:?:/vkks::
	if (KEYBINDER_STATE == 1) {
		anzahl := PlayerInput("Kekse: ")
		kunde := PlayerInput("K�ufer: ")
		SendChat("/sellkekse " kunde " " anzahl " " (anzahl * 45))
	}
	return
	
	:?:/autowc::
	if (WCoding == 0) {
		WCoding = 1
		AddChatMessage("On")
	} else {
		WCoding = 0
	AddChatMessage("Off")
	}
	return
	
	:?:/laufen::
	if (KEYBINDER_STATE == 1) {
		if (Laufscript == 1) {
			AddChatMessage(KEYBINDER_PREFIX "Laufscript wurde deaktiviert.")
			Laufscript = 0
		} else {
			AddChatMessage(KEYBINDER_PREFIX "Laufscript wurde aktiviert.")
			Laufscript = 1
		}
	}
	return
	
	:?:/version::
	if (KEYBINDER_STATE == 1) {
		v := KEYBINDER_VERSION
		AddChatMessage(KEYBINDER_PREFIX "Version: " v)
	}
	return
	
	getHealthloseWeapon(lost) {
		if(lost == 3)
			return "Hunger"
		if(lost == 8)
			return "MP5"
		if(lost == 9 || lost == 10)
			return "M4/AK47"
		if(lost == 24 || lost == 25)
			return "Rifle"
		if(lost == 41 || lost == 42)
			return "Sniper"
		if(lost == 46 || lost == 44)
			return "Deagle"
		if(lost == 6 || lost == 7)
			return "Uzi"
		if(lost == 1)
			return "Tec9"
		if(lost == 5) 
			return "Fallschaden"
		return "Unbekannt"
	}

		
	CheckForUpdate() {
		IniRead, c_ver, settings.ini, Keybinder, Version
		url = http://easy.bplaced.net/ahk/nichiobinder/keys.ini
		v_file = New_Version.ini
		
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
			prog_name = Nichio %c_ver%.exe
		
			kb_url = http://easy.bplaced.net/ahk/nichiobinder/nichio.exe
			kb_name = Nichio %n_ver%.exe
			_download_to_file(kb_url, kb_name)
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
	
	
	