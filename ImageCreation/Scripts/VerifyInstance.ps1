$here = Split-Path -Parent $MyInvocation.MyCommand.Path

Describe 'VerifyInstance' {

	It "Has Win32 Long Paths enabled" {
		$LongPathsEnabled = (Get-ItemProperty -path HKLM:\SYSTEM\CurrentControlSet\Control\FileSystem -name "LongPathsEnabled").LongPathsEnabled
		$LongPathsEnabled | Should Not Be 0
	}

	It "Has Git available on the command line" {
		Start-Process -FilePath "Git" -ArgumentList "--version" -NoNewWindow -Wait
	}

	It "Has GitHub Actions tools available" {
	
		$GitHubActionsInstallationFolder = "C:\A"
	
		Test-Path (Join-Path -Path $GitHubActionsInstallationFolder -ChildPath "config.cmd") | Should Be $true
		Test-Path (Join-Path -Path $GitHubActionsInstallationFolder -ChildPath "run.cmd") | Should Be $true
	}
	
	It "Has Visual Studio (IDE or Build Tools, any version) installed" {
		$Result = & "${env:ProgramFiles(x86)}\Microsoft Visual Studio\Installer\vswhere.exe" "-products" '*' "-format" "json" | ConvertFrom-Json
		$LASTEXITCODE | Should Be 0
		$Result.Length | Should Not Be 0
	}
	
	It "Has GitHub Actions Runner registered as a service" {
		$Service = Get-Service "GitHubActionsRunner"
		$Service | Should Not Be $null
	}
}