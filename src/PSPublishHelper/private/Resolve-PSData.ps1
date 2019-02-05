function Resolve-PSData {
    [OutputType([Hashtable])]
    [CmdletBinding()]
    param (
        [PSModuleInfo]
        $PSModuleInfo,

        [string]
        $ReleaseNotes,

        [string[]]
        $Tags,

        [Uri]
        $LicenseUri,

        [Uri]
        $IconUri,

        [Uri]
        $ProjectUri
    )
    end {
        $Result = @{}
        $PSData = @{
            ReleaseNotes = $ReleaseNotes
            Tags = $Tags
            LicenseUri = $LicenseUri
            IconUri = $IconUri
            ProjectUri = $ProjectUri
            Prerelease = $null
        }
        foreach ($item in $PSData.GetEnumerator()) {
            $key = $item.key
            $Result[$key] = $item.value
            if (-not $item.value) {
                $Result[$key] = $PSModuleInfo.PrivateData.PSdata.$key
            }
        }
        $Result
    }
}
