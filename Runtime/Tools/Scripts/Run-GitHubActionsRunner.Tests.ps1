. ${PSScriptRoot}\Ensure-TestToolVersions.ps1

BeforeAll {

	. ${PSScriptRoot}\Run-GitHubActionsRunner.ps1

}

Describe 'Run-GitHubActionsRunner' {

	It "Launches run.cmd" {

		Mock Start-Process { }

		Run-GitHubActionsRunner -GitHubActionsInstallationFolder "C:\Test"

		Assert-MockCalled Start-Process -ParameterFilter { $FilePath -eq "C:\Test\run.cmd" } 
	}
}