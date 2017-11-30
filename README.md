# ![Devil Logo](https://github.com/Kirlovon/Devil-Backdoor/raw/master/icon.ico) Devil Backdoor 

This is a simple backdoor made to control computers in various public places, like school library, internet café, and so on.

## Features
* **Show MessageBox** - allows you to show a window with a message! _(Important: Only English letters are supported)_
* **Execute to CMD** - allows you to run a CMD command on another system!
* **Shutdown** - allows you to turn off the computer!
* **Load File** - allows you to download and run the file on another system! With this function, you can modify and supplement the backdoor capabilities!
* **Crazy Mouse** - the cursor will move to a random position!
* **Block Task Manager** - allows you to block the task manager. This feature can be used to prevent server disconnection.

## How to use it?
#### [Download](https://github.com/Kirlovon/Devil-Backdoor/releases)
### 1. Server setup

First, you need to make sure that all computers are connected to the same shared folder. You must put the **Devil-Server.exe** _(You can rename this file for something less troubling)_ and the **config.ini** _(This file can not be renamed)_ in the same folder, at any place on the hard drive of the computer. 

Now, you must fill **config.ini** file:
```ini
[Config]
ClientID=Client     # There must be an ID (Any meaning or word)
ServerPatch=C:\     # There must be the path to the shared folder
ControlPanelPatch=Devil-ControlPanel.exe    # There must be the path to the Control Panel
AddToStartup=True     # Put there True or False
Speed=50     # The time that the server will wait for next data file check
```

Save the config file, and run **Devil-Server.exe** file! If you put **True** in the **AddToStartup**, after start you should see "_**Devil Server added to start-up**_" message.



### 2. Control Panel using

Run **Devil-ControlPanel.exe**.
If you fill **ControlPanelPatch** option in config file, you can press Hotkey to run Control Panel, _( Default hotkey is **PAUSE** )_ and enter the password specified in the code. _(Default is **QWERTY**)_ <br/>
Next, in the window that appears, select the shared folder. When the interface appears, in the inputbox type the _ClientID_ to select client, that will receive the command.

***
###### Devil-Backdoor project is for informational purposes only! You take full responsibility for using this sofware!
***

