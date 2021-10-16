; ######################### AutoUpdate & Initiation #########################
	FolderPath = %A_AppData%\Nichio
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
	if !FileExist(I_Icon) {
		icon_url = http://nichio.de/dl/icon.ico
		icon_name = %I_Icon%
		_download_to_file(icon_url, icon_name)
	}
	Menu, Tray, Icon, %I_Icon%
	
	#include JSON.ahk
	
	
	
; ######################### IniRead: InGame #########################
	IniRead, PLAYER_USERNAME, %SettingsPath%, InGame, Username
	IniRead, MESSAGE_KILLSPRUCH, %SettingsPath%, InGame, Killspruch
	IniRead, wdealerpakete, %SettingsPath%, InGame, Waffendealerpakete
	IniRead, DeteCooldown, %SettingsPath%, InGame, DetektivCooldown
	
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
	global KEYBINDER_VERSION ="0.0"
	global KEYBINDER_GENERATION = ""
	global KEYBINDER_CLIENTNAME = "Nichio-Binder"
	global KEYBINDER_CLIENTVERSION = KEYBINDER_GENERATION KEYBINDER_VERSION
	IniWrite, %KEYBINDER_VERSION%, %SettingsPath%, Keybinder, Version
	
; ######################### Auto Updater #########################
	CheckForUpdate()
	
; ######################### Prefix & Colors #########################
	global KEYBINDER_PREFIX = cWhite ">> " cGray "["  cOrange "Nichio" cBlue "" cGray "] " cWhite
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
	global KEKSBOT_STATE = 0
	global SPICEBOT_STATE = 0
	global HANDY_STATE =1
	global Laufscript = 1
	global WCoding = 0
	global AC_COMPATIBILITY = 0
	
	Time := A_NowUTC
	EnvSub, Time, 19700101000000, Seconds	; bro kp was hier passiert akzeptier es einfach für unix timestamp lol					
	global CHAT_TIMESTAMP := Time
	
	global sync_timer = 0
	
; ######################### Keybinder levels #########################	
	global KEYBINDER_ONLINE = 1
	global KEYBINDER_OFFLINE = 0
	
; ########################## TIMER ##########################
	
	current_gui = 1
		
; ########################## AUTO-FUNCTIONS ##########################
		
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
			FileDelete, %prog_name%
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
	
	isKeybinderAvailable() {
		if (KEYBINDER_STATE == 1) {
			
			if (LOGGED_IN == 1) {
				return true
			} else {
				;AddChatMessage(KEYBINDER_PREFIX "Bitte logge dich im Keybinder ein um ihn zu benutzen.")
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
				LOGGED_IN = 1
				GuiControl ,, LoginMsg, Successfully Logged-In
				Sleep, 500
				GuiControl ,, LoginMsg, Logged in as %EmailField%
			} else {
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
			
			;IniRead, cur_email, %SettingsPATH%, Keybinder, Email
			;GetPlayerName(pname, 50)
			;str = %cur_email%:%A_ComputerName%:%A_UserName%:%pname%
			
			;_callAPI("query=" str)

		}
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
	
	