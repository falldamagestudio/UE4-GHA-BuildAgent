
function Install-VisualStudioBuildTools {

	$TempFolder = "C:\Temp"
	$BuildToolsExeName = "vs_buildtools.exe"
	$InstalledFolder = "C:\BuildTools"

	New-Item $TempFolder -ItemType Directory | Out-Null

	$InstallerLocation = (Join-Path -Path $TempFolder -ChildPath $BuildToolsExeName)

	Invoke-WebRequest -Uri "https://aka.ms/vs/16/release/vs_buildtools.exe" -OutFile $InstallerLocation

	$WorkloadsAndComponents = @(
		"Microsoft.VisualStudio.Workload.VCTools"
		"Microsoft.VisualStudio.Component.VC.Tools.x86.x64"
		"Microsoft.VisualStudio.Workload.ManagedDesktopBuildTools"	# Required to get PDBCOPY.EXE, which in turn is applied to all PDB files
		"Microsoft.VisualStudio.Component.Windows10SDK.18362"
		"Microsoft.Net.Component.4.6.2.TargetingPack"	# Required when building AutomationTool
		"Microsoft.Net.Component.4.5.TargetingPack"	# Required when building SwarmCoordinator
	)

	$Args = @("--quiet", "--wait", "--norestart", "--nocache", "--installpath", $InstalledFolder)
	
	foreach ($WorkloadOrComponent in $WorkloadsAndComponents) {
		$Args += "--add"
		$Args += $WorkloadOrComponent
	}

	$Process = Start-Process -FilePath $InstallerLocation -ArgumentList $Args -NoNewWindow -Wait -PassThru
	
	if (($Process.ExitCode -ne 0) -and ($Process.ExitCode -ne 3010)) {
		throw
	}

	Remove-Item -Recurse $TempFolder
}
