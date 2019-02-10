function Get-TemporaryPath {
    [OutputType([string])]
    [CmdletBinding()]
    param (
        [Parameter(Mandatory,ValueFromPipeline)]
        [ValidateNotNull()]
        [PSModuleInfo]
        $Module
    )
    process {
        $Base = Join-Path ([System.IO.Path]::GetTempPath()) (Get-Random)
        Join-Path $Base $Module.Name
    }
}
