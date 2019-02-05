function Resolve-PSModule {
    [OutputType([System.Management.Automation.PSModuleInfo])]
    [CmdletBinding()]
    param (
        [Parameter()]
        [System.Management.Automation.PSCmdlet]
        $Cmdlet,

        [Parameter()]
        [string]
        $Name,

        [Parameter()]
        [string]
        $RequiredVersion
    )
    end {
        if($Cmdlet) {
            $ErrorCmdlet = $Cmdlet
        } else {
            $ErrorCmdlet = $PSCmdlet
        }

        $Version, $Prerelease = $RequiredVersion -split '-', 2
        
        $Filter = {
            $_.Version.ToString() -eq $Version -and
            (
                $_.PrivateData.PSData.Prerelease -eq $Prerelease -or
                $_.PrivateData.PSData.Prerelease -eq "-$Prerelease"
            )
        }

        $Result = Get-Module -ListAvailable -Name $Name |
            Where-Object -FilterScript $Filter |
            Select-Object -First 1
        
        if (-not $Result) {
            $ErrorRecord = [System.Management.Automation.ErrorRecord]::new(
                [System.Management.Automation.ItemNotFoundException]::new(
                    "Unable to find Module $Name Version $RequiredVersion"
                ),
                "ModuleNotFound",
                [System.Management.Automation.ErrorCategory]::InvalidArgument,
                $null
            )
            $ErrorCmdlet.ThrowTerminatingError($ErrorRecord)
        }
        $Result
    }
}
