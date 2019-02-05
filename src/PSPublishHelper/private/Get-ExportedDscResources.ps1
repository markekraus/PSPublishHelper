function Get-ExportedDscResources {
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory=$true)]
        [ValidateNotNullOrEmpty()]
        [PSModuleInfo]
        $Module
    )

    $Params = @{
        Name = 'Get-DscResource'
        Module = 'PSDesiredStateConfiguration'
        ErrorAction = 'Ignore'
    }
    if(-not $script:IsCoreCLR -and (Get-Command @Params)) {
        $OldPSModulePath = $env:PSModulePath

        try {
            $env:PSModulePath = Join-Path -Path $PSHOME -ChildPath "Modules"
            $ModuleBaseParent = Split-Path -Path $Module.ModuleBase -Parent
            $env:PSModulePath = "{0}{1}{2}" -f @(
                $env:PSModulePath,
                [System.IO.Path]::PathSeparator,
                $ModuleBaseParent
            )

            $Params = @{
                ErrorAction = 'SilentlyContinue'
                WarningAction = 'SilentlyContinue'
            }
            PSDesiredStateConfiguration\Get-DscResource @Params |
                Microsoft.PowerShell.Core\ForEach-Object {
                    if(
                        $_.Module -and
                        $_.Module.Name -eq $Module.Name
                    ){
                        $_.Name
                    }
                }
        } finally {
            $env:PSModulePath = $OldPSModulePath
        }
    } else {
        $dscResourcesDir = Join-Path $Module.ModuleBase "DscResources"
        if(Microsoft.PowerShell.Management\Test-Path $dscResourcesDir) {
            Microsoft.PowerShell.Management\Get-ChildItem -Path $dscResourcesDir -Directory -Name
        }
    }
}