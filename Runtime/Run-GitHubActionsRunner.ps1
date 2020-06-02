
function Run-GitHubActionsRunner {

	<#
		.SYNOPSIS
		Runs GitHub Actions runner worker
	#>

	param (
		[Parameter(Mandatory)] [string] $GitHubActionsInstallationFolder
	)

    Start-Process -FilePath (Join-Path -Path $GitHubActionsInstallationFolder -ChildPath "run.cmd") -Wait -NoNewWindow
}
