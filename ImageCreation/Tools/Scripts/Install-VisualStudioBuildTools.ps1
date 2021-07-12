class VSBuildToolsInstallerException : Exception {
	$ExitCode

	VSBuildToolsInstallerException([int] $exitCode) : base("vs_buildtools.exe exited with code ${exitCode}") { $this.ExitCode = $exitCode }
}

function Install-VisualStudioBuildTools {

	param (
		[Parameter(Mandatory)] [string] $InstallerDownloadURI,
		[Parameter(Mandatory)] $WorkloadsAndComponents
	)

	$TempFolder = "C:\Temp"
	$BuildToolsExeName = "vs_buildtools.exe"
	$InstalledFolder = "C:\BuildTools"

	New-Item $TempFolder -ItemType Directory -Force -ErrorAction Stop | Out-Null

	try {

		$InstallerLocation = (Join-Path -Path $TempFolder -ChildPath $BuildToolsExeName -ErrorAction Stop)

		# Download installer
		Invoke-WebRequest -Uri $InstallerDownloadURI -OutFile $InstallerLocation -ErrorAction Stop

		$Args = @("--quiet", "--wait", "--norestart", "--nocache", "--installpath", $InstalledFolder)
		
		foreach ($WorkloadOrComponent in $WorkloadsAndComponents) {
			$Args += "--add"
			$Args += $WorkloadOrComponent
		}

		# Invoke installer
		$Process = Start-Process -FilePath $InstallerLocation -ArgumentList $Args -NoNewWindow -Wait -PassThru -ErrorAction Stop
		
		# Particular exit codes are successful:
		# 0    == Operation completed successfully
		# 3010 == Operation completed successfully, but install requires reboot before it can be used
		# All other exit codes should result in an exception
		if (($Process.ExitCode -ne 0) -and ($Process.ExitCode -ne 3010)) {
			throw [VSBuildToolsInstallerException]::new($Process.ExitCode)
		}

	} finally {

		# Remove temp folder
		Remove-Item -Recurse $TempFolder -Force -ErrorAction Ignore
	}
}
