$here = Split-Path -Parent $MyInvocation.MyCommand.Path
$sut = (Split-Path -Leaf $MyInvocation.MyCommand.Path) -replace '\.Tests\.', '.'
. "$here\$sut"

Describe 'Resize-PartitionToMaxSize' {

	It "Grows partition when there is available unallocated disk space" {

		$CurrentSize = 50000000
		$MaxSize = 200000000
		$Drive = "C"

		Mock Get-Partition -ParameterFilter { $DriveLetter -eq $Drive } { @{
			DiskPath = "\\?\scsi#disk&ven_google&prod_persistentdisk#4&21cb0360&0&000100#{53f56307-b6bf-11d0-94f2-00a0c91efb8b}";
			DiskId = "\\?\scsi#disk&ven_google&prod_persistentdisk#4&21cb0360&0&000100#{53f56307-b6bf-11d0-94f2-00a0c91efb8b}";
			DiskNumber = 0;
			DriveLetter = $DriveLetter;
			Offset = 121634816;
			Size = $CurrentSize
		} }

		Mock Get-PartitionSupportedSize -ParameterFilter { $DriveLetter -eq $Drive } { @{
			SizeMin = $CurrentSize;
			SizeMax = $MaxSize
		} }

		Mock Resize-Partition -ParameterFilter { $DriveLetter -eq $Drive } { }

		Resize-PartitionToMaxSize -DriveLetter $Drive
		
		Assert-MockCalled Resize-Partition -ParameterFilter { ($DriveLetter -eq $Drive) -and ($Size -eq $MaxSize) }
	}

	It "Does not resize partition when there is no unallocated disk space available" {

		$CurrentSize = 100000000
		$MaxSize = $CurrentSize
		$Drive = "C"

		Mock Get-Partition -ParameterFilter { $DriveLetter -eq $Drive } { @{
			DiskPath = "\\?\scsi#disk&ven_google&prod_persistentdisk#4&21cb0360&0&000100#{53f56307-b6bf-11d0-94f2-00a0c91efb8b}";
			DiskId = "\\?\scsi#disk&ven_google&prod_persistentdisk#4&21cb0360&0&000100#{53f56307-b6bf-11d0-94f2-00a0c91efb8b}";
			DiskNumber = 0;
			DriveLetter = $DriveLetter;
			Offset = 121634816;
			Size = $CurrentSize
		} }

		Mock Get-PartitionSupportedSize -ParameterFilter { $DriveLetter -eq $Drive } { @{
			SizeMin = $CurrentSize;
			SizeMax = $MaxSize
		} }

		Resize-PartitionToMaxSize -DriveLetter $Drive

		Mock Resize-Partition -ParameterFilter { $DriveLetter -eq $Drive } { throw }
	}
}