$here = Split-Path -Parent $MyInvocation.MyCommand.Path
$sut = (Split-Path -Leaf $MyInvocation.MyCommand.Path) -replace '\.Tests\.', '.'
. "$here\$sut"

Describe 'Get-GitForWindowsLatestVersionURI' {

	It "Retrieves the latest version from the GitHub Releases page" {

		Mock Invoke-WebRequest -ParameterFilter { $Uri -eq "https://api.github.com/repos/git-for-windows/git/releases/latest" } { @{
			Content = Get-Content "${here}/Get-GitForWindowsLatestVersionURI.Tests.json"
		} }

		$LatestVersionDownloadURI = Get-GitForWindowsLatestVersionURI

		$LatestVersionDownloadURI | Should Be "https://github.com/git-for-windows/git/releases/download/v2.26.2.windows.1/Git-2.26.2-64-bit.exe"
	}
}