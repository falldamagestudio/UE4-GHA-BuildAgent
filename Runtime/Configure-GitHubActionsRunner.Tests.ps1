$here = Split-Path -Parent $MyInvocation.MyCommand.Path
$sut = (Split-Path -Leaf $MyInvocation.MyCommand.Path) -replace '\.Tests\.', '.'
. "$here\$sut"

Describe 'Configure-GitHubActionsRunner' {

	It "Skips initialization when a config file already exists" {

		Mock Test-Path { return $true }
		Mock Invoke-WebRequest { throw }

		Configure-GitHubActionsRunner -GitHubActionsInstallationFolder "C:\Test" -GitHubPAT "NotSet" -GitHubScope "NotSet"

		Assert-MockCalled Test-Path -ParameterFilter { $Path.EndsWith(".runner" ) } 
	}

	It "Retrieves a token for a repo at github.com" {

		$MyOrgAndRepo = "testorg/testrepo"
		$MyPAT = "1234"

		Mock Test-Path { return $false }
		Mock Invoke-WebRequest { return '{ "Token": "abcdef" }' }
		Mock Start-Process { }

		Configure-GitHubActionsRunner -GitHubActionsInstallationFolder "C:\Test" -GitHubPAT $MyPAT -GitHubScope $MyOrgAndRepo

		Assert-MockCalled Test-Path
		Assert-MockCalled Invoke-WebRequest -ParameterFilter { ($Uri -eq "https://api.github.com/repos/${MyOrgAndRepo}/actions/runners/registration-token") -and ($Headers["authorization"] -eq "token ${MyPAT}") }
		Assert-MockCalled Start-Process
	}

	It "Retrieves a token for an org at github.com" {

		$MyOrgAndRepo = "testorg"
		$MyPAT = "1234"

		Mock Test-Path { return $false }
		Mock Invoke-WebRequest { return '{ "Token": "abcdef" }' }
		Mock Start-Process { }

		Configure-GitHubActionsRunner -GitHubActionsInstallationFolder "C:\Test" -GitHubPAT $MyPAT -GitHubScope $MyOrgAndRepo

		Assert-MockCalled Test-Path
		Assert-MockCalled Invoke-WebRequest -ParameterFilter { ($Uri -eq "https://api.github.com/orgs/${MyOrgAndRepo}/actions/runners/registration-token") -and ($Headers["authorization"] -eq "token ${MyPAT}") }
		Assert-MockCalled Start-Process
	}

	It "Retrieves a token for a repo at a GitHub Enterprise site" {

		$MyOrgAndRepo = "testorg/testrepo"
		$MyPAT = "1234"
		$GitHubHostname = "mygithub.com"

		Mock Test-Path { return $false }
		Mock Invoke-WebRequest { return '{ "Token": "abcdef" }' }
		Mock Start-Process { }

		Configure-GitHubActionsRunner -GitHubActionsInstallationFolder "C:\Test" -GitHubPAT $MyPAT -GitHubScope $MyOrgAndRepo -GitHubHostname $GitHubHostname

		Assert-MockCalled Test-Path
		Assert-MockCalled Invoke-WebRequest -ParameterFilter { ($Uri -eq "https://$GitHubHostname/api/v3/repos/${MyOrgAndRepo}/actions/runners/registration-token") -and ($Headers["authorization"] -eq "token ${MyPAT}") }
		Assert-MockCalled Start-Process
	}

	It "Runs config.cmd with appropriate arguments for a repo at github.com" {

		$MyOrgAndRepo = "testorg/testrepo"
		$MyPAT = "1234"

		Mock Test-Path { return $false }
		Mock Invoke-WebRequest { return '{ "Token": "abcdef" }' }
		Mock Start-Process { }

		Configure-GitHubActionsRunner -GitHubActionsInstallationFolder "C:\Test" -GitHubPAT $MyPAT -GitHubScope $MyOrgAndRepo

		Assert-MockCalled Test-Path
		Assert-MockCalled Invoke-WebRequest
		Assert-MockCalled Start-Process -ParameterFilter { ($FilePath -eq "C:\Test\config.cmd") -and ($ArgumentList.Contains("--unattended")) -and ($ArgumentList.Contains("https://github.com/${MyOrgAndRepo}")) -and ($ArgumentList.Contains("abcdef"))}
	}

	It "Runs config.cmd with appropriate arguments for a repo at a GitHub Enterprise site" {

		$MyOrgAndRepo = "testorg/testrepo"
		$MyPAT = "1234"
		$GitHubHostname = "mygithub.com"

		Mock Test-Path { return $false }
		Mock Invoke-WebRequest { return '{ "Token": "abcdef" }' }
		Mock Start-Process { }

		Configure-GitHubActionsRunner -GitHubActionsInstallationFolder "C:\Test" -GitHubPAT $MyPAT -GitHubScope $MyOrgAndRepo -GitHubHostname $GitHubHostname

		Assert-MockCalled Test-Path
		Assert-MockCalled Invoke-WebRequest
		Assert-MockCalled Start-Process -ParameterFilter { ($FilePath -eq "C:\Test\config.cmd") -and ($ArgumentList.Contains("--unattended")) -and ($ArgumentList.Contains("https://mygithub.com/${MyOrgAndRepo}")) -and ($ArgumentList.Contains("abcdef"))}
	}

	It "Sets agent name when provided" {

		$MyOrgAndRepo = "testorg/testrepo"
		$MyPAT = "1234"
		$AgentName = "MyAgent"

		Mock Test-Path { return $false }
		Mock Invoke-WebRequest { return '{ "Token": "abcdef" }' }
		Mock Start-Process { }

		Configure-GitHubActionsRunner -GitHubActionsInstallationFolder "C:\Test" -GitHubPAT $MyPAT -GitHubScope $MyOrgAndRepo -AgentName $AgentName

		Assert-MockCalled Test-Path
		Assert-MockCalled Invoke-WebRequest
		Assert-MockCalled Start-Process -ParameterFilter { ($FilePath -eq "C:\Test\config.cmd") -and ($ArgumentList.Contains($AgentName)) }
	}
}