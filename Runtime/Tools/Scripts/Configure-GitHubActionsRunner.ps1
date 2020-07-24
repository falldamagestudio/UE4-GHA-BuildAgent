
function Configure-GitHubActionsRunner {

	<#
		.SYNOPSIS
		Runs GitHub Actions runner configuration script, if the runner isn't already configured.
	#>

	param (
		[Parameter(Mandatory)] [string] $GitHubActionsInstallationFolder,
		[Parameter(Mandatory)] [string] $GitHubPAT,
		[Parameter(Mandatory)] [string] $GitHubScope,
		[Parameter(Mandatory)] [string] $AgentName,
		[Parameter(Mandatory=$false)] [string] $GitHubHostname
	)

	$GitHubApiUrl = if ($PSBoundParameters.ContainsKey('GitHubHostname')) { "https://${GitHubHostname}/api/v3" } else { "https://api.github.com" }

	# if the scope has a slash, it's a repo runner 
	$OrgsOrRepos = if ($GitHubScope -match "/") { "repos" } else { "orgs" }

	$GitHubApiHeaders = @{
		"accept" = "application/vnd.github.everest-preview+json"
		"authorization" = "token ${GitHubPAT}"
	}

	$GetRunnersURI = "${GitHubApiUrl}/${OrgsOrRepos}/${GitHubScope}/actions/runners"

	$RunnerAgentNames = (Invoke-RestMethod -Uri $GetRunnersURI -Headers $GitHubApiHeaders -Method Get).runners | ForEach-Object { $_.name }

	$RunnerConfigFile = Join-Path -Path $GitHubActionsInstallationFolder -ChildPath ".runner"

	if ((($RunnerAgentNames -eq $null) -or !($RunnerAgentNames.Contains($AgentName))) -and (Test-Path $RunnerConfigFile)) {
		Write-Host "Runner is not registered with the GHA backend; removing local configuration"
		Remove-Item -Force $RunnerConfigFile
		Remove-Item -Force (Join-Path -Path $GitHubActionsInstallationFolder -ChildPath ".credentials_rsaparams")
		Remove-Item -Force (Join-Path -Path $GitHubActionsInstallationFolder -ChildPath ".credentials")
	}

	if (!(Test-Path $RunnerConfigFile)) {
		Write-Host "Runner is not configured; running configuration script"

		$GetTokenURI = "${GitHubApiUrl}/${OrgsOrRepos}/${GitHubScope}/actions/runners/registration-token"

		$Token = (Invoke-WebRequest -UseBasicParsing -Uri $GetTokenURI -Headers $GitHubApiHeaders -Method Post | ConvertFrom-Json).Token

		$RegistrationURI = if ($PSBoundParameters.ContainsKey('GitHubHostname')) { "https://${GitHubHostname}/${GitHubScope}" } else { "https://github.com/${GitHubScope}" }

		$Arguments = @(
			"--unattended"
			"--replace"
			"--url"
			$RegistrationURI
			"--token"
			$Token
		)

		$Arguments += "--name"
		$Arguments += $AgentName

		$Arguments += "--labels"
		$Arguments += $AgentName

		Start-Process -FilePath (Join-Path -Path $GitHubActionsInstallationFolder -ChildPath "config.cmd") -ArgumentList $Arguments -Wait -NoNewWindow
	}
}
