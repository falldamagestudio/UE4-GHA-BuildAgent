function Install-DebuggingToolsForWindows {

	$TempFolder = "C:\Temp"
	$BuildToolsExeName = "winsdksetup.exe"

	New-Item $TempFolder -ItemType Directory | Out-Null

	$InstallerLocation = (Join-Path -Path $TempFolder -ChildPath $BuildToolsExeName)

	# Download Windows SDK
	Invoke-WebRequest -Uri "https://go.microsoft.com/fwlink/p/?linkid=2120843" -OutFile $InstallerLocation
	
	$Process = Start-Process -FilePath $InstallerLocation -ArgumentList "/norestart","/quiet","/features","OptionId.WindowsDesktopDebuggers" -NoNewWindow -Wait -PassThru
	
	if ($Process.ExitCode -ne 0) {
		throw
	}

	Remove-Item -Recurse $TempFolder
}
