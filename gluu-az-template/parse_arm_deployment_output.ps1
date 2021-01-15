[CmdletBinding()]
param (
    [Parameter(Mandatory)]
    [ValidateNotNullOrEmpty()]
    [string]$ArmOutputString,

    [Parameter()]
    [ValidateNotNullOrEmpty()]
    [switch]$MakeOutput
)

Write-Output "Retrieved input: $ArmOutputString"
$armOutputObj = $ArmOutputString | ConvertFrom-Json

$armOutputObj.PSObject.Properties | ForEach-Object {
    $type = ($_.value.type).ToLower()
    $keyname = $_.Name
    $vsoAttribs = @("task.setvariable variable=$keyName")
    Write-Output = $vsoAttribs

    if ($type -eq "array") {
        $value = $_.Value.value.name -join ',' ## All array variables will come out as comma-separated strings
    } elseif ($type -eq "securestring") {
        $vsoAttribs += 'isSecret=true'
    } elseif ($type -ne "string") {
        throw "Type '$type' is not supported for '$keyname'"
    } else {
        Write-Output = "not yet stored $_.Value.value"
        $value = $_.Value.value
        Write-Output = "value is stored in $value"
    }
    Write-Output = " Before Markoutput"
    if ($MakeOutput.IsPresent) {
        $vsoAttribs += 'isOutput=true'
    }
    Write-Output = "after the if check of markoutput"
    $vsoAttribs += 'isOutput=true'
    Write-Output = $vsoAttribs
    $attribString = $vsoAttribs -join ';'

    Write-Output = $attribString

    $var = "##vso[$attribString]$value"
    
    Write-Output = $var
    
    Write-Output -InputObject $var
}