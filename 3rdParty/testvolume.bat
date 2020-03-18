 C:\Dev\AHK\Protos\3rdParty\soundvolumeview.exe /GetPercent Spotify.exe 
echo %errorlevel%
nircmd changeappvolume Spotify.exe +0.5 
soundvolumeview.exe /GetPercent Spotify.exe
echo %errorlevel%