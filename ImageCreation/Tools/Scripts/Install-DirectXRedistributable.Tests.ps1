. ${PSScriptRoot}\Ensure-TestToolVersions.ps1

BeforeAll {

	. ${PSScriptRoot}\Install-DirectXRedistributable.ps1

}

Describe 'Install-DirectXRedistributable' {

	It "Reports error if temp folder cannot be created" {

        $InstallerDownloadURI = "https://exampledomain/installer.exe"

		Mock New-Item { throw "NewItem cannot be created" }

		Mock Join-Path { throw "Join-Path failed" }

		Mock Invoke-WebRequest { throw "Invoke-WebRequest failed" }

		Mock Remove-Item { }

		{ Install-DirectXRedistributable -InstallerDownloadURI $InstallerDownloadURI } |
			Should -Throw "NewItem cannot be created"

		Assert-MockCalled -Times 0 Remove-Item
	}

	It "Reports error if Join-Path fails, and removes temp folder" {

        $InstallerDownloadURI = "https://exampledomain/installer.exe"

		Mock New-Item { }

		Mock Join-Path { throw "Join-Path failed" }

		Mock Invoke-WebRequest { throw "Invoke-WebRequest failed" }

		Mock Remove-Item { }

		{ Install-DirectXRedistributable -InstallerDownloadURI $InstallerDownloadURI } |
			Should -Throw "Join-Path failed"

		Assert-MockCalled -Times 1 Remove-Item
	}

	It "Reports error if Invoke-WebRequest fails, and removes temp folder" {

        $InstallerDownloadURI = "https://exampledomain/installer.exe"

		Mock New-Item { }

		Mock Join-Path { "C:\ExamplePath" }

		Mock Invoke-WebRequest { throw "Invoke-WebRequest failed" }

		Mock Remove-Item { }

		{ Install-DirectXRedistributable -InstallerDownloadURI $InstallerDownloadURI } |
			Should -Throw "Invoke-WebRequest failed"

		Assert-MockCalled -Times 1 Remove-Item
	}

	It "Reports success if Start-Process returns zero, and removes temp folder" {

        $InstallerDownloadURI = "https://exampledomain/installer.exe"

		Mock New-Item { }

		Mock Join-Path { "C:\ExamplePath" }

		Mock Invoke-WebRequest { }

		Mock Start-Process { @{ ExitCode = 0 } }

		Mock Remove-Item { }

		{ Install-DirectXRedistributable -InstallerDownloadURI $InstallerDownloadURI } |
			Should -Not -Throw

		Assert-MockCalled -Times 1 Remove-Item
	}

	It "Reports error if Start-Process returns another exit code, and removes temp folder" {

        $InstallerDownloadURI = "https://exampledomain/installer.exe"

		Mock New-Item { }

		Mock Join-Path { "C:\ExamplePath" }

		Mock Invoke-WebRequest { }

		Mock Start-Process { @{ ExitCode = 1234 } }

		Mock Remove-Item { }

		{ Install-DirectXRedistributable -InstallerDownloadURI $InstallerDownloadURI } |
			Should -Throw

		Assert-MockCalled -Times 1 Remove-Item
	}

}