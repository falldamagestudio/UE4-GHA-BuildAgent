
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

	New-Item $TempFolder -ItemType Directory -ErrorAction Stop | Out-Null

	try {

		Invoke-WebRequest -Uri $DownloadURI -OutFile $InstallerLocation -ErrorAction Stop

		Start-Process -FilePath $InstallerLocation -ArgumentList "/SILENT" -NoNewWindow -Wait -ErrorAction Stop

	} finally {

		Remove-Item -Recurse $TempFolder -Force -ErrorAction Ignore

	}
}
