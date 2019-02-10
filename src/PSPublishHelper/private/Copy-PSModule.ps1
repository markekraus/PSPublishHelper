function Copy-PSModule {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        [ValidateNotNull()]
        [PSModuleInfo]
        $Module,

        [Parameter(Mandatory)]
        [ValidateNotNullOrEmpty()]
        [string]
        $Path
    )
    end {
        $Params = @{
            Path = $Path
            Recurse = $true
            Force = $true
            ErrorAction = 'SilentlyContinue'
        }
        Microsoft.PowerShell.Management\Remove-Item @Params
        $Params = @{
            Path = $Path
            ItemType = 'Directory'
            Force = $true
        }
        $null = Microsoft.PowerShell.Management\New-Item @Params
        Microsoft.PowerShell.Management\Get-ChildItem $Module.ModuleBase -recurse |
            ForEach-Object {
                if ($_.PSIsContainer) {
                    $_ |Microsoft.PowerShell.Management\Copy-Item -Force -Confirm:$false -WhatIf:$false -Recurse -Container -Destination $Path
                } else {
                    $_ |Microsoft.PowerShell.Management\Copy-Item -Force -Confirm:$false -WhatIf:$false -Destination $Path
                }
            }
    }
}