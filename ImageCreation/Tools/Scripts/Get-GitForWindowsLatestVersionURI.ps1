
function Get-GitForWindowsLatestVersionURI {

	<#
		.SYNOPSIS
		Scans the GitHub Actions Runner release list and returns the URI for the newest Windows version
	#>

	$LatestVersionLabel = ((Invoke-WebRequest -UseBasicParsing -Uri "https://api.github.com/repos/git-for-windows/git/releases/latest").Content | ConvertFrom-Json).tag_name

	$ParsedLatestVersionLabel = $LatestVersionLabel | Select-String -Pattern "v(\d+)\.(\d+)\.(\d+)"

	$LatestVersion = "{0}.{1}.{2}" -f $ParsedLatestVersionLabel.Matches[0].Groups[1], $ParsedLatestVersionLabel.Matches[0].Groups[2], $ParsedLatestVersionLabel.Matches[0].Groups[3]

	$RunnerFileName = "Git-${LatestVersion}-64-bit.exe"

	$DownloadURI = "https://github.com/git-for-windows/git/releases/download/${LatestVersionLabel}/${RunnerFileName}"

	return $DownloadURI
}
