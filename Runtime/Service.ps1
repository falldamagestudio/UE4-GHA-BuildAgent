param (
    [Parameter(Mandatory)] [string] $GitHubActionsInstallationFolder,
    [Parameter(Mandatory)] [string] $GitHubPAT,
    [Parameter(Mandatory)] [string] $GitHubScope,
    [Parameter(Mandatory=$false)] [string] $GitHubHostname,
    [Parameter(Mandatory=$false)] [string] $AgentName
)

$here = Split-Path -Parent $MyInvocation.MyCommand.Path

. $here\Resize-PartitionToMaxSize.ps1
. $here\Configure-GitHubActionsRunner.ps1
. $here\Run-GitHubActionsRunner.ps1

$DriveLetter = "C"
$GitHubActionsInstallationFolder = "C:\A"


Write-Host "Resizing ${DriveLetter} partition to max size..."

Resize-PartitionToMaxSize -DriveLetter $DriveLetter

Write-Host "Configuring GitHub Actions runner..."

$ConfigureParams = @{
    GitHubActionsInstallationFolder = $GitHubActionsInstallationFolder
    GitHubPAT = $GitHubPAT
    GitHubScope = $GitHubScope
}

if ($PSBoundParameters.ContainsKey('GitHubHostname')) { $ConfigurParams.GitHubHostname = $GitHubHostname }
if ($PSBoundParameters.ContainsKey('AgentName')) { $ConfigurParams.AgentName = $AgentName }

Configure-GitHubActionsRunner @ConfigureParams

Write-Host "Launching GitHub Actions runner..."

Run-GitHubActionsRunner -GitHubActionsInstallationFolder $GitHubActionsInstallationFolder

Write-Host "Done."
