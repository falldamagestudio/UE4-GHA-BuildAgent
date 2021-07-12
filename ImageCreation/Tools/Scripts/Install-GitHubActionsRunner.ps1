
function Install-GitHubActionsRunner {

	<#
		.SYNOPSIS
		Downloads and unpacks the GitHub Actions runner application into a specified folder on the machine.
	#>

	param (
		[Parameter(Mandatory)] [string] $InstallationFolder,
		[Parameter(Mandatory)] [string] $RunnerDownloadURI
	)

	$ZipFileName = "runner.zip"

	$ZipFileLocation = (Join-Path $InstallationFolder -ChildPath $ZipFileName -ErrorAction Stop)

	try {

		Invoke-WebRequest -Uri $RunnerDownloadURI -OutFile $ZipFileLocation -ErrorAction Stop
		New-Item -Path $InstallationFolder -ItemType Directory  -ErrorAction Stop | Out-Null
		Expand-Archive -LiteralPath $ZipFileLocation -DestinationPath $InstallationFolder -ErrorAction Stop

	} finally {

		Remove-Item $ZipFileLocation -Force -ErrorAction Ignore
		Remove-Item $InstallationFolder -Recurse -Force -ErrorAction Ignore
	}
	
}
