# KubePrompt

KubePrompt is a powershell module that lets you add the current context and namespace in Kubernetes configured in `kubectl` to your PowerShell prompt

## Installation

### Prerequisites

Before installing KubePrompt make sure the following prerequisites are present in the machine and available via the PATH environment variable.

* [kubectl](https://github.com/kubernetes/kubectl) (kubernetes cli) is installed

```powershell
> Install-Module -Name KubePrompt
```

## Usage

### Setting your prompt

In your `$Profile` file, import `KubePrompt` module and add to your prompt function a call to `Write-KubePrompt`

```powershell
Import-Module -Name KubePrompt

function prompt { 
    Write-KubePrompt
    ... Rest of your prompt
}
```

For customizations check the `Write-KubePrompt` docs page

## Contributions

## Changelog

## License


