$global:KubePromptSettings = @{
    DefaultColors = @{
        SymbolColor = 'Blue'
        ContextColor = 'Red'
        NamespaceColor = 'Cyan'
        BackgroundColor = $null
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

        if ($PSBoundParameters.ContainsKey('ContextColor')) {
            $ctxColor = $ContextColor
        }

        if ($PSBoundParameters.ContainsKey('NamespaceColor')) {
            $nsColor = $NamespaceColor
        }

        if ($PSBoundParameters.ContainsKey('SymbolColor')) {
            $symColor = $SymbolColor
        }

        if ($PSBoundParameters.ContainsKey('Symbol')) {
            $sym = $Symbol
        }

        Write-ToHost -Text $settings.Prefix

        if (-not $DisableSymbol) {
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
