
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

	$ZipFileLocation = (Join-Path $InstallationFolder -ChildPath $ZipFileName)

	New-Item -Path $InstallationFolder -ItemType Directory | Out-Null

	Invoke-WebRequest -Uri $RunnerDownloadURI -OutFile $ZipFileLocation
	Expand-Archive -LiteralPath $ZipFileLocation -DestinationPath $InstallationFolder
	
	Remove-Item $ZipFileLocation
}
