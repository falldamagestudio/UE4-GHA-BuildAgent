function Get-GCEInstanceMetadata {

	<#
		.SYNOPSIS
		Reads the value of a GCE metadata tag for the current instance.
	#>

	param (
		[Parameter(Mandatory=$true)][string]$Key
	)

	$Result = Invoke-WebRequest -UseBasicParsing -uri "http://metadata.google.internal/computeMetadata/v1/instance/attributes/${Key}" -Headers @{ "Metadata-Flavor" = "Google" }

	if ($Result -ne $null) {
		return [System.Text.Encoding]::ASCII.GetString($Result.Content)
	} else {
		return $null
	}
}
