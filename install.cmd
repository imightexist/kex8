@prompt Checks: 
pushd %~dp0
if not exist kexsetup.exe goto a
net session
if %errorlevel%==1 goto b
reg Query "HKLM\Hardware\Description\System\CentralProcessor\0" | find /i "x86" > NUL && set OS=32BIT || set OS=64BIT
if /i %os%==32bit goto c
set version=1.1.1.1375

@prompt Directory: 
"tools\7z.exe" x kexsetup.exe -okex -aoa
md "%programfiles%\VxKex"
md "%programfiles%\VxKex\kex32"
md "%programfiles%\VxKex\kex64"
md "%programdata%\VxKex"
md "%programdata%\VxKex\Logs"
cd kex
cd core
copy *.* "%programfiles%\vxkex"
cd..
cd core32
copy CpiwBypa.dll "%programfiles%\vxkex\CpiwBp32.dll"
copy KexShlEx.dll "%programfiles%\vxkex\KexShl32.dll"
copy KexDll.* "%windir%\syswow64"
cd..
cd core64
copy *.* "%programfiles%\vxkex"
copy KexDll.* "%windir%\system32"
cd..
copy kex32 "%programfiles%\vxkex\kex32"
copy kex64 "%programfiles%\vxkex\kex64"
copy kexsetup.* "%programfiles%\vxkex"
cd..
@prompt Settings: 
echo y | reg add "HKLM\Software\Vxsoft\VxKex"
echo y | reg add "HKCU\Software\Vxsoft\VxKex"
echo y | reg add "HKLM\Software\Vxsoft\VxKex" /v InstalledVersion /t REG_SZ /d "0x8000055f"
echo y | reg add "HKLM\Software\Vxsoft\VxKex" /v LogDir /t REG_SZ /d "%programdata%\VxKex\Logs"
echo y | reg add "HKLM\Software\Vxsoft\VxKex" /v KexDir /t REG_SZ /d "%programfiles%\VxKex"
echo y | reg add "HKCU\Software\Vxsoft\VxKex" /v LogDir /t REG_SZ /d "%localappdata%\VxKex\Logs"
@prompt Propagation Virtual: 
echo y | reg add "HKLM\Software\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\{VxKexPropagationVirtualKey}"
echo y | reg add "HKLM\Software\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\{VxKexPropagationVirtualKey}" /v GlobalFlag /t REG_DWORD /d 256
echo y | reg add "HKLM\Software\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\{VxKexPropagationVirtualKey}" /v VerifierFlags /t REG_DWORD /d 2147483648
echo y | reg add "HKLM\Software\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\{VxKexPropagationVirtualKey}" /v VerifierDlls /t REG_SZ /d "KexDll.dll"
@prompt Uninstall: 
echo y | reg add HKLM\Software\Microsoft\Windows\CurrentVersion\Uninstall\VxKex
echo y | reg add HKLM\Software\Microsoft\Windows\CurrentVersion\Uninstall\VxKex /v DisplayName /t REG_SZ /d "VxKex API Extensions for Windows® 7"
echo y | reg add HKLM\Software\Microsoft\Windows\CurrentVersion\Uninstall\VxKex /v DisplayVersion /t REG_SZ /d "%version%"
echo y | reg add HKLM\Software\Microsoft\Windows\CurrentVersion\Uninstall\VxKex /v Publisher /t REG_SZ /d "vxiiduu"
echo y | reg add HKLM\Software\Microsoft\Windows\CurrentVersion\Uninstall\VxKex /v InstallLocation /t REG_SZ /d "%programfiles%\VxKex"
echo y | reg add HKLM\Software\Microsoft\Windows\CurrentVersion\Uninstall\VxKex /v UninstallString /t REG_SZ /d "%programfiles%\VxKex\kexsetup.exe /UNINSTALL"
echo y | reg add HKLM\Software\Microsoft\Windows\CurrentVersion\Uninstall\VxKex /v NoRepair /t REG_DWORD /d 1
echo y | reg add HKLM\Software\Microsoft\Windows\CurrentVersion\Uninstall\VxKex /v NoModify /t REG_DWORD /d 1
@prompt vxl files: 
echo y | reg add "HKCR\.vxl" /ve /d "vxlfile"
echo y | reg add "HKCR\vxlfile" /ve /d "VxLog File"
echo y | reg add "HKCR\vxlfile\shell\open\command" /ve /d "%programfiles%\vxkex\vxlview.exe \"%%1\""
echo y | reg add "HKCR\vxlfile\DefaultIcon" /ve /d "%programfiles%\vxkex\vxlview.exe,1"
@prompt Disk Cleanup: 
echo y | reg add "HKLM\Software\Microsoft\Windows\CurrentVersion\Explorer\VolumeCaches\VxKex Log Files" /ve /d "{C0E13E61-0CC6-11d1-BBB6-0060978B2AE6}"
echo y | reg add "HKLM\Software\Microsoft\Windows\CurrentVersion\Explorer\VolumeCaches\VxKex Log Files" /v Description /d "VxKex may create log files each time you launch an application, which consumes dick space. Log files older than 3 days can safely be deleted."
echo y | reg add "HKLM\Software\Microsoft\Windows\CurrentVersion\Explorer\VolumeCaches\VxKex Log Files" /v Display /d "VxKex Log Files" /t REG_SZ
echo y | reg add "HKLM\Software\Microsoft\Windows\CurrentVersion\Explorer\VolumeCaches\VxKex Log Files" /v FileList /d "*.vxl" /t REG_SZ
echo y | reg add "HKLM\Software\Microsoft\Windows\CurrentVersion\Explorer\VolumeCaches\VxKex Log Files" /v Flags /t REG_DWORD /d 32
echo y | reg add "HKLM\Software\Microsoft\Windows\CurrentVersion\Explorer\VolumeCaches\VxKex Log Files" /v Folder /t REG_SZ /d "%programdata%\vxkex\logs"
echo y | reg add "HKLM\Software\Microsoft\Windows\CurrentVersion\Explorer\VolumeCaches\VxKex Log Files" /v IconPath /t REG_SZ /d "%programfiles%\vxlview.exe,1"
echo y | reg add "HKLM\Software\Microsoft\Windows\CurrentVersion\Explorer\VolumeCaches\VxKex Log Files" /v LastAccess /t REG_DWORD /d 3
@prompt Shell Extension:
echo y | reg add "HKCR\exefile\shellex\PropertySheetHandlers\KexShlEx Property Page" /ve /d "{9AACA888-A5F5-4C01-852E-8A2005C1D45F}"
echo y | reg add "HKCR\lnkfile\shellex\PropertySheetHandlers\KexShlEx Property Page" /ve /d "{9AACA888-A5F5-4C01-852E-8A2005C1D45F}"
echo y | reg add "HKCR\Msi.Package\shellex\PropertySheetHandlers\KexShlEx Property Page" /ve /d "{9AACA888-A5F5-4C01-852E-8A2005C1D45F}"
echo y | reg add HKCR\CLSID\{9AACA888-A5F5-4C01-852E-8A2005C1D45F}\InProcServer32 /ve /d "%programfiles%\VxKex\KexShlEx.dll"
echo y | reg add HKCR\CLSID\{9AACA888-A5F5-4C01-852E-8A2005C1D45F}\InProcServer32 /v ThreadingModel /d "Apartment" /t REG_SZ
echo y | reg add HKCR\Wow6432Node\CLSID\{9AACA888-A5F5-4C01-852E-8A2005C1D45F}\InProcServer32 /ve /d "%programfiles%\VxKex\KexShl32.dll"
echo y | reg add HKCR\Wow6432Node\CLSID\{9AACA888-A5F5-4C01-852E-8A2005C1D45F}\InProcServer32 /v ThreadingModel /d "Apartment" /t REG_SZ
@prompt CPIW Bypass: 
echo y | reg add "HKLM\Software\Microsoft\Windows\CurrentVersion\Explorer\Browser Helper Objects\{7EF224FC-1840-433C-9BCB-2951DE71DDBD}" /ve /d "VxKex CPIW Version Check Bypass"
echo y | reg add "HKCR\CLSID\{7EF224FC-1840-433C-9BCB-2951DE71DDBD}\InProcServer32" /ve /d "%programfiles%\vxkex\cpiwbypa.dll"
echo y | reg add "HKCR\CLSID\{7EF224FC-1840-433C-9BCB-2951DE71DDBD}\InProcServer32" /v ThreadingModel /d "Apartment"
echo y | reg add "HKLM\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\Explorer\Browser Helper Objects\{7EF224FC-1840-433C-9BCB-2951DE71DDBD}" /ve /d "VxKex CPIW Version Check Bypass"
echo y | reg add "HKLM\Wow6432Node\CLSID\{7EF224FC-1840-433C-9BCB-2951DE71DDBD}\InProcServer32" /ve /d "%programfiles%\vxkex\cpiwbypa.dll"
echo y | reg add "HKLM\Wow6432Node\CLSID\{7EF224FC-1840-433C-9BCB-2951DE71DDBD}\InProcServer32" /v ThreadingModel /d "Apartment"
echo y | reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Ext\Settings\{7EF224FC-1840-433C-9BCB-2951DE71DDBD}" /v Flags /d 40 /t REG_DWORD
@prompt Scheduling task: 
schtasks /create /xml task.xml /tn "VxKex Configuration Elevation Task"
@prompt Done: 
pause
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