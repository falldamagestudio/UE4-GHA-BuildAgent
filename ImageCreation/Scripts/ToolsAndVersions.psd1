@{
    GitHubActionsRunnerDownloadURI = "https://github.com/actions/runner/releases/download/v2.278.0/actions-runner-win-x64-2.278.0.zip"
    GitForWindowsDownloadURI = "https://github.com/git-for-windows/git/releases/download/v2.32.0.windows.2/Git-2.32.0.2-64-bit.exe"
    WindowsSDKDownloadURI = "https://go.microsoft.com/fwlink/p/?linkid=2120843"
    DirectXEndUserRuntimeWebInstallerDownloadURI = "https://download.microsoft.com/download/1/7/1/1718CCC4-6315-4D8E-9543-8E28A4E18C4C/dxwebsetup.exe"
    GCELoggingAgentInstallerDownloadURI = "https://dl.google.com/cloudagents/windows/StackdriverLogging-v1-11.exe"

    VisualStudioBuildToolsDownloadURI = "https://aka.ms/vs/16/release/vs_buildtools.exe" # Visual Studio 2019

    VisualStudioBuildTools_WorkloadsAndComponents = @(
        "Microsoft.VisualStudio.Workload.VCTools"
        "Microsoft.VisualStudio.Component.VC.Tools.x86.x64"
        "Microsoft.VisualStudio.Workload.ManagedDesktopBuildTools"	# Required to get PDBCOPY.EXE, which in turn is applied to all PDB files
        "Microsoft.VisualStudio.Component.Windows10SDK.18362"
        "Microsoft.Net.Component.4.6.2.TargetingPack"	# Required when building AutomationTool
        "Microsoft.Net.Component.4.5.TargetingPack"	# Required when building SwarmCoordinator
    )
}