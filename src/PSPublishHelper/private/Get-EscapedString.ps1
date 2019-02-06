function Get-EscapedString
{
    [CmdletBinding()]
    [OutputType([String])]
    Param (
        [Parameter(ValueFromPipeline)]
        [string]
        $Value
    )

    process {
        [System.Security.SecurityElement]::Escape($Value)
    }
}
