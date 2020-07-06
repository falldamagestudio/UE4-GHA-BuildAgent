function Install-DirectXRedistributable {

	$TempFolder = "C:\Temp"
	$RedistExeName = "DirectXRedist.exe"

	New-Item $TempFolder -ItemType Directory | Out-Null

	$InstallerLocation = (Join-Path -Path $TempFolder -ChildPath $RedistExeName)

	# Download DirectX End-User Runtimes (June 2010)
	Invoke-WebRequest -UseBasicParsing -Uri "https://download.microsoft.com/download/8/4/A/84A35BF1-DAFE-4AE8-82AF-AD2AE20B6B14/directx_Jun2010_redist.exe" -OutFile $InstallerLocation
	
	$Process = Start-Process -FilePath $InstallerLocation -ArgumentList "/q" -NoNewWindow -Wait -PassThru
	
	if ($Process.ExitCode -ne 0) {
		throw
	}

	Remove-Item -Recurse $TempFolder
}

