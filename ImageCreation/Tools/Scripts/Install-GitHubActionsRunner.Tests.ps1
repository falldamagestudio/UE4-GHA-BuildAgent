. ${PSScriptRoot}\Ensure-TestToolVersions.ps1

BeforeAll {

	. ${PSScriptRoot}\Install-GitHubActionsRunner.ps1

}

Describe 'Install-GitHubActionsRunner' {

	It "Fetches and installs runner" {

		$InstallationFolder = "${PSScriptRoot}/Runner"

		$DownloadURI = "https://examplesite.com/GitHubActionsRunner.zip"

		$LocalRunnerZipLocation = "${PSScriptRoot}/Install-GitHubActionsRunner.Tests.zip"

		try {

			Mock Invoke-WebRequest -ParameterFilter { $RunnerDownloadURI -eq $DownloadURI } { Copy-Item -Path $LocalRunnerZipLocation -Destination $OutFile }

			Install-GitHubActionsRunner -InstallationFolder $InstallationFolder -RunnerDownloadURI $DownloadURI

			Test-Path (Join-Path -Path $InstallationFolder -ChildPath "hello.txt") | Should -Be $true
			
		} finally {

			Remove-Item -Force -Recurse $InstallationFolder
		}
	}
}