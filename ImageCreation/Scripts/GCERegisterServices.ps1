$here = Split-Path -Parent $MyInvocation.MyCommand.Path

. $here\..\Tools\Scripts\Register-AutoStartService.ps1

Write-Host "Registering GitHub Actions Runner script as autostarting..."

Register-AutoStartService -NssmLocation $here\..\..\Runtime\Tools\nssm.exe -ServiceName "GitHubActionsRunner" -Program "powershell" -Arguments (Resolve-Path $here\..\..\Runtime\Scripts\GCEService.ps1)

Write-Host "Done."
