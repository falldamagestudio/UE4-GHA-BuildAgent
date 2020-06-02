
function Install-Git {

	<#
		.SYNOPSIS
		Downloads and installs Git.
	#>

	param (
		[Parameter(Mandatory)] [string] $DownloadURI
	)

	$TempFolder = "C:\Temp"
	$InstallerExeName = "GitInstaller.exe"
	
	$InstallerLocation = (Join-Path $TempFolder -ChildPath $InstallerExeName)

	New-Item -Path $TempFolder -ItemType Directory | Out-Null

	Invoke-WebRequest -Uri $DownloadURI -OutFile $InstallerLocation

	Start-Process -FilePath $InstallerLocation -ArgumentList "/SILENT" -NoNewWindow -Wait

	Remove-Item $TempFolder -Recurse
}
