
function Configure-GitHubActionsRunner {

	<#
		.SYNOPSIS
		Runs GitHub Actions runner configuration script, if the runner isn't already configured.
	#>

	param (
		[Parameter(Mandatory)] [string] $GitHubActionsInstallationFolder,
		[Parameter(Mandatory)] [string] $GitHubPAT,
		[Parameter(Mandatory)] [string] $GitHubScope,
		[Parameter(Mandatory=$false)] [string] $GitHubHostname,
		[Parameter(Mandatory=$false)] [string] $AgentName
	)

	if (!(Test-Path (Join-Path -Path $GitHubActionsInstallationFolder -ChildPath ".runner"))) {
		Write-Host "Runner is not configured; running configuration script"

		$GitHubApiUrl = if ($PSBoundParameters.ContainsKey('GitHubHostname')) { "https://${GitHubHostname}/api/v3" } else { "https://api.github.com" }

		# if the scope has a slash, it's a repo runner 
		$OrgsOrRepos = if ($GitHubScope -match "/") { "repos" } else { "orgs" }

		$GetTokenURI = "${GitHubApiUrl}/${OrgsOrRepos}/${GitHubScope}/actions/runners/registration-token"

		$GetTokenHeaders = @{
			"accept" = "application/vnd.github.everest-preview+json"
			"authorization" = "token ${GitHubPAT}"
		}

		$Token = (Invoke-WebRequest -UseBasicParsing -Uri $GetTokenURI -Headers $GetTokenHeaders -Method Post | ConvertFrom-Json).Token

		$RegistrationURI = if ($PSBoundParameters.ContainsKey('GitHubHostname')) { "https://${GitHubHostname}/${GitHubScope}" } else { "https://github.com/${GitHubScope}" }

		$Arguments = @(
			"--unattended"
			"--url"
			$RegistrationURI
			"--token"
			$Token
		)

		if ($PSBoundParameters.ContainsKey('AgentName')) {
			$Arguments += "--name"
			$Arguments += $AgentName
		}

		Start-Process -FilePath (Join-Path -Path $GitHubActionsInstallationFolder -ChildPath "config.cmd") -ArgumentList $Arguments
	}
}
