function Get-AvailableRoleCapabilityName {
    [CmdletBinding()]
    Param (
        [Parameter(Mandatory=$true)]
        [ValidateNotNullOrEmpty()]
        [PSModuleInfo]
        $Module
    )

    $RoleCapabilitiesDir = Join-Path $Module.ModuleBase 'RoleCapabilities'
    if(Microsoft.PowerShell.Management\Test-Path -Path $RoleCapabilitiesDir -PathType Container)
    {
        $Params = @{
            Path = $RoleCapabilitiesDir
            Filter = '*.psrc'
        }
        Microsoft.PowerShell.Management\Get-ChildItem @Params |
            ForEach-Object -MemberName BaseName
    }
}
