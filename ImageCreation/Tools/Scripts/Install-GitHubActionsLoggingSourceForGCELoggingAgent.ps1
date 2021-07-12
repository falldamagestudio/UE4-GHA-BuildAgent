function Install-GitHubActionsLoggingSourceForGCELoggingAgent {

	<#
		.SYNOPSIS
		Configures the GCE Logging Agent to capture logs from the GitHub Actions runner
	#>

	param (
		[Parameter(Mandatory)] [string] $GitHubActionsRunnerInstallationFolder
	)

	$GitHubActionsRunnerInstallationFolderWithForwardSlashes = $GitHubActionsRunnerInstallationFolder -Replace "\\","/"

	$ConfTemplateFileLocation = Join-Path -Path $PSScriptRoot -ChildPath "GitHubActionsRunner.conf.template" -ErrorAction Stop

	# Determine GCE Logging Agent installation folder based on where its uninstaller executable is located
	# This will normally result in a path like C:\Program Files (x86)\Stackdriver\LoggingAgent
	$GCELoggingAgentInstallationFolder = (Get-ItemProperty -Path HKLM:\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall\GoogleStackdriverLoggingAgent -Name UninstallString -ErrorAction Stop).UninstallString | Split-Path -ErrorAction Stop

	$ConfFile = (Get-Content $ConfTemplateFileLocation -ErrorAction Stop) -Replace "\[GITHUB_ACTIONS_RUNNER_INSTALL_FOLDER_WITH_FORWARD_SLASHES\]",$GitHubActionsRunnerInstallationFolderWithForwardSlashes -Replace "\[STACKDRIVER_LOGGING_AGENT_INSTALL_FOLDER\]",$GCELoggingAgentInstallationFolder

	$ConfFileLocation = Join-Path -Path $GCELoggingAgentInstallationFolder -ChildPath "config.d\GitHubActionsRunner.conf" -ErrorAction Stop

	$ConfFile | Out-File -FilePath $ConfFileLocation -Encoding ASCII -ErrorAction Stop
}
