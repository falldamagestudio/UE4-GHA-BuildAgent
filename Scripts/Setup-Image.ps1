$here = Split-Path -Parent $MyInvocation.MyCommand.Path

. $here\Get-GitHubActionsRunnerLatestVersionURI.ps1
. $here\Install-GitHubActionsRunner.ps1 

. $here\Get-GitForWindowsLatestVersionURI.ps1
. $here\Install-Git.ps1

. $here\Install-VisualStudioBuildTools.ps1

$GitHubActionsInstallationFolder = "C:\A"

Write-Host "Installing GitHub Actions runner..."

$GitHubActionsRunnerDownloadURI = Get-GitHubActionsRunnerLatestVersionURI
Install-GitHubActionsRunner -RunnerDownloadURI $GitHubActionsRunnerDownloadURI -InstallationFolder $GitHubActionsInstallationFolder

Write-Host "Installing Git for Windows..."

$GitForWindowsDownloadURI = Get-GitForWindowsLatestVersionURI
Install-Git -DownloadURI $GitForWindowsDownloadURI

Write-Host "Installing Visual Studio Build Tools..."

Install-VisualStudioBuildTools

Write-Host "Done."
