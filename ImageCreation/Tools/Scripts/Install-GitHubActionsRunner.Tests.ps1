$here = Split-Path -Parent $MyInvocation.MyCommand.Path
$sut = (Split-Path -Leaf $MyInvocation.MyCommand.Path) -replace '\.Tests\.', '.'
. "$here\$sut"

Describe 'Install-GitHubActionsRunner' {

	It "Fetches and installs runner" {

		$InstallationFolder = "${here}/Runner"

		$DownloadURI = "https://examplesite.com/GitHubActionsRunner.zip"

		$LocalRunnerZipLocation = "${here}/Install-GitHubActionsRunner.Tests.zip"

		try {

			Mock Invoke-WebRequest -ParameterFilter { $RunnerDownloadURI -eq $DownloadURI } { Copy-Item -Path $LocalRunnerZipLocation -Destination $OutFile }

			Install-GitHubActionsRunner -InstallationFolder $InstallationFolder -RunnerDownloadURI $DownloadURI

			Test-Path (Join-Path -Path $InstallationFolder -ChildPath "hello.txt") | Should Be $true

		} finally {

			Remove-Item -Force -Recurse $InstallationFolder
		}
	}
}