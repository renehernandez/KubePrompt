$global:KubePromptSettings = @{
    SymbolColor = ([ConsoleColor]::DarkBlue)
    ContextColor = ([ConsoleColor]::DarkRed)
    NamespaceColor = ([ConsoleColor]::DarkCyan)
    Prefix = '['
    Suffix = ']'
    Symbol = @{
        Enabled = $true
        Value = 0x2388
    }
    Divider = ':'
    Separator = '|'
}

Install-PromptOverrideIfDefault
