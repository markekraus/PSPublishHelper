function Resolve-PSModuleVersion {
    [OutputType([string])]
    [CmdletBinding()]
    param (
        [Parameter()]
        [PsModuleInfo]
        $Module,

        [Parameter()]
        [Hashtable]
        $PSData
    )
    end {
        $Version = [string]$Module.Version
        if($PSData.Prerelease) {
            $Prerelease = $PSData.Prerelease
            if($Prerelease.StartsWith('-')) {
                $version = '{0}{1}' -f $Version, $Prerelease
            } else {
                $version = '{0}-{1}' -f $Version, $Prerelease
            }
        }
        $Version
    }
}
