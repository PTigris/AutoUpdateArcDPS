# AutoUpdateArcDPS
Installs a new version of ArcDPS automatically.
Instead of starting up Guild Wars 2 directly you run AutoUpdateArcDPS.bat

How to install:
Place AutoUpdateArcDPS.bat and AutoUpdateArcDPS.ps1 in your Guild Wars 2 instalation folder, where the Gw2-64.exe is.
AutoUpdateArcDPS.bat can be run with a shortcut or directly.

Working:
AutoUpdateArcDPS.bat is just to run AutoUpdateArcDPS.ps1
AutoUpdateArcDPS.ps1 looks on https://www.deltaconnected.com/arcdps/x64 to get the last modified date for d3d9.dll
When the date is not the same as the saved date from the previous download, it installes the new d3d9.dll automaticly in the bin64 folder.
At the same time "Last modified ArcDPS.txt" is saved in bin64 folder with the last modified date to compare with for the next time.
