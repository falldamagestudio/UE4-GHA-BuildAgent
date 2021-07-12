function Install-GCELoggingAgent {

	<#
		.SYNOPSIS
		Downloads and installs the GCE Logging Agent.
	#>

	$TempFolder = "C:\Temp"
	$LoggingAgentDownloadURI = "https://dl.google.com/cloudagents/windows/StackdriverLogging-v1-11.exe"

	$LoggingAgentInstallerExeName = "LoggingAgent.exe"

	New-Item $TempFolder -ItemType Directory -ErrorAction Stop | Out-Null

	try {

		$InstallerLocation = (Join-Path -Path $TempFolder -ChildPath $LoggingAgentInstallerExeName -ErrorAction Stop)

		Invoke-WebRequest -Uri $LoggingAgentDownloadURI -OutFile $InstallerLocation -ErrorAction Stop

		$Process = Start-Process -FilePath $InstallerLocation -ArgumentList "/S" -NoNewWindow -Wait -PassThru -ErrorAction Stop

		if ($Process.ExitCode -ne 0) {
			throw
		}

	} finally {

		Remove-Item -Recurse $TempFolder -Force -ErrorAction Ignore

	}
}
