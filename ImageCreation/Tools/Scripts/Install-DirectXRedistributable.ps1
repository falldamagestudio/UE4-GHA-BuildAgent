function Install-DirectXRedistributable {

	param (
		[Parameter(Mandatory)] [string] $InstallerDownloadURI
	)

	$TempFolder = "C:\Temp"
	$RedistExeName = "DirectXRedist.exe"

	New-Item $TempFolder -ItemType Directory -ErrorAction Stop | Out-Null

	try {

		$InstallerLocation = (Join-Path -Path $TempFolder -ChildPath $RedistExeName -ErrorAction Stop)

		# Download DirectX End-User Runtime Web Installer
		Invoke-WebRequest -UseBasicParsing -Uri $InstallerDownloadURI -OutFile $InstallerLocation -ErrorAction Stop
		
		$Process = Start-Process -FilePath $InstallerLocation -ArgumentList "/q" -NoNewWindow -Wait -PassThru -ErrorAction Stop
		
		if ($Process.ExitCode -ne 0) {
			throw
		}

	} finally {

		Remove-Item -Recurse $TempFolder -Force -ErrorAction Ignore

	}

}

