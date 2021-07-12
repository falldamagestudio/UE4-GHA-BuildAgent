function Install-DebuggingToolsForWindows {

	$TempFolder = "C:\Temp"
	$BuildToolsExeName = "winsdksetup.exe"

	New-Item $TempFolder -ItemType Directory -ErrorAction Stop | Out-Null

	try {

		$InstallerLocation = (Join-Path -Path $TempFolder -ChildPath $BuildToolsExeName -ErrorAction Stop)

		# Download Windows SDK
		Invoke-WebRequest -Uri "https://go.microsoft.com/fwlink/p/?linkid=2120843" -OutFile $InstallerLocation -ErrorAction Stop
		
		$Process = Start-Process -FilePath $InstallerLocation -ArgumentList "/norestart","/quiet","/features","OptionId.WindowsDesktopDebuggers" -NoNewWindow -Wait -PassThru -ErrorAction Stop
		
		if ($Process.ExitCode -ne 0) {
			throw
		}

	} finally {

		Remove-Item -Recurse $TempFolder -Force -ErrorAction Ignore

	}


}
