function Get-PSModuleManifestData {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory,ValueFromPipeline)]
        [ValidateNotNull()]
        [PSModuleInfo]
        $Module
    )
    process {
        if ($Module.Path -match '\.psd1$') {
            $Manifest = $Module.Path
        } else {
            $ManifestName = '{0}.psd1' -f $Module.Name
            $Manifest = Join-Path $Module.ModuleBase $ManifestName
        }
        Import-PowerShellDataFile -Path $Manifest
    }
}
