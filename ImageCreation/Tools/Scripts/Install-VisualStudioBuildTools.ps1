
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

		Invoke-WebRequest -Uri $InstallerDownloadURI -OutFile $InstallerLocation -ErrorAction Stop

		$Args = @("--quiet", "--wait", "--norestart", "--nocache", "--installpath", $InstalledFolder)
		
		foreach ($WorkloadOrComponent in $WorkloadsAndComponents) {
			$Args += "--add"
			$Args += $WorkloadOrComponent
		}

		$Process = Start-Process -FilePath $InstallerLocation -ArgumentList $Args -NoNewWindow -Wait -PassThru -ErrorAction Stop
		
		if (($Process.ExitCode -ne 0) -and ($Process.ExitCode -ne 3010)) {
			throw
		}

	} finally {

		Remove-Item -Recurse $TempFolder -Force -ErrorAction Ignore
	}
}
