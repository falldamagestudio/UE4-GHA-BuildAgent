
function Install-VisualStudioBuildTools {

	$TempFolder = "C:\Temp"
	$BuildToolsExeName = "vs_buildtools.exe"
	$InstalledFolder = "C:\BuildTools"

	New-Item $TempFolder -ItemType Directory | Out-Null

	$InstallerLocation = (Join-Path -Path $TempFolder -ChildPath $BuildToolsExeName)

	Invoke-WebRequest -Uri "https://aka.ms/vs/16/release/vs_buildtools.exe" -OutFile $InstallerLocation
	
	$Process = Start-Process -FilePath $InstallerLocation -ArgumentList "--quiet","--wait","--norestart","--nocache","--installpath",$InstalledFolder,"--add","Microsoft.VisualStudio.Workload.VCTools","--add","Microsoft.VisualStudio.Component.VC.Tools.x86.x64","--add","Microsoft.VisualStudio.Workload.ManagedDesktopBuildTools","--add","Microsoft.VisualStudio.Component.Windows10SDK.18362" -NoNewWindow -Wait -PassThru
	
	if (($Process.ExitCode -ne 0) -and ($Process.ExitCode -ne 3010)) {
		throw
	}

	Remove-Item -Recurse $TempFolder
}
