function Get-NuspecContents {
    [OutputType([String])]
    [CmdletBinding()]
    param (
        [PSModuleInfo]
        $Module,

        [Hashtable]
        $PSData
    )
    end {

        $VersionText = Resolve-PSModuleVersion -Module $Module -PSData $PSData

        $TagsText = Resolve-PSModuleTags -Module $Module -Tags $PSData.Tags

        $RequireLicenseAcceptanceText = ([bool]$PSData.RequireLicenseAcceptance).ToString().ToLower() 

        $Description = $Module.Description
        if ([string]::IsNullOrWhiteSpace($Description)) {
            $Description = $Module.Name
        }

        $ArgumentList = [System.Collections.Generic.List[string]]::new()
        @(
            $Module.Name,
            $VersionText,
            $Module.Author,
            $Module.CompanyName,
            $Description,
            $Module.ReleaseNotes,
            $RequireLicenseAcceptanceText,
            $Module.Copyright,
            $TagsText
        ) | Get-EscapedString | ForEach-Object {
            $ArgumentList.Add($_)
        }

        $LicenseUriText = if ($PSData.LicenseUri) {
            '<licenseUrl>{0}</licenseUrl>' -f ($PSData.LicenseUri | Get-EscapedString)
        }
        $ArgumentList.Add($LicenseUriText)

        $ProjectUriText = if ($PSData.ProjectUri) {
            '<projectUrl>{0}</projectUrl>' -f ($PSData.ProjectUri | Get-EscapedString)
        }
        $ArgumentList.Add($ProjectUriText)

        $IconUriText = if ($PSData.IconUri) {
            '<iconUrl>{0}</iconUrl>' -f ($PSData.IconUri | Get-EscapedString)
        }
        $ArgumentList.Add($IconUriText)

        $DependencyText = @(
            $Module | Resolve-PSModuleDependency | Format-PSModuleDependency
        ) -Join ([Environment]::NewLine)
        $ArgumentList.Add($DependencyText)

        $Script:Nuspec -f $ArgumentList.ToArray()
    }
}
