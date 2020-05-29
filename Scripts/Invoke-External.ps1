# Helper function for invoking an external utility (executable).
# The raison d'être for this function is to allow 
# calls to external executables via their *full paths* to be mocked in Pester.
function Invoke-External {
  param(
    [Parameter(Mandatory=$true)]
    [string] $LiteralPath,
    [Parameter(ValueFromRemainingArguments=$true)]
    $PassThruArgs
  )
  & $LiteralPath $PassThruArgs
}