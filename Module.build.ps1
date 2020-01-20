#requires -Modules InvokeBuild, BuildHelpers, PSScriptAnalyzer, Pester, PlatyPS

Set-StrictMode -Version 2.0

function TaskX($Name, $Parameters) { task $Name @Parameters -Source $MyInvocation }

# Variables
$script:ModuleName = Get-ChildItem -File -Depth 1 -Filter *.psm1 | Select-Object -First 1 -ExpandProperty BaseName

$script:SourceDir = Join-Path -Path $BuildRoot -ChildPath 'Source'
$script:TestsDir = Join-Path -Path $BuildRoot -ChildPath 'Tests'
$script:OutputDir = Join-Path -Path $BuildRoot -ChildPath 'Output'
$script:HelpDir = Join-Path -Path $OutputDir -ChildPath 'Help'
$script:ManifestFile = Join-Path -Path $OutputDir -ChildPath '*/KubePrompt.psd1'

Task Default StaticAnalysis, Build, Tests
Task Build Clean, BuildModule
Task Tests UnitTests, IntegrationTests

# Synopsis: Cleans Output and Local Repository directories
Task Clean {
    if (Test-Path -Path $OutputDir) {
        Remove-Item $OutputDir -Recurse -ErrorAction Ignore | Out-Null
    }

    New-Item -Path $OutputDir -ItemType Directory -Force | Out-Null
}

# Synopsis: Run static analysis tests. Wraps PSScriptAnalyzer rules as pester tests
Task StaticAnalysis Clean, {
    $testFile = Join-Path -Path $TestsDir -ChildPath "StaticAnalysis.Tests.ps1"
    $testResults = Invoke-Pester -Path $testFile -PassThru -Strict -OutputFormat NUnitXml -OutputFile "$($TestsDir)\TestResults_StaticAnalysis.xml"

    if ($testResults.FailedCount -gt 0) {
        Write-Error "Failed [$($testResults.FailedCount)] Pester tests"
        $testResults | Format-List
    }
}

# Synopsis: Run unit tests if any. Unit tests are to be located at .\Tests\Unit folder in the repository
Task UnitTests ImportModule, {
    $unitTestsPath = Join-Path -Path $TestsDir -ChildPath "Unit"

    if (Test-Path -Path $unitTestsPath) {
        $testResults = Invoke-Pester -Path $unitTestsPath -PassThru -Strict -OutputFormat NUnitXml -OutputFile "$($TestsDir)\TestResults_Unit.xml"

        if ($testResults.FailedCount -gt 0) {
            Write-Error "Failed [$($testResults.FailedCount)] Pester tests"
            $testResults | Format-List
        }
    }
    else {
        Write-Verbose "Unit Tests not found"
    }
}

# Synopsis: Run integration tests if any. Integration tests are to be located at .\Tests\Integration folder in the repository
Task IntegrationTests ImportModule, {
    $integrationTestsPath = Join-Path -Path $TestsDir -ChildPath "Integration"

    if (Test-Path -Path $integrationTestsPath) {
        $testResults = Invoke-Pester -Path $integrationTestsPath -PassThru -Strict -OutputFormat NUnitXml -OutputFile "$($TestsDir)\TestResults_Integration.xml"

        if ($testResults.FailedCount -gt 0) {
            Write-Error "Failed [$($testResults.FailedCount)] Pester tests"
            $testResults | Format-List
        }
    }
    else {
        Write-Verbose "Integration Tests not found"
    }
}

Task BuildModule {
    Build-Module -SourcePath $SourceDir
}

Task ImportModule Build, {
    if ( -not (Test-Path $ManifestFile)) {
        Write-Information "  Module [$($ModuleName)] is not built, cannot find [$($ManifestFile)]"
        Write-Error "Could not find module manifest [$($ManifestFile)]. You may need to build the module first"
    }
    else {
        if (Get-Module $ModuleName) {
            Write-Information "  Unloading Module [$($ModuleName)] from previous import"
            Remove-Module $ModuleName -Force
        }

        Write-Information "  Importing Module [$($ModuleName)] from [$($ManifestFile)]"
        Import-Module $ManifestFile -Force -Global
    }
}

# Synopsis: Generates the nupkg file for the module ready to pushed to the remote repository
Task PublishToLocal Build, {
    Publish-Module -Name KubePrompt -NuGetApiKey $env:KubePromptApiKey
}

# Synopsis: Creates md help pages for the public functions (using the comment-based help) at Docs\Functions.
# Task CreateHelp ImportModule, {
#     New-Item -Path $PipelineSettings.FunctionsHelpDir -ItemType Directory -Force | Out-Null
#     Write-Information "  Delete old functions generated help"
#     Get-ChildItem -Path $PipelineSettings.FunctionsHelpDir -File | Remove-Item -Force

#     Get-ChildItem "$($PipelineSettings.DestinationDir)\Public\*.ps1" | ForEach-Object {
#         $mdHelp = @{
#             OutputFolder = $PipelineSettings.FunctionsHelpDir
#             AlphabeticParamsOrder = $true
#             Verbose = $true
#             Force = $true
#             NoMetadata = $true
#             Command = $_.BaseName
#         }
#         Write-Information "  Create help file for $($mdHelp.Command) command"
#         New-MarkdownHelp @mdHelp | ForEach-Object { Write-Verbose $_.FullName }
#     }
# }