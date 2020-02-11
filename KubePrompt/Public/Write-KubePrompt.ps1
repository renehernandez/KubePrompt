function Write-KubePrompt {
    <#
    .SYNOPSIS
    Write-KubePrompt cmdlet will add the current context and namespace in Kubernetes
    configured in `kubectl` to your PowerShell prompt.

    .DESCRIPTION
    In your `$Profile` file, import KubePrompt module and add to your prompt function a call to `Write-KubePrompt`

    ```powershell
    Import-Module -Name KubePrompt

    function prompt {
        Write-KubePrompt
        ... Rest of your prompt
    }
    ```

    Write-KubePrompt cmldet supports two ways for customizations. Either by specifying a parameter
    in the `Write-KubePrompt` cmdlet invocation or through modification of the `KubePromptSettings`
    global variable.

    .PARAMETER ContextColor
    Sets the foreground color for the context string. Value can be either of [ConsoleColor] type or string

    .PARAMETER NamespaceColor
    Sets the foreground color for the namespace string. Value can be either of [ConsoleColor] type or string

    .PARAMETER Symbol
    Sets the string/unicode character to be used as kubernetes symbol

    .PARAMETER SymbolColor
    Sets the foreground color for the symbol

    .PARAMETER DisableSymbol
    If specified, removes the symbol from the generated prompt

    .EXAMPLE
    Write-KubePrompt -DisableSymbol

    Hides the k8s symbol from the prompt

    .EXAMPLE
    $global:KubePromptSettings.Symbol.Enabled = $false
    PS > Write-KubePrompt

    Hides the k8s symbol from the prompt by setting the global KubePromptSettings variable

    .EXAMPLE
    Write-KubePrompt -Symbol '*'

    Overrides the symbol value with a string

    .EXAMPLE
    $global:KubePromptSettings.Symbol.Value = '*'
    PS > Write-KubePrompt

    Overrides the symbol value through the global KubePromptSettings variable

    .EXAMPLE
    Write-KubePrompt -Symbol 0x1011 # infinity symbol

    Overrides the symbol value by passing a Unicode character

    .EXAMPLE
    Write-KubePrompt -ContextColor ([ConsoleColor]::Green)

    Overrides the context string foreground color using a `ConsoleColor` type

    .EXAMPLE
    $global:KubePromptSettings.ContextColor = 'Green'
    PS > Write-KubePrompt

    Overrides the context string foreground color using a string

    .EXAMPLE
    Write-KubePrompt -NamespaceColor ([ConsoleColor]::Yellow)

    Overrides the namespace string foreground color using a `ConsoleColor` type

    .EXAMPLE
    $global:KubePromptSettings.NamespaceColor = 'Yellow'
    PS > Write-KubePrompt

    Overrides the namespace string foreground color using a string
    #>

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

        $ctxColor = $settings.ContextColor
        $nsColor = $settings.NamespaceColor
        $symColor = $settings.SymbolColor
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
