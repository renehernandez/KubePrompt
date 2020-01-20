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

# Grab nuget bits, install modules, set build variables, start build.
Write-Output "  Install Dependent Modules for CI"
try {
    Get-PackageProvider -Name NuGet -ForceBootstrap | Out-Null
    Save-Module -Name PSDepend -Path "$PSScriptRoot/Dependencies" -RequiredVersion 0.3.2 -Force
    Import-Module -Name "$PSScriptRoot/Dependencies/PSDepend" -Force
    Invoke-PSDepend -Path "$PSScriptRoot/Development.depend.psd1" -Install -Import -Force
}
catch {
    Write-Error $_
    exit 1
}

Write-Output "  Set Build Environment"
Set-BuildEnvironment -Force

if (($env:BHBranchName -eq 'HEAD') -and (-not [string]::IsNullOrEmpty($env:BRANCH_NAME))) {
    Write-Output "  Update BHBranchName envvar"
    $env:BHBranchName = $env:BRANCH_NAME
}

$params = @{
    Result = 'Result'
}

Write-Output "  InvokeBuild"
Invoke-Build $Task @params

if ($Result.Error)
{
    exit 1
}
else
{
    exit 0
}
