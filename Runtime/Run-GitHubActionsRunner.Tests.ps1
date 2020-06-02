$here = Split-Path -Parent $MyInvocation.MyCommand.Path
$sut = (Split-Path -Leaf $MyInvocation.MyCommand.Path) -replace '\.Tests\.', '.'
. "$here\$sut"

Describe 'Run-GitHubActionsRunner' {

	It "Launches run.cmd" {

		Mock Start-Process { }

		Run-GitHubActionsRunner -GitHubActionsInstallationFolder "C:\Test"

		Assert-MockCalled Start-Process -ParameterFilter { $FilePath -eq "C:\Test\run.cmd" } 
	}
}