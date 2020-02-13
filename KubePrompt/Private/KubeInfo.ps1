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
        $namespace = kubectl config view --minify --output 'jsonpath={..namespace}'

        if (-not $namespace) {
            $namespace = "default"
        }

        $namespace
    }
    catch {
        $PSCmdlet.ThrowTerminatingError($_)
    }
}
