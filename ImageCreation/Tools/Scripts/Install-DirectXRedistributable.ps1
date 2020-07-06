function Install-DirectXRedistributable {

	$TempFolder = "C:\Temp"
	$RedistExeName = "DirectXRedist.exe"

	New-Item $TempFolder -ItemType Directory | Out-Null

	$InstallerLocation = (Join-Path -Path $TempFolder -ChildPath $RedistExeName)

	# Download DirectX End-User Runtime Web Installer
	Invoke-WebRequest -UseBasicParsing -Uri "https://download.microsoft.com/download/1/7/1/1718CCC4-6315-4D8E-9543-8E28A4E18C4C/dxwebsetup.exe" -OutFile $InstallerLocation
	
	$Process = Start-Process -FilePath $InstallerLocation -ArgumentList "/q" -NoNewWindow -Wait -PassThru
	
	if ($Process.ExitCode -ne 0) {
		throw
	}

	Remove-Item -Recurse $TempFolder
}

