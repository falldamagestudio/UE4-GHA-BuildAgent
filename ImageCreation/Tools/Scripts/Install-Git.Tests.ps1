$here = Split-Path -Parent $MyInvocation.MyCommand.Path
$sut = (Split-Path -Leaf $MyInvocation.MyCommand.Path) -replace '\.Tests\.', '.'
. "$here\$sut"

Describe 'Install-Git' {

	It "Fetches and installs git" {

		$InstallerDownloadURI = "https://examplesite.com/GitInstaller.exe"

		$LocalRunnerZipLocation = "C:\Temp\GitInstaller.exe"

		$CachedOutFile = $null

		Mock Invoke-WebRequest -ParameterFilter { $DownloadURI -eq $InstallerDownloadURI } { $CachedOutFile = $OutFile }

		Mock Start-Process -ParameterFilter { $FilePath -eq $LocalRunnerZipLocation } { }

		Install-Git -DownloadURI $InstallerDownloadURI
	}
}