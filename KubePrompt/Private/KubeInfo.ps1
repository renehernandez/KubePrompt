Set-StrictMode -Version 2

function Test-KubeBinaries {
    try {
        [bool](Get-Command -Name 'kubectx') -and [bool](Get-Command -Name 'kubens')
    }
    catch {
        $PSCmdlet.ThrowTerminatingError($_)
    }
}

function Get-KubeContext {
    try {
        kubectx --current
    }
    catch {
        $PSCmdlet.ThrowTerminatingError($_)
    }
}

function Get-KubeNamespace {
    try {
        kubens --current
    }
    catch {
        $PSCmdlet.ThrowTerminatingError($_)
    }
}
