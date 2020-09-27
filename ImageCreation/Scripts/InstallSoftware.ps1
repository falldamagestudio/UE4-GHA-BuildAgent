$here = Split-Path -Parent $MyInvocation.MyCommand.Path

. $here\..\Tools\Scripts\Enable-Win32LongPaths.ps1

. $here\..\Tools\Scripts\Get-GitHubActionsRunnerLatestVersionURI.ps1
. $here\..\Tools\Scripts\Install-GitHubActionsRunner.ps1 
. $here\..\Tools\Scripts\Add-WindowsDefenderExclusionRule.ps1

. $here\..\Tools\Scripts\Get-GitForWindowsLatestVersionURI.ps1
. $here\..\Tools\Scripts\Install-Git.ps1

. $here\..\Tools\Scripts\Install-VisualStudioBuildTools.ps1

. $here\..\Tools\Scripts\Install-DebuggingToolsForWindows.ps1

. $here\..\Tools\Scripts\Install-DirectXRedistributable.ps1

. $here\..\Tools\Scripts\Install-GCELoggingAgent.ps1
. $here\..\Tools\Scripts\Install-GitHubActionsLoggingSourceForGCELoggingAgent.ps1

$GitHubActionsInstallationFolder = "C:\A"

Write-Host "Enabling Win32 Long Paths..."

Enable-Win32LongPaths

Write-Host "Installing GitHub Actions runner..."

$GitHubActionsRunnerDownloadURI = Get-GitHubActionsRunnerLatestVersionURI
Install-GitHubActionsRunner -RunnerDownloadURI $GitHubActionsRunnerDownloadURI -InstallationFolder $GitHubActionsInstallationFolder

Write-Host "Adding Windows Defender exclusion rule for Github Actions runner folder..."

Add-WindowsDefenderExclusionRule -Folder $GitHubActionsInstallationFolder

Write-Host "Installing Git for Windows..."

$GitForWindowsDownloadURI = Get-GitForWindowsLatestVersionURI
Install-Git -DownloadURI $GitForWindowsDownloadURI

Write-Host "Installing Visual Studio Build Tools..."

Install-VisualStudioBuildTools

Write-Host "Installing Debugging Tools for Windows..."

# This provides PDBCOPY.EXE which is used when packaging up the Engine
Install-DebuggingToolsForWindows

Write-Host "Installing DirectX Redistributable..."

# This provides XINPUT1_3.DLL which is used when running the C++ apps (UE4Editor-Cmd.exe for example), even in headless mode
Install-DirectXRedistributable

Write-Host "Installing GCE Logging Agent..."

# This will provide the basic forwarding of logs to GCP Logging, and send various Windows Event log activity there
Install-GCELoggingAgent

Write-Host "Installing forwarding of GitHubActions Runner logs to GCP Logging..."

# This will capture GitHub Actions runner output and send it to GCP Logging
Install-GitHubActionsLoggingSourceForGCELoggingAgent -GitHubActionsRunnerInstallationFolder $GitHubActionsInstallationFolder

Write-Host "Done."
