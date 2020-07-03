$here = Split-Path -Parent $MyInvocation.MyCommand.Path
$sut = (Split-Path -Leaf $MyInvocation.MyCommand.Path) -replace '\.Tests\.', '.'
. "$here\$sut"

Describe 'Configure-GitHubActionsRunner' {

	It "Removes config file if a runner with the same name does not exist in the repo" {

		Mock Invoke-RestMethod { if ($Uri -eq "https://api.github.com/repos/DefaultOrg/DefaultRepo/actions/runners") {
			return '
				{
				  "total_count": 2,
				  "runners": [
					{
					  "id": 23,
					  "name": "MBP",
					  "os": "macos",
					  "status": "online"
					},
					{
					  "id": 24,
					  "name": "iMac",
					  "os": "macos",
					  "status": "offline"
					}
				  ]
				} ' | ConvertFrom-Json
			} else { throw } }
		Mock Test-Path { return $true }
		Mock Invoke-WebRequest { throw }

		Mock Remove-Item { }

		Configure-GitHubActionsRunner -GitHubActionsInstallationFolder "C:\Test" -GitHubPAT "NotSet" -GitHubScope "DefaultOrg/DefaultRepo" -AgentName "DefaultAgent"

		Assert-MockCalled Test-Path -ParameterFilter { $Path.EndsWith(".runner" ) } 
		Assert-MockCalled Remove-Item -ParameterFilter { $Path.EndsWith(".runner" ) } 
	}

	It "Skips initialization when a config file already exists" {

		Mock Invoke-RestMethod { if ($Uri -eq "https://api.github.com/repos/DefaultOrg/DefaultRepo/actions/runners") {
			return '
				{
				  "total_count": 2,
				  "runners": [
					{
					  "id": 23,
					  "name": "DefaultAgent",
					  "os": "macos",
					  "status": "online"
					},
					{
					  "id": 24,
					  "name": "iMac",
					  "os": "macos",
					  "status": "offline"
					}
				  ]
				} ' | ConvertFrom-Json
			} else { throw } }
		Mock Test-Path { return $true }
		Mock Invoke-WebRequest { throw }

		Configure-GitHubActionsRunner -GitHubActionsInstallationFolder "C:\Test" -GitHubPAT "NotSet" -GitHubScope "DefaultOrg/DefaultRepo" -AgentName "DefaultAgent"

		Assert-MockCalled Test-Path -ParameterFilter { $Path.EndsWith(".runner" ) } 
	}

	It "Retrieves a token for a repo at github.com" {

		$MyOrgAndRepo = "DefaultOrg/DefaultRepo"
		$MyPAT = "1234"

		Mock Invoke-RestMethod { if ($Uri -eq "https://api.github.com/repos/DefaultOrg/DefaultRepo/actions/runners") {
			return '
				{
				  "total_count": 2,
				  "runners": [
					{
					  "id": 23,
					  "name": "DefaultAgent",
					  "os": "macos",
					  "status": "online"
					},
					{
					  "id": 24,
					  "name": "iMac",
					  "os": "macos",
					  "status": "offline"
					}
				  ]
				} ' | ConvertFrom-Json
			} else { throw } }
		Mock Test-Path { return $false }
		Mock Invoke-WebRequest { return '{ "Token": "abcdef" }' }
		Mock Start-Process { }

		Configure-GitHubActionsRunner -GitHubActionsInstallationFolder "C:\Test" -GitHubPAT $MyPAT -GitHubScope $MyOrgAndRepo -AgentName "DefaultAgent"

		Assert-MockCalled Test-Path
		Assert-MockCalled Invoke-WebRequest -ParameterFilter { ($Uri -eq "https://api.github.com/repos/${MyOrgAndRepo}/actions/runners/registration-token") -and ($Headers["authorization"] -eq "token ${MyPAT}") }
		Assert-MockCalled Start-Process
	}

	It "Retrieves a token for an org at github.com" {

		$MyOrgAndRepo = "DefaultOrg"
		$MyPAT = "1234"

		Mock Invoke-RestMethod { if ($Uri -eq "https://api.github.com/orgs/DefaultOrg/actions/runners") {
			return '
				{
				  "total_count": 2,
				  "runners": [
					{
					  "id": 23,
					  "name": "DefaultAgent",
					  "os": "macos",
					  "status": "online"
					},
					{
					  "id": 24,
					  "name": "iMac",
					  "os": "macos",
					  "status": "offline"
					}
				  ]
				} ' | ConvertFrom-Json
			} else { throw } }
		Mock Test-Path { return $false }
		Mock Invoke-WebRequest { return '{ "Token": "abcdef" }' }
		Mock Start-Process { }

		Configure-GitHubActionsRunner -GitHubActionsInstallationFolder "C:\Test" -GitHubPAT $MyPAT -GitHubScope $MyOrgAndRepo -AgentName "DefaultAgent"

		Assert-MockCalled Test-Path
		Assert-MockCalled Invoke-WebRequest -ParameterFilter { ($Uri -eq "https://api.github.com/orgs/${MyOrgAndRepo}/actions/runners/registration-token") -and ($Headers["authorization"] -eq "token ${MyPAT}") }
		Assert-MockCalled Start-Process
	}

	It "Retrieves a token for a repo at a GitHub Enterprise site" {

		$MyOrgAndRepo = "DefaultOrg/DefaultRepo"
		$MyPAT = "1234"
		$GitHubHostname = "mygithub.com"

		Mock Invoke-RestMethod { if ($Uri -eq "https://mygithub.com/api/v3/repos/DefaultOrg/DefaultRepo/actions/runners") {
			return '
				{
				  "total_count": 2,
				  "runners": [
					{
					  "id": 23,
					  "name": "DefaultAgent",
					  "os": "macos",
					  "status": "online"
					},
					{
					  "id": 24,
					  "name": "iMac",
					  "os": "macos",
					  "status": "offline"
					}
				  ]
				} ' | ConvertFrom-Json
			} else { throw } }
		Mock Test-Path { return $false }
		Mock Invoke-WebRequest { return '{ "Token": "abcdef" }' }
		Mock Start-Process { }

		Configure-GitHubActionsRunner -GitHubActionsInstallationFolder "C:\Test" -GitHubPAT $MyPAT -GitHubScope $MyOrgAndRepo -GitHubHostname $GitHubHostname -AgentName "DefaultAgent"

		Assert-MockCalled Test-Path
		Assert-MockCalled Invoke-WebRequest -ParameterFilter { ($Uri -eq "https://$GitHubHostname/api/v3/repos/${MyOrgAndRepo}/actions/runners/registration-token") -and ($Headers["authorization"] -eq "token ${MyPAT}") }
		Assert-MockCalled Start-Process
	}

	It "Runs config.cmd with appropriate arguments for a repo at github.com" {

		$MyOrgAndRepo = "DefaultOrg/DefaultRepo"
		$MyPAT = "1234"

		Mock Invoke-RestMethod { if ($Uri -eq "https://api.github.com/repos/DefaultOrg/DefaultRepo/actions/runners") {
			return '
				{
				  "total_count": 2,
				  "runners": [
					{
					  "id": 23,
					  "name": "DefaultAgent",
					  "os": "macos",
					  "status": "online"
					},
					{
					  "id": 24,
					  "name": "iMac",
					  "os": "macos",
					  "status": "offline"
					}
				  ]
				} ' | ConvertFrom-Json
			} else { throw } }
		Mock Test-Path { return $false }
		Mock Invoke-WebRequest { return '{ "Token": "abcdef" }' }
		Mock Start-Process { }

		Configure-GitHubActionsRunner -GitHubActionsInstallationFolder "C:\Test" -GitHubPAT $MyPAT -GitHubScope $MyOrgAndRepo -AgentName "DefaultAgent"

		Assert-MockCalled Test-Path
		Assert-MockCalled Invoke-WebRequest
		Assert-MockCalled Start-Process -ParameterFilter { ($FilePath -eq "C:\Test\config.cmd") -and ($ArgumentList.Contains("--unattended")) -and ($ArgumentList.Contains("https://github.com/${MyOrgAndRepo}")) -and ($ArgumentList.Contains("abcdef"))}
	}

	It "Runs config.cmd with appropriate arguments for a repo at a GitHub Enterprise site" {

		$MyOrgAndRepo = "DefaultOrg/DefaultRepo"
		$MyPAT = "1234"
		$GitHubHostname = "mygithub.com"

		Mock Invoke-RestMethod { if ($Uri -eq "https://mygithub.com/api/v3/repos/DefaultOrg/DefaultRepo/actions/runners") {
			return '
				{
				  "total_count": 2,
				  "runners": [
					{
					  "id": 23,
					  "name": "DefaultAgent",
					  "os": "macos",
					  "status": "online"
					},
					{
					  "id": 24,
					  "name": "iMac",
					  "os": "macos",
					  "status": "offline"
					}
				  ]
				} ' | ConvertFrom-Json
			} else { throw } }
		Mock Test-Path { return $false }
		Mock Invoke-WebRequest { return '{ "Token": "abcdef" }' }
		Mock Start-Process { }

		Configure-GitHubActionsRunner -GitHubActionsInstallationFolder "C:\Test" -GitHubPAT $MyPAT -GitHubScope $MyOrgAndRepo -GitHubHostname $GitHubHostname -AgentName "DefaultAgent"

		Assert-MockCalled Test-Path
		Assert-MockCalled Invoke-WebRequest
		Assert-MockCalled Start-Process -ParameterFilter { ($FilePath -eq "C:\Test\config.cmd") -and ($ArgumentList.Contains("--unattended")) -and ($ArgumentList.Contains("https://mygithub.com/${MyOrgAndRepo}")) -and ($ArgumentList.Contains("abcdef"))}
	}

	It "Sets agent name" {

		$MyOrgAndRepo = "DefaultOrg/DefaultRepo"
		$MyPAT = "1234"
		$AgentName = "MyAgent"

		Mock Invoke-RestMethod { if ($Uri -eq "https://api.github.com/repos/DefaultOrg/DefaultRepo/actions/runners") {
			return '
				{
				  "total_count": 2,
				  "runners": [
					{
					  "id": 23,
					  "name": "MyAgent",
					  "os": "macos",
					  "status": "online"
					},
					{
					  "id": 24,
					  "name": "iMac",
					  "os": "macos",
					  "status": "offline"
					}
				  ]
				} ' | ConvertFrom-Json
			} else { throw } }
		Mock Test-Path { return $false }
		Mock Invoke-WebRequest { return '{ "Token": "abcdef" }' }
		Mock Start-Process { }

		Configure-GitHubActionsRunner -GitHubActionsInstallationFolder "C:\Test" -GitHubPAT $MyPAT -GitHubScope $MyOrgAndRepo -AgentName $AgentName

		Assert-MockCalled Test-Path
		Assert-MockCalled Invoke-WebRequest
		Assert-MockCalled Start-Process -ParameterFilter { ($FilePath -eq "C:\Test\config.cmd") -and ($ArgumentList.Contains($AgentName)) }
	}
}