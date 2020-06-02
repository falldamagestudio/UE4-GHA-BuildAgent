
function Get-GitHubActionsRunnerLatestVersionURI {

	<#
		.SYNOPSIS
		Scans the GitHub Actions Runner release list and returns the URI for the newest Windows version
	#>

	$LatestVersionLabel = ((Invoke-WebRequest -UseBasicParsing -Uri "https://api.github.com/repos/actions/runner/releases/latest").Content | ConvertFrom-Json).tag_name

	$LatestVersion = $LatestVersionLabel.Substring(1)

	$RunnerFileName = "actions-runner-win-x64-${LatestVersion}.zip"

	$RunnerDownloadURI = "https://github.com/actions/runner/releases/download/${LatestVersionLabel}/${RunnerFileName}"

	return $RunnerDownloadURI
}
