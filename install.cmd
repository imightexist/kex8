@prompt Checks: 
pushd %~dp0
if not exist kexsetup.exe goto a
net session
if %errorlevel%==1 goto b
reg Query "HKLM\Hardware\Description\System\CentralProcessor\0" | find /i "x86" > NUL && set OS=32BIT || set OS=64BIT
if /i %os%==32bit goto c
set version=1.1.1.1375

@prompt Directory: 
"tools\7z.exe" x kexsetup.exe -okex
md "%programfiles%\VxKex"
md "%programfiles%\VxKex\kex32"
md "%programfiles%\VxKex\kex64"
md "%programdata%\VxKex"
md "%programdata%\VxKex\Logs"
cd kex
cd core
copy *.* "%programfiles%\vxkex"
cd..
cd core64
copy *.* "%programfiles%\vxkex"
copy KexDll.* "%windir%\SysWOW64"
cd..
copy kex32 "%programfiles%\vxkex\kex32"
copy kex64 "%programfiles%\vxkex\kex64"
copy kexsetup.exe "%programfiles%\vxkex"
cd..
@prompt Uninstall: 
reg add HKLM\Software\Microsoft\Windows\CurrentVersion\Uninstall\VxKex
reg add HKLM\Software\Microsoft\Windows\CurrentVersion\Uninstall\VxKex /v DisplayName /t REG_SZ /d "VxKex API Extensions for Windows® 7"
reg add HKLM\Software\Microsoft\Windows\CurrentVersion\Uninstall\VxKex /v DisplayVersion /t REG_SZ /d "%version%"
reg add HKLM\Software\Microsoft\Windows\CurrentVersion\Uninstall\VxKex /v Publisher /t REG_SZ /d "vxiiduu"
reg add HKLM\Software\Microsoft\Windows\CurrentVersion\Uninstall\VxKex /v InstallLocation /t REG_SZ /d "%programfiles%\VxKex"
reg add HKLM\Software\Microsoft\Windows\CurrentVersion\Uninstall\VxKex /v UninstallString /t REG_SZ /d "%programfiles%\VxKex\kexsetup.exe /UNINSTALL"
reg add HKLM\Software\Microsoft\Windows\CurrentVersion\Uninstall\VxKex /v NoRepair /t REG_DWORD /d 1
reg add HKLM\Software\Microsoft\Windows\CurrentVersion\Uninstall\VxKex /v NoModify /t REG_DWORD /d 1
@prompt Properties: 
reg add "HKCR\exefile\shellex\PropertySheetHandlers\KexShlEx Property Page" /ve /d "{9AACA888-A5F5-4C01-852E-8A2005C1D45F}"
reg add "HKCR\lnkfile\shellex\PropertySheetHandlers\KexShlEx Property Page" /ve /d "{9AACA888-A5F5-4C01-852E-8A2005C1D45F}"
reg add "HKCR\Msi.Package\shellex\PropertySheetHandlers\KexShlEx Property Page" /ve /d "{9AACA888-A5F5-4C01-852E-8A2005C1D45F}"
reg add HKCR\CLSID\{9AACA888-A5F5-4C01-852E-8A2005C1D45F}\InProcServer32 /ve /d "%programfiles%\VxKex\KexShlEx.dll"
reg add HKCR\CLSID\{9AACA888-A5F5-4C01-852E-8A2005C1D45F}\InProcServer32 /v ThreadingModel /d "Apartment" /t REG_SZ
reg add "HKLM\Software\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\{VxKexPropagationVirtualKey}"
reg add "HKLM\Software\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\{VxKexPropagationVirtualKey}" /v GlobalFlag /t REG_DWORD /d 256
reg add "HKLM\Software\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\{VxKexPropagationVirtualKey}" /v VerifierFlags /t REG_DWORD /d 2147483648
reg add "HKLM\Software\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\{VxKexPropagationVirtualKey}" /v VerifierDlls /t REG_SZ /d "KexDll.dll"
@prompt Settings: 
reg add "HKLM\Software\Vxsoft\VxKex"
reg add "HKCU\Software\Vxsoft\VxKex"
reg add "HKLM\Software\Vxsoft\VxKex" /v InstalledVersion /t REG_SZ /d "0x8000055f"
reg add "HKLM\Software\Vxsoft\VxKex" /v LogDir /t REG_SZ /d "%programdata%\VxKex\Logs"
reg add "HKLM\Software\Vxsoft\VxKex" /v KexDir /t REG_SZ /d "%programfiles%\VxKex"
@prompt CPIW Bypass: 
reg add "HKLM\Software\Microsoft\Windows\CurrentVersion\Explorer\Browser Helper Objects\{7EF224FC-1840-433C-9BCB-2951DE71DDBD}" /ve /d "VxKex CPIW Version Check Bypass"
reg add "HKLM\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\Explorer\Browser Helper Objects\{7EF224FC-1840-433C-9BCB-2951DE71DDBD}" /ve /d "VxKex CPIW Version Check Bypass"
:: todo: read rest of cpiwbypa.c
@prompt Disk Cleanup: 
reg add "HKLM\Software\Microsoft\Windows\CurrentVersion\Explorer\VolumeCaches\VxKex Log Files"
reg add "HKLM\Software\Microsoft\Windows\CurrentVersion\Explorer\VolumeCaches\VxKex Log Files" /v Display /d "VxKex Log Files"
:: todo: read rest of dskclnup.c
@prompt Scheduling task: 
schtasks /create /xml task.xml /tn "VxKex Configuration Elevation Task"
@prompt Done: 
goto exit

:a
@echo Download KexSetup from github.com/vxiiduu/vxkex/releases/latest
@echo The installer must be named kexsetup.exe
start https://github.com/vxiiduu/vxkex/releases/latest
pause
goto exit

:b
@echo Make sure this file is running as Administrator.
pause
goto exit

:c
@echo I'm too lazy to make this work on 32-bit
pause

:exit
@prompt