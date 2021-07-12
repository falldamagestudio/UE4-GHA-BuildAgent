. ${PSScriptRoot}\..\Tools\Scripts\Enable-Win32LongPaths.ps1

. ${PSScriptRoot}\..\Tools\Scripts\Install-GitHubActionsRunner.ps1
. ${PSScriptRoot}\..\Tools\Scripts\Add-WindowsDefenderExclusionRule.ps1

. ${PSScriptRoot}\..\Tools\Scripts\Install-Git.ps1

. ${PSScriptRoot}\..\Tools\Scripts\Install-VisualStudioBuildTools.ps1

. ${PSScriptRoot}\..\Tools\Scripts\Install-DebuggingToolsForWindows.ps1

. ${PSScriptRoot}\..\Tools\Scripts\Install-DirectXRedistributable.ps1

. ${PSScriptRoot}\..\Tools\Scripts\Install-GCELoggingAgent.ps1
. ${PSScriptRoot}\..\Tools\Scripts\Install-GitHubActionsLoggingSourceForGCELoggingAgent.ps1

$GitHubActionsInstallationFolder = "C:\A"

$ToolsAndVersions = Import-PowerShellDataFile ${PSScriptRoot}\ToolsAndVersions.psd1 -ErrorAction Stop

Write-Host "Enabling Win32 Long Paths..."

Enable-Win32LongPaths

Write-Host "Installing GitHub Actions runner..."

Install-GitHubActionsRunner -RunnerDownloadURI $ToolsAndVersions.GitHubActionsRunnerDownloadURI -InstallationFolder $GitHubActionsInstallationFolder

Write-Host "Adding Windows Defender exclusion rule for Github Actions runner folder..."

Add-WindowsDefenderExclusionRule -Folder $GitHubActionsInstallationFolder

Write-Host "Installing Git for Windows..."

Install-Git -InstallerDownloadURI $ToolsAndVersions.$GitForWindowsDownloadURI

Write-Host "Installing Visual Studio Build Tools..."

Install-VisualStudioBuildTools -InstallerDownloadURI $ToolsAndVersions.VisualStudioBuildToolsDownloadURI -WorkloadsAndComponents $ToolsAndVersions.VisualStudioBuildTools_WorkloadsAndComponents

Write-Host "Installing Debugging Tools for Windows..."

# This provides PDBCOPY.EXE which is used when packaging up the Engine
Install-DebuggingToolsForWindows -InstallerDownloadURI $ToolsAndVersions.WindowsSDKDownloadURI

Write-Host "Installing DirectX Redistributable..."

# This provides XINPUT1_3.DLL which is used when running the C++ apps (UE4Editor-Cmd.exe for example), even in headless mode
Install-DirectXRedistributable -InstallerDownloadURI $ToolsAndVersions.DirectXEndUserRuntimeWebInstallerDownloadURI

Write-Host "Installing GCE Logging Agent..."

# This will provide the basic forwarding of logs to GCP Logging, and send various Windows Event log activity there
Install-GCELoggingAgent -InstallerDownloadURI $ToolsAndVersions.GCELoggingAgentInstallerDownloadURI

Write-Host "Installing forwarding of GitHubActions Runner logs to GCP Logging..."

# This will capture GitHub Actions runner output and send it to GCP Logging
Install-GitHubActionsLoggingSourceForGCELoggingAgent -GitHubActionsRunnerInstallationFolder $GitHubActionsInstallationFolder

Write-Host "Done."
