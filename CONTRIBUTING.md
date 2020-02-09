<!--
    Adapted from the Pester's Contributing Guide:
    https://github.com/pester/Pester/wiki/Contributing-to-Pester
-->

# Contributing to KubePrompt

## Giving back to KubePrompt

To propose a new feature to KubePrompt or report a bug, we encourage you to first share your findings with us by creating a new issue in Github. The feature or bug will be discussed, and if it's something we would like (or even love!) to see in our codebase we will ask you to create a pull request (PR) for it. We have a (more or less) standardized process for accepting PRs, but don't let that scare you away. We understand that you spent your time to contribute, so we will take our time to help you successfully add your code to KubePrompt.

## Getting in touch

### Reporting a bug

To report a bug, please create a new bug in Github, and fill out the details. Your bug report should include the description of what is wrong, the version of KubePrompt, PowerShell and the operating system. To make your bug report perfect you should also include a simple way to reproduce the bug.

Here is a piece of code that collects the required system information for you and puts it in your clipboard:

```powershell
$bugReport = &{
    $p = get-module KubePrompt
    "KubePrompt version : " + $p.Version + " " + $p.Path
    "PowerShell version : " + $PSVersionTable.PSVersion
    "OS version : " + [System.Environment]::OSVersion.VersionString
}
$bugReport
$bugReport | clip
```

Example output:

```powershell
KubePrompt version : 0.1. /Users/renehernandezremedios/.local/share/powershell/Modules/KubePrompt/0.1.0/KubePrompt.psm1
PowerShell version : 7.0.0-rc.1
OS version : Unix 18.7.0.0
```

### Proposing a New Feature

To propose a new feature, please create a new story in issue in the repo and share as much information as you see fit. Especially what the proposed feature is, why it is useful, and what dependencies (if any) it has. It would also be great if you added one or two examples of real world usage, if you have any.

When we discuss new features we look at how useful it is to the majority of users, how difficult it would be to implement, if breaking changes to the API must be introduced to have it, and if it's too specialized or too general to put in the codebase. But again, don't let that scare you away.

## Implementing a PR

So now we talked about your proposed change in the issue and it's time for you to implement the change and make it into a pull request (PR).

### Step 1 - Create a Feature Branch

Switch to your master branch of your local clone (pull to make sure you have the latest changes) and create a new so-called feature branch from it. This branch will hold all changes for the PR you are implementing.

### Step 2 - Implement Your Changes

Now you can start implementing your changes. Make sure that your changes are relevant to the feature that you are implementing/the bug you are fixing. Avoid changing formatting and style of code that is not relevant to your changes, unless your pull request is focus on formatting / style changes :).

### Step 3 - Test Your Changes

Once you are done with you changes you need to test them in your branch. It's highly encouraged to add tests for every change/addition, by default code without tests won't accepted (unless exceptional circumstances arise) and your contributions would be delayed. To verify that changes are not introducing any regression, you should run your `build.ps1` script using the **Default** task option locally. That would run over all the CI/CD pipeline steps, including linting, testing and packaging your code.

### Step 4 - Push Your Changes to the Feature Branch

After the push, Github will run the CI/CD pipeline and will report any errors from the automated tests, if any.

### Step 5 - Open the Pull Request and ask for feedback from maintainers

Once the pull request gets reviewed and all the requested changes are addressed, one the maintainers will approve/merge it to the master branch.
