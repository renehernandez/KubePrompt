Set-StrictMode -Version 2

function Test-KubeBinary {
    try {
        [bool](Get-Command -Name 'kubectl')
    }
    catch {
        $PSCmdlet.ThrowTerminatingError($_)
    }
}

function Get-KubeContext {
    try {
        kubectl config current-context
    }
    catch {
        $PSCmdlet.ThrowTerminatingError($_)
    }
}

function Get-KubeNamespace {
    try {
        kubectl config view --minify --output 'jsonpath={..namespace}'
    }
    catch {
        $PSCmdlet.ThrowTerminatingError($_)
    }
}
