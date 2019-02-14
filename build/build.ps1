[CmdletBinding()]
Param(
    [Parameter()]
    [string]
    $ProjectRoot = (Resolve-Path (Join-path $BuildRoot '..')).Path,

    [Parameter()]
    [string]
    $OutputPath,

    [Parameter()]
    [string]
    $Phase,

    [Parameter()]
    [string]
    $PSGalleryApiKey,

    [Parameter()]
    [string]
    $PSRepositoryName = $env:PSRepositoryName,

    [Parameter()]
    [string]
    $PSRepositoryUrl = $env:PSRepositoryUrl,

    [Parameter()]
    [ValidateSet('','none','basic','apikey')]
    [string]
    $PSRepositoryAuthMethod = $env:PSRepositoryAuthMethod,

    [Parameter()]
    [string]
    $PSRepositoryUser = $env:PSRepositoryUser,

    [Parameter()]
    [string]
    $PSRepositoryPassword = $env:PSRepositoryPassword,

    [Parameter()]
    [string]
    $PSRepositoryApiKey = $env:PSRepositoryApiKey,

    [Parameter()]
    [string]
    $BuildVersion = $env:GitVersion_NuGetVersionV2
)

Set-BuildHeader {
	param($Path)
    Write-Build Green ('=' * 80)
    Write-Build Green ('                Task {0}' -f $Path)
    Write-Build Green ('At {0}:{1}' -f $Task.InvocationInfo.ScriptName, $Task.InvocationInfo.ScriptLineNumber)
    if(($Synopsis = Get-BuildSynopsis $Task)) {
        Write-Build Green ('                {0}' -f $Synopsis)
    }
    Write-Build Green ('-' * 80)
	# task location in a script
    Write-Build Green ' '
}

# Define footers similar to default but change the color to DarkGray.
Set-BuildFooter {
	param($Path)
    Write-Build Green ' '
    Write-Build Green ('=' * 80)
    Write-Build DarkGray ('Done {0}, {1}' -f $Path, $Task.Elapsed)
    Write-Build Green ' '
    Write-Build Green ' '
}


$TasksFolder = Join-Path $PSScriptRoot 'tasks'
Get-ChildItem -Path $TasksFolder -Filter "*.task.ps1" | ForEach-Object {
    . $_.FullName
}

Task . Build