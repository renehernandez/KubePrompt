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

### Customizing your Kube prompt

* Hides the k8s symbol from the prompt

```powershell
Write-KubePrompt -DisableSymbol
```

* Hides the k8s symbol from the prompt by setting the global KubePromptSettings variable

```powershell
$global:KubePromptSettings.Symbol.Enabled = $false
PS > Write-KubePrompt
```

* Overrides the symbol value with a string

```powershell
Write-KubePrompt -Symbol '*'
```

* Overrides the symbol value through the global KubePromptSettings variable

```powershell
$global:KubePromptSettings.Symbol.Value = '*'
PS > Write-KubePrompt
```

* Overrides the symbol value by passing a Unicode character

```powershell
Write-KubePrompt -Symbol 0x1011 # infinity symbol
```

* Overrides the context string foreground color using a `ConsoleColor` type

```powershell
Write-KubePrompt -ContextColor ([ConsoleColor]::Green)
```

* Overrides the context string foreground color using a string


```powershell
$global:KubePromptSettings.ContextColor = 'Green'
PS > Write-KubePrompt
```

* Overrides the namespace string foreground color using a `ConsoleColor` type

```powershell
Write-KubePrompt -NamespaceColor ([ConsoleColor]::Yellow)
```

* Overrides the namespace string foreground color using a string

```powershell
$global:KubePromptSettings.NamespaceColor = 'Yellow'
PS > Write-KubePrompt
```

## Contributions

We encourage you to contribute to KubePrompt! Please check out the [Contributing](CONTRIBUTING.md) guide for guidelines about how to proceed.

## Changelog

For changes across releases, see [CHANGELOG](CHANGELOG.md)

## License

KubePrompt is released under the [MIT License](License)




