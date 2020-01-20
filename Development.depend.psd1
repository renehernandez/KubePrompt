# todo: add explanation
@{
    PSDependOptions = @{
        Target = '$DependencyFolder\Dependencies'
        AddToPath = $true
    }

    ModuleBuilder = "1.5.2"
    Pester        = "4.9.0"
    BuildHelpers = "2.0.11"
    PSScriptAnalyzer = '1.18.3'
    InvokeBuild = '5.5.6'
    PlatyPS = '0.14.0'
}
