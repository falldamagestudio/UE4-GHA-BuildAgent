function Install-GCELoggingAgent {

	<#
		.SYNOPSIS
		Downloads and installs the GCE Logging Agent.
	#>

	$TempFolder = "C:\Temp"
	$LoggingAgentDownloadURI = "https://dl.google.com/cloudagents/windows/StackdriverLogging-v1-11.exe"

	$LoggingAgentInstallerExeName = "LoggingAgent.exe"

	New-Item $TempFolder -ItemType Directory | Out-Null

	$InstallerLocation = (Join-Path -Path $TempFolder -ChildPath $LoggingAgentInstallerExeName)

	Invoke-WebRequest -Uri $LoggingAgentDownloadURI -OutFile $InstallerLocation

	$Process = Start-Process -FilePath $InstallerLocation -ArgumentList "/S" -NoNewWindow -Wait -PassThru

	if ($Process.ExitCode -ne 0) {
		throw
	}

	Remove-Item -Recurse $TempFolder
}
