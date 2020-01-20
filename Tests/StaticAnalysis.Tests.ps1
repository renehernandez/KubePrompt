Set-StrictMode -Version 2.0

$projectRoot = Resolve-Path -Path "$PSScriptRoot\.."

Describe 'Static Analysis Checker' {
    BeforeAll {
        function RunStaticAnalysis([string] $Path)
        {
            $scripts = Get-ChildItem -Path $Path -Include *.ps1, *.psm1, *.psd1 -Recurse |
                Where-Object { $_.FullName -match '.*(Private|Public|Classes).*' }

            $scriptAnalyzerSettingsPath = Join-Path -Path $Path -ChildPath 'PSScriptAnalyzerSettings.psd1'

            foreach ($script in $scripts) {
                $results =  Invoke-ScriptAnalyzer -Settings $scriptAnalyzerSettingsPath -Path $script.FullName -IncludeDefaultRules

                if ($results)
                {
                    foreach ($rule in $results)
                    {
                        It "$($script.Name) file should not fail $($rule.RuleName)" {
                            $message = "{0} Line {1}: {2}" -f $rule.Severity, $rule.Line, $rule.message
                            $message | Should -BeNullOrEmpty
                        }
                    }
                }
                else {
                    It "$($script.Name) file should not fail any rules" {
                        $results | Should -BeNullOrEmpty
                    }
                }
            }
        }
    }

    Context 'Module Source' {
        $path = Join-Path -Path $projectRoot -ChildPath 'Source'

        RunStaticAnalysis -Path $path
    }
}
