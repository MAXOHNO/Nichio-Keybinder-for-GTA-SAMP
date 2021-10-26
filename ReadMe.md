# Project
This AutoHotKey Keybinder was made for the German GTA San Andreas: Multiplayer Roleplay Server called LiveYourLife Realife (previously: LiveYourDream Roleplay).

# Requirements:
SAMP: v0.3.7 R1 (doesn't work with R2,R3,R4)  
(To Edit the Keybinder: AHK ANSI 32Bit)

Visit the Wiki at the top for more help on using the Keybinder

# Keybinder
![image](https://user-images.githubusercontent.com/31670615/137601590-051cf4e3-502b-4b7e-a1d6-6bb7ca37893f.png)

# Website
![image](https://user-images.githubusercontent.com/31670615/137601640-dba9611a-7fde-412d-9e07-d4a1be436352.png)

# WIKI

## Keybinder Help
### Setup

To setup your keybinder visit the Account page on Nichio.de
#### Hotkeys

F2: /carkey
F3: /carlock
F4: /motor
F12: Disable / Enable Keybinder
X: /handystatus <an/aus>
Y: Multifunktionstaste
.: /nimmspice
,: /nimmdrogen
STRG + R: /frespawn
^: /pickwaffe

#### Commands
/autohp: Disable/Enable HP Updater in Chat
/autolotto: Automatically buy a /lotto ticket
/nc: Write into the Nichio Chat
/hotkeys
/befehle
/config
/online
/wl
/fsb
/sb
/m4
/shotgun
/sniper
/ja
/nein
/auf
/rlotto
/fin
/inv
/skinid
/h
/t
/find
/show
/location
/savepos
/vkwt
/vkks
/autowc
/laufen
/version

#### Features:
Kill Counter
Auto-/Zoll
Auto-r/lotto
Waffenteile, Spice & Drogen Nutzug
HP Updater in Chat
Positionlistener
Nichio Chat


#### API Usage
(the URL used in the examples will be "nichio.de", however, if you host it yourself you need to replace it with your own and change it in the script)
To use the API you must use a valid account, then follow in this format
https://nichio.de/api/my@email.com/my_password123/
note: you need to submit your password hashed in MD5 This will return a JSON containing the key "login" and whether the login was successfuly or not (true or false).
https://i.gyazo.com/5fc8a0f68feeee5dccd4726d5833b1ae.png
To make more use out of the API you for example request who is online by visiting this URL
https://nichio.de/api/my@email.com/my_password123/request=getOnline
This will return a JSON containing the key getOnline containing the Value of all the users who are online seperated by a &.
example_getOnline

#### MySQL Setup

Following MySQL Tables are required for the databse:

##### chat

UUID (varchar255) | MESSAGE (varchar255) | TIMESTAMP (double)

##### settings

UUID (varchar255) | WAFFENDEALERPAKETE (integer) | DROGENDEALERPAKETE (integer) | KILLS (integer) | KILLSPRUCH (varchar255) | GANGSPRUCH (varchar255) | PICKSPRUCH (varchar255) | JASPRUCH (varchar255) | NEINSPRUCH (varchar255)

##### stats

UUID (varchar255) | LOTTOS (integer) | USEWT (integer) | USEDROGEN (integer) | USESPICE (integer)

##### users

COMPUTERNAME (varchar255) | USERNAME (varchar255) | INGAMENAME (varchar255) | IP (varchar255) | LAST_ONLINE (integer) | PLAYTIME (integer) | EMAIL (varchar255) | PASSWORD (varchar255) | UUID (varchar255) | LOGINTOKEN (varchar255)
