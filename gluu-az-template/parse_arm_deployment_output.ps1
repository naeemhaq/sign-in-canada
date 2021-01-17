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
    Write-Output $vsoAttribs

    if ($type -eq "array") {
        $value = $_.Value.value.name -join ',' ## All array variables will come out as comma-separated strings
    } elseif ($type -eq "securestring") {
        $vsoAttribs += 'isSecret=true'
    } elseif ($type -ne "string") {
        throw "Type '$type' is not supported for '$keyname'"
    } else {
        Write-Host  "not yet stored $_.Value.value"
        $value = $_.Value.value
        Write-Host "value is stored in $value"
    }

    if ($MakeOutput.IsPresent) {
        $vsoAttribs += ';isOutput=true'
    }

    Write-Host $vsoAttribs
    #$attribString = $vsoAttribs -join ';'
    $var = "##vso[$attribString]$value"
    Write-Host $var
    Write-Output -InputObject $var
}