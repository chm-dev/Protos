RegWrite, REG_DWORD, HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Policies\ActiveDesktop, NoChangingWallPaper, 00000000
OutPutDebug, NoChangingWallPaper: %ErrorLevel%
RegWrite, REG_DWORD, HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer, NoDriveTypeAutoRun, 00000091
OutPutDebug, NoDriveTypeAutoRun: %ErrorLevel%
RegWrite, REG_DWORD, HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer, NoAutoTrayNotify, 00000000
OutPutDebug, NoAutoTrayNotify: %ErrorLevel%
RegWrite, REG_DWORD, HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer, DisablePersonalDirChange, 00000000
OutPutDebug, DisablePersonalDirChange: %ErrorLevel%
RegWrite, REG_DWORD, HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer, NoOnlinePrintsWizard, 00000001
OutPutDebug, NoOnlinePrintsWizard: %ErrorLevel%
RegWrite, REG_DWORD, HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer, NoSaveSettings, 00000000
OutPutDebug, NoSaveSettings: %ErrorLevel%
RegWrite, REG_DWORD, HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer, NoThemesTab, 00000000
OutPutDebug, NoThemesTab: %ErrorLevel%
RegWrite, REG_DWORD, HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer, NoAddPrinter, 00000000
OutPutDebug, NoAddPrinter: %ErrorLevel%
RegWrite, REG_DWORD, HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer, HideSCAHealth, 00000001
OutPutDebug, HideSCAHealth: %ErrorLevel%
RegWrite, REG_DWORD, HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer, NoCDBurning, 00000001
OutPutDebug, NoCDBurning: %ErrorLevel%
RegWrite, REG_DWORD, HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer, DisallowCpl, 00000000
OutPutDebug, DisallowCpl: %ErrorLevel%
RegWrite, REG_DWORD, HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer, DisallowRun, 00000000
OutPutDebug, DisallowRun: %ErrorLevel%

RegWrite, REG_SZ, HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer\DisallowCpl, 1, @%SystemRoot%\\system32\\Vault.dll,-1
OutPutDebug, 1: %ErrorLevel%
RegWrite, REG_SZ, HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer\DisallowCpl, 2, @C:\\Windows\\System32\\icardres.dll,-4097
OutPutDebug, 2: %ErrorLevel%
RegWrite, REG_SZ, HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer\DisallowCpl, 3, @%systemroot%\\system32\\FunctionDiscoveryFolder.dll,-1500
OutPutDebug, 3: %ErrorLevel%

RegWrite, REG_SZ, HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer\DisallowRun, 1, MSOUC.exe
OutPutDebug, 1: %ErrorLevel%
RegWrite, REG_SZ, HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer\DisallowRun, 2, MSOSYNC.exe
OutPutDebug, 2: %ErrorLevel%
RegWrite, REG_SZ, HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer\DisallowRun, 3, BCSSync.exe
OutPutDebug, 3: %ErrorLevel%

RegWrite, REG_DWORD, HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer\WAU, Disabled, 00000001
OutPutDebug, Disabled: %ErrorLevel%

RegWrite, REG_DWORD, HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Policies\Ext, NoFirsttimeprompt, 00000001
OutPutDebug, NoFirsttimeprompt: %ErrorLevel%

RegWrite, REG_DWORD, HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Policies\Programs, NoWindowsMarketplace, 00000000
OutPutDebug, NoWindowsMarketplace: %ErrorLevel%

RegWrite, REG_DWORD, HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Policies\System, DisableRegistryTools, 00000000
OutPutDebug, DisableRegistryTools: %ErrorLevel%
RegWrite, REG_DWORD, HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Policies\System, HideLegacyLogonScripts, 00000000
OutPutDebug, HideLegacyLogonScripts: %ErrorLevel%
RegWrite, REG_DWORD, HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Policies\System, NoDispBackgroundPage, 00000000
OutPutDebug, NoDispBackgroundPage: %ErrorLevel%
RegWrite, REG_DWORD, HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Policies\System, NoColorChoice, 00000000
OutPutDebug, NoColorChoice: %ErrorLevel%
RegWrite, REG_SZ, HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Policies\System, Wallpaper, C:\BgInfo\BGInfo.bmp
OutPutDebug, Wallpaper: %ErrorLevel%
RegWrite, REG_SZ, HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Policies\System, WallpaperStyle, 1
OutPutDebug, WallpaperStyle: %ErrorLevel%
RegWrite, REG_DWORD, HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Policies\System, NoDispCPL, 00000000
OutPutDebug, NoDispCPL: %ErrorLevel%
RegWrite, REG_DWORD, HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Policies\Uninstall, NoAddFromInternet, 00000000
OutPutDebug, NoAddFromInternet: %ErrorLevel%

RegWrite, REG_DWORD, HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Policies\Windows, TurnOffWinCal, 00000001
OutPutDebug, TurnOffWinCal: %ErrorLevel%

Runwait, taskkill /im explorer.exe /f 
Run, explorer.exe
