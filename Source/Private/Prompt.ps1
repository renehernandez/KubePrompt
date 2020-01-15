
function Write-ToHost {
    param(
        [Parameter(Mandatory)]
        [ValidateNotNullOrEmpty()]
        $Text,
        [Parameter()]
        [ValidateNotNullOrEmpty()]
        $ForegroundColor
    )

    try {
        $params = @{
            Object = $Text
            NoNewLine = $true
        }

        if ($PSBoundParameters.ContainsKey('ForegroundColor')) {
            $params.ForegroundColor = $ForegroundColor
        }

        Write-Host @params
    }
    catch {
        $PSCmdlet.ThrowTerminatingError($_)
    }
}
