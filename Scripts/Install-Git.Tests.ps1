$here = Split-Path -Parent $MyInvocation.MyCommand.Path
$sut = (Split-Path -Leaf $MyInvocation.MyCommand.Path) -replace '\.Tests\.', '.'
. "$here\$sut"

. "$here\Invoke-External.ps1"

Describe 'Install-Git' {

	It "Fetches and installs git" {

		$InstallerDownloadURI = "https://examplesite.com/GitInstaller.exe"

		$LocalRunnerZipLocation = "C:\Temp\GitInstaller.exe"

		$CachedOutFile = $null

		Mock Invoke-WebRequest -ParameterFilter { $DownloadURI -eq $InstallerDownloadURI } { $CachedOutFile = $OutFile }

		Mock Invoke-External -ParameterFilter { $LiteralPath -eq "${LocalRunnerZipLocation}" } { return $true }

		Install-Git -DownloadURI $InstallerDownloadURI
	}
}