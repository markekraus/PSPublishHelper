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
                    $Params = @{
                        Force = $true
                        Confirm = $false
                        WhatIf = $false
                        Recurse = $true
                        Container = $true
                        Destination = $Path
                    }
                    $_ | Microsoft.PowerShell.Management\Copy-Item @Params
                } else {
                    $Params = @{
                        Force = $true
                        Confirm = $false
                        WhatIf = $false
                        Destination = $Path
                    }
                    $_ | Microsoft.PowerShell.Management\Copy-Item @Params
                }
            }
    }
}
