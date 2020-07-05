$here = Split-Path -Parent $MyInvocation.MyCommand.Path

. $here\..\Tools\Scripts\Enable-Win32LongPaths.ps1

. $here\..\Tools\Scripts\Get-GitHubActionsRunnerLatestVersionURI.ps1
. $here\..\Tools\Scripts\Install-GitHubActionsRunner.ps1 

. $here\..\Tools\Scripts\Get-GitForWindowsLatestVersionURI.ps1
. $here\..\Tools\Scripts\Install-Git.ps1

. $here\..\Tools\Scripts\Install-VisualStudioBuildTools.ps1

. $here\..\Tools\Scripts\Install-DebuggingToolsForWindows.ps1

$GitHubActionsInstallationFolder = "C:\A"

Write-Host "Enabling Win32 Long Paths..."

Enable-Win32LongPaths

Write-Host "Installing GitHub Actions runner..."

$GitHubActionsRunnerDownloadURI = Get-GitHubActionsRunnerLatestVersionURI
Install-GitHubActionsRunner -RunnerDownloadURI $GitHubActionsRunnerDownloadURI -InstallationFolder $GitHubActionsInstallationFolder

Write-Host "Installing Git for Windows..."

$GitForWindowsDownloadURI = Get-GitForWindowsLatestVersionURI
Install-Git -DownloadURI $GitForWindowsDownloadURI

Write-Host "Installing Visual Studio Build Tools..."

Install-VisualStudioBuildTools

Write-Host "Installing Debugging Tools for Windows..."

Install-DebuggingToolsForWindows

Write-Host "Done."
