function Get-NuspecFilePath {
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
        $FileName = '{0}.nuspec' -f $Module.Name
        Join-Path $Path $FileName
    }
}
