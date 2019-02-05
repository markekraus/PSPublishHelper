function Resolve-PSModuleInfo {
    [OutputType([Microsoft.PowerShell.Commands.ModuleSpecification])]
    [CmdletBinding()]
    param (
        [Parameter(ValueFromPipeline)]
        [PSObject]
        $InputObject
    )

    process {
        # '*' can be specified in the MaximumVersion of a ModuleSpecification to convey
        # that maximum possible value of that version part.
        # like 1.0.0.* --> 1.0.0.99999999
        if($InputObject.MaximumVersion){
            $InputObject.MaximumVersion = $InputObject.MaximumVersion -replace '\*','99999999'
        }

        [Microsoft.PowerShell.Commands.ModuleSpecification]$InputObject
    }
}
