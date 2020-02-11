# Original idea copied from https://github.com/dahlbyk/posh-git

function Get-DefaultPrompt {
    # Get the default prompt definition.
    $initialSessionState = [Runspace]::DefaultRunspace.InitialSessionState

    if (!$initialSessionState.Commands -or !$initialSessionState.Commands['prompt']) {
        "`$(if (test-path variable:/PSDebugContext) { '[DBG]: ' } else { '' }) + 'PS ' + `$(Get-Location) + `$(if (`$nestedpromptlevel -ge 1) { '>>' }) + '> '"
    }
    else {
        $initialSessionState.Commands['prompt'].Definition
    }
}

function Install-PromptOverrideIfDefault {
    $defaultPromptDef = Get-DefaultPrompt
    $currentPromptDef = if ($funcInfo = Get-Command prompt -ErrorAction SilentlyContinue) { $funcInfo.Definition }

    if (-not $currentPromptDef) {
        # HACK: If prompt is missing, create a global one we can overwrite with Set-Item
        function global:prompt { ' ' }
    }

    # If there is no prompt function or the prompt function is the default, replace the current prompt function definition
    if (-not $currentPromptDef -or ($currentPromptDef -eq $defaultPromptDef)) {
        # Set the posh-git prompt as the default prompt
        Set-Item Function:\prompt -Value {
            Write-KubePrompt
            return "> "
        }
    }
}
