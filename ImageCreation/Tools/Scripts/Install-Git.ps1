
function Install-Git {

	<#
		.SYNOPSIS
		Downloads and installs Git.
	#>

	param (
		[Parameter(Mandatory)] [string] $InstallerDownloadURI
	)

	$TempFolder = "C:\Temp"
	$InstallerExeName = "GitInstaller.exe"
	
	$InstallerLocation = (Join-Path $TempFolder -ChildPath $InstallerExeName)

	New-Item $TempFolder -ItemType Directory -ErrorAction Stop | Out-Null

	try {

		Invoke-WebRequest -Uri $InstallerDownloadURI -OutFile $InstallerLocation -ErrorAction Stop

		Start-Process -FilePath $InstallerLocation -ArgumentList "/SILENT" -NoNewWindow -Wait -ErrorAction Stop

	} finally {

		Remove-Item -Recurse $TempFolder -Force -ErrorAction Ignore

	}
}
