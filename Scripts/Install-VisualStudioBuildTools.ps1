
function Install-VisualStudioBuildTools {

	New-Item "C:\Temp" -ItemType Directory

	Invoke-WebRequest -Uri "https://aka.ms/vs/16/release/vs_buildtools.exe" -OutFile "C:\Temp\vs_buildtools.exe"
	
	& "c:\temp\vs_buildtools.exe" "--quiet" "--wait" "--norestart" "--nocache" "--installpath" "C:\BuildTools" "--add" "Microsoft.VisualStudio.Workload.VCTools" "--add" "Microsoft.VisualStudio.Component.VC.Tools.x86.x64" "--add" "Microsoft.VisualStudio.Workload.ManagedDesktopBuildTools" "--add" "Microsoft.VisualStudio.Component.Windows10SDK.18362"
	
	if (($LASTEXITCODE -ne 0) -and ($LASTEXITCODE -ne 3010)) {
		throw
	}

	Remove-Item -Recurse -Force "C:\Temp"
}
