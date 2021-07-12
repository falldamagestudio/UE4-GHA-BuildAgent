function Install-DirectXRedistributable {

	$TempFolder = "C:\Temp"
	$RedistExeName = "DirectXRedist.exe"

	New-Item $TempFolder -ItemType Directory -ErrorAction Stop | Out-Null

	try {

		$InstallerLocation = (Join-Path -Path $TempFolder -ChildPath $RedistExeName -ErrorAction Stop)

		# Download DirectX End-User Runtime Web Installer
		Invoke-WebRequest -UseBasicParsing -Uri "https://download.microsoft.com/download/1/7/1/1718CCC4-6315-4D8E-9543-8E28A4E18C4C/dxwebsetup.exe" -OutFile $InstallerLocation -ErrorAction Stop
		
		$Process = Start-Process -FilePath $InstallerLocation -ArgumentList "/q" -NoNewWindow -Wait -PassThru -ErrorAction Stop
		
		if ($Process.ExitCode -ne 0) {
			throw
		}

	} finally {

		Remove-Item -Recurse $TempFolder -Force -ErrorAction Ignore

	}

}

