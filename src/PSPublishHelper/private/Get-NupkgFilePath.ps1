function Get-NupkgFilePath {
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
        $PSData = Resolve-PSData -Module $Module
        $Version = Resolve-PSModuleVersion -Module $Module -PSData $PSData
        $FileName = '{0}.{1}.nupkg' -f $Module.Name, $Version
        Join-Path $Path $FileName
    }
}
