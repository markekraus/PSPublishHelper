function Resolve-NugetCommand {
    [CmdletBinding()]
    param (
        [Parameter()]
        [System.Management.Automation.PSCmdlet]
        $Cmdlet
    )
    end {
        $ErrorCmdlet = $Cmdlet
        if (-not $Cmdlet) {
            $ErrorCmdlet = $PSCmdlet
        } 
        $Params = @{
            Name = 'nuget'
            CommandType = 'Application'
            ErrorAction = 'SilentlyContinue'
        }
        $Nuget = Get-Command @Params | Select-Object -First 1
        if(-not $Nuget) {
            $ErrorRecord = [System.Management.Automation.ErrorRecord]::new(
                [System.Management.Automation.ItemNotFoundException]::new(
                    "Unable to find nuget binary. Nuget is required"
                ),
                "NugetNotFound",
                [System.Management.Automation.ErrorCategory]::NotInstalled,
                $null
            )
            $ErrorCmdlet.ThrowTerminatingError($ErrorRecord)
        }
        $Nuget
    }
}
