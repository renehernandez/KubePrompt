$global:KubePromptSettings = @{
    DefaultColors = @{
        SymbolColor = [ConsoleColor]::DarkBlue
        ContextColor = [ConsoleColor]::DarkRed
        NamespaceColor = [ConsoleColor]::DarkCyan
    }
    Prefix = '['
    Suffix = ']'
    Symbol = @{
        Enabled = $true
        Value = 0x2388
    }
    Divider = ':'
    Separator = '|'
}


function Write-KubePrompt {
    [CmdletBinding(DefaultParameterSetName = 'Default')]
    param(
        [Parameter(ParameterSetName = 'Default')]
        [Parameter(ParameterSetName = 'EnableSymbol')]
        [ValidateNotNullOrEmpty()]
        $ContextColor,

        [Parameter(ParameterSetName = 'Default')]
        [Parameter(ParameterSetName = 'EnableSymbol')]
        [ValidateNotNullOrEmpty()]
        $NamespaceColor,

        [Parameter(ParameterSetName = 'EnableSymbol')]
        [ValidateNotNullOrEmpty()]
        $Symbol,

        [Parameter(ParameterSetName = 'EnableSymbol')]
        [ValidateNotNullOrEmpty()]
        $SymbolColor,

        [Parameter(ParameterSetName = 'DisableSymbol')]
        [switch]
        $DisableSymbol
    )

    try {
        $settings = $KubePromptSettings

        $ctxColor = $settings.DefaultColors.ContextColor
        $nsColor = $settings.DefaultColors.NamespaceColor
        $symColor = $settings.DefaultColors.SymbolColor
        $sym = $settings.Symbol.Value
        $noSymbol = -not $settings.Symbol.Enabled

        if ($ContextColor) {
            $ctxColor = $ContextColor
        }

        if ($NamespaceColor) {
            $nsColor = $NamespaceColor
        }

        if ($SymbolColor) {
            $symColor = $SymbolColor
        }

        if ($Symbol) {
            $sym = $Symbol
        }

        if ($DisableSymbol) {
            $noSymbol = $DisableSymbol
        }

        Write-ToHost -Text $settings.Prefix

        if (-not $noSymbol) {
            Write-ToHost -Text ("$([char]$sym) ") -ForegroundColor $symColor
            Write-ToHost -Text $settings.Separator
        }

        Write-ToHost -Text (Get-KubeContext) -ForegroundColor $ctxColor

        Write-ToHost -Text $settings.Divider

        Write-ToHost -Text (Get-KubeNamespace) -ForegroundColor $nsColor

        Write-ToHost -Text $settings.Suffix
    }
    catch {
        $PSCmdlet.ThrowTerminatingError($_)
    }
}
