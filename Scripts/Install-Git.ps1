
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

	Invoke-WebRequest -Uri $DownloadURI -OutFile $InstallerLocation

	Invoke-External -LiteralPath "$InstallerLocation" "/SILENT"
}
