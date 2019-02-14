function Resolve-PSData {
    [OutputType([Hashtable])]
    [CmdletBinding()]
    param (
        [PSModuleInfo]
        $Module,

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
            RequireLicenseAcceptance = $null
        }
        foreach ($item in $PSData.GetEnumerator()) {
            $key = $item.key
            $Result[$key] = $item.value
            if (-not $item.value -and $key -ne 'Prerelease') {
                $Result[$key] = $Module.PrivateData.PSdata.$key
            } elseif (-not $item.value -and $key -eq 'Prerelease') {
                $Result[$key] = $Module.PrivateData.$key
            }
        }
        $Result
    }
}
