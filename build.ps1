<#
.Description
Installs and loads all the required modules for the build.
Derived from the PSGraphPlus repo (https://github.com/KevinMarquette/PSGraphPlus)
#>

[CmdletBinding()]
param (
    [Parameter()]
    [ValidateNotNullOrEmpty()]
    [string]
    $Task = 'Default'
)

Set-StrictMode -Version 2.0

Write-Output "Starting build"

Write-Output "  Install Dependent Modules for CI"
try {
    Save-Module -Name PSDepend -Path "$PSScriptRoot/Dependencies" -RequiredVersion 0.3.2 -Force
    Import-Module -Name "$PSScriptRoot/Dependencies/PSDepend" -Force
    Invoke-PSDepend -Path "$PSScriptRoot/Development.depend.psd1" -Install -Import -Force
}
catch {
    Write-Output $_.Exception.Message
    Write-Output $_.ScriptStackTrace
    exit 1
}

Write-Output "  Configure Environment"
Set-BuildEnvironment -Force -Verbose

$params = @{
    Result = 'Result'
}

Write-Output "  InvokeBuild"
try {
    Invoke-Build $Task @params
    if ($Result.Error)
    {
        exit 1
    }
}
catch {
    Write-Output $_.Exception.Message
    Write-Output $_.ScriptStackTrace
    exit 1
}


