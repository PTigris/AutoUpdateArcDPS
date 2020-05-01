# This script is created by Panthera Tigris.

$ReadTime = 0
$Path = [System.IO.Path]::GetDirectoryName($myInvocation.MyCommand.Definition) # Installation path of Guild Wars 2, where Gw2-64.exe is hiding.
$Web = New-Object Net.WebClient # Get ley line thingy.
# Get last modified date and time:
"Getting last modified date and time from www.deltaconnected.com"
$ReadTime = $ReadTime+3
$Text = $web.DownloadString("https://www.deltaconnected.com/arcdps/x64") #Dowload this page in text.
$Pos1 = $Text.IndexOf("d3d9.dll")  #Find d3d9.dll
$Pos2 = $Pos1
while ($Pos1 -notlike -1) {
	if (($Text.Substring($Pos1+8,1) -notlike ".")) {$Pos2 = $Pos1}
	$Pos1 = $Text.IndexOf("d3d9.dll",$Pos1+1)
}
$SpacePos1 = $Text.IndexOf(" ",$Pos2+8) # Find end of text.
while ($Text.Substring($SpacePos1,1) -like " ") {$SpacePos1 = $SpacePos1+1} # Skip all the spaces to get our first year number.
$DashPos1 = $Text.IndexOf("-",$SpacePos1)+1 # Dash between year and month.
$DashPos2 = $Text.IndexOf("-",$DashPos1)+1 # Dash between month and day.
$SpacePos2 = $Text.IndexOf(" ",$DashPos2)+1 # Space between day and hour.
$ColonPos = $Text.IndexOf(":",$SpacePos2)+1 # Colon between hour and minutes.
#Take the numbers out and make it nice again:
$DateTime = $Text.Substring($SpacePos1,($DashPos1-1)-$SpacePos1)+"-"+$Text.Substring($DashPos1,($DashPos2-1)-$DashPos1)+"-"+$Text.Substring($DashPos2,($SpacePos2-1)-$DashPos2)+" "+$Text.Substring($SpacePos2,($ColonPos-1)-$SpacePos2)+":"+$Text.Substring($ColonPos,$Text.IndexOf(" ",$ColonPos)-$ColonPos)

"Last modified date and time is "+$DateTime
$ReadTime = $ReadTime+3

$WrongFolder = $false
$GuildWarsRunning = Get-Process "Gw2-64" -ErrorAction SilentlyContinue

# If bin64 folder exists:
if (Test-Path ($Path+"\bin64")) {
	function Instal {
		$DateTime | Out-File -FilePath ($Path+"\bin64\Last modified ArcDPS.txt") # Save the date and time in this text file.
		$Web.DownloadFile("https://www.deltaconnected.com/arcdps/x64/d3d9.dll", $Path+"\bin64\d3d9.dll") # Download and save the ArcDPS dll.
		[system.media.systemsounds]::Exclamation.play() # Play a sound for a new ArcDPS dll.
	}
	
	# If both files are pressent:
	if ((Test-Path ($Path+"\bin64\Last modified ArcDPS.txt")) -and (Test-Path ($Path+"\bin64\d3d9.dll"))) {
		$File = new-object System.IO.StreamReader($Path+"\bin64\Last modified ArcDPS.txt") # Read "Last modified ArcDPS.txt" to get the last modified date and time of the installed version.
		$DateTimeFile = $File.ReadLine()
		$File.close()
		"Date and time last modified of the installed version is "+$DateTimeFile
		$ReadTime = $ReadTime+3
		if ($DateTime -notlike $DateTimeFile) { # If the modification date is not the same:
			"There is a new version of ArcDPS."
			$ReadTime = $ReadTime+2
			if ($GuildWarsRunning) {
				"Cannot install new version of ArcDPS while Guild Wars 2 is running."
				$ReadTime = $ReadTime+3
			} else {
				Instal # Call Instal function.
				"New version installed."
				$ReadTime = $ReadTime+2
			}
			# When there is no new version:
		} else {
			"There is no newer version of ArcDPS."
			$ReadTime = $ReadTime+2
		}
	} else { # If DateTime file and/or d3d9.dll are not pressent:
		if ($GuildWarsRunning) {
			"Cannot install while Guild Wars 2 is running."
			$ReadTime = $ReadTime+2
		} else {
			if (Test-Path ($Path+"\bin64\Last modified ArcDPS.txt")) {
				'Cannot find "d3d9.dll", installing...'
			} elseif (Test-Path ($Path+"\bin64\d3d9.dll")) {
				'Cannot find "Last modified ArcDPS.txt". Welcome to AutoUpdateArcDPS!'
			} else {
				'"Last modified ArcDPS.txt" and d3d9.dll are not present. Welcome to ArcDPS!, installing...'
			}
			$ReadTime = $ReadTime+3
			Instal # Call Instal function.
			"Installation complete."
			$ReadTime = $ReadTime+2
		}
	}
} else {
	"Cannot find bin64 folder."
	$ReadTime = $ReadTime+3
	$WrongFolder = $true
}

if (!$GuildWarsRunning) {
	# If Gw2-64.exe exists:
	if (Test-Path ($Path+"\Gw2-64.exe")) {
		"Starting Guild Wars 2"
		$ReadTime = $ReadTime+2
		& ($Path+"\Gw2-64.exe") # Run Guild Wars 2.
	} else {
		'Cannot find "Gw2-64.exe".'
		$ReadTime = $ReadTime+3
		$WrongFolder = $true
	}
}

if ($WrongFolder) {
	'Place "AutoUpdateArcDPS.bat" and "AutoUpdateArcDPS.ps1" in the same folder where "Gw2-64.exe" is, your Guild Wars 2 installation folder.'
	$ReadTime = $ReadTime+4
}
"This window closes automatically after "+$ReadTime+" seconds."
Sleep $ReadTime
