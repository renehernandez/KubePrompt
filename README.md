# KubePrompt

KubePrompt is a powershell module that lets you add the current context and namespace in Kubernetes configured in `kubectl` to your PowerShell prompt

## Installation

### Prerequisites

Before installing KubePrompt make sure the following prerequisites are present in the machine and available via the PATH environment variable.

* [kubectl](https://github.com/kubernetes/kubectl) (kubernetes cli) is installed
* [kubectx](https://github.com/ahmetb/kubectx) (Linuxs / Mac)
* [kubens](https://github.com/ahmetb/kubectx) (Linux / Mac)


```powershell
> Install-Module -Name KubePrompt
```

## Usage

In your `$Profile` file, import `KubePrompt` module and add to your prompt function a call to `Write-KubePrompt`

```powershell
Import-Module -Name KubePrompt

function prompt { 
    Write-KubePrompt
    ... Rest of your prompt
}
```

### Customizations

There are two ways to provide customizations. Either by specifying parameter to the `Write-KubePrompt` cmdlet invocation or through modification of the `KubePromptSettings` global variable.

#### Hide k8s symbol

* Using the cmdlet parameter:

```powershell
Import-Module -Name KubePrompt

function prompt {
    Write-KubePrompt -DisableSymbol
}
```

* Using `KubePromptSettings` variable

```powershell
Import-Module -Name KubePrompt

function prompt {
    $KubePromptSettings.Symbol.Enabled = $false
    Write-KubePrompt
}
```

#### Change symbol

#### Change colors

## Contributions

## Changelog

## License
