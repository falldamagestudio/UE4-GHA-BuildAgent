
$here = Split-Path -Parent $MyInvocation.MyCommand.Path

. $here\..\Tools\Scripts\Get-GCEInstanceMetadata.ps1
. $here\..\Tools\Scripts\Resize-PartitionToMaxSize.ps1

$DriveLetter = "C"
$GitHubActionsInstallationFolder = "C:\A"

Write-Host "Retrieving configuration from instance metadata..."

$GitHubPAT = Get-GCEInstanceMetadata -Key "github-pat"
$GitHubScope = Get-GCEInstanceMetadata -Key "github-scope"
$GitHubHostname = Get-GCEInstanceMetadata -Key "github-site-name"
$AgentName = Get-GCEInstanceMetadata -Key "runner-name"

Write-Host "Resizing ${DriveLetter} partition to max size..."

Resize-PartitionToMaxSize -DriveLetter $DriveLetter

Write-Host "Launching Service script..."

$ServiceParams = @{
    GitHubActionsInstallationFolder = $GitHubActionsInstallationFolder
    GitHubPAT = $GitHubPAT
    GitHubScope = $GitHubScope
}

if ($GitHubHostName -ne $null) { $ServiceParams.GitHubHostname = $GitHubHostname }
if ($AgentName -ne $null) { $ServiceParams.AgentName = $AgentName }

& $here\Service.ps1 @ServiceParams

Write-Host "Done."
