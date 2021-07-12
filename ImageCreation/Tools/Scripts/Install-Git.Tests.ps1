. ${PSScriptRoot}\Ensure-TestToolVersions.ps1

BeforeAll {

	. ${PSScriptRoot}\Install-Git.ps1

}

Describe 'Install-Git' {

	It "Fetches and installs git" {

		$InstallerDownloadURI = "https://examplesite.com/GitInstaller.exe"

		$LocalRunnerZipLocation = "C:\Temp\GitInstaller.exe"

		$CachedOutFile = $null

		Mock New-Item { }

		Mock Invoke-WebRequest -ParameterFilter { $InstallerDownloadURI -eq $InstallerDownloadURI } { $CachedOutFile = $OutFile }
		Mock Invoke-WebRequest { throw "Invalid Invoke-WebRequest invocation" }

		Mock Start-Process -ParameterFilter { $FilePath -eq $LocalRunnerZipLocation } { }
		Mock Start-Process { throw "Invalid Start-Process invocation" }

		Mock Remove-Item { }

		Install-Git -InstallerDownloadURI $InstallerDownloadURI

		Assert-MockCalled New-Item
		Assert-MockCalled Invoke-WebRequest
		Assert-MockCalled Start-Process
		Assert-MockCalled Remove-Item
	}
}