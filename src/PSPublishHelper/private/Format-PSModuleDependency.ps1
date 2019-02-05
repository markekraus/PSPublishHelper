function Format-PSModuleDependency {
    [OutputType([string])]
    [CmdletBinding()]
    param (
        [Parameter(Mandatory, ValueFromPipeline)]
        [ValidateNotNull()]
        [Microsoft.PowerShell.Commands.ModuleSpecification]
        $Dependency
    )
    process {
        $Version = [string]::Empty
        # Version format in NuSpec:
        # "[2.0]" --> (== 2.0) Required Version
        # "2.0" --> (>= 2.0) Minimum Version
        #
        # When only MaximumVersion is specified in the ModuleSpecification
        # (,1.0]  = x <= 1.0
        #
        # When both Minimum and Maximum versions are specified in the ModuleSpecification
        # [1.0,2.0] = 1.0 <= x <= 2.0
        if($Dependency.RequiredVersion) {
            $Version = "[{0}]" -f $Dependency.RequiredVersion
        } elseif($Dependency.Version -and $Dependency.MaximumVersion) {
            $Version = "[{0},{1}]" -f $Dependency.Version, $Dependency.MaximumVersion
        } elseif($Dependency.MaximumVersion) {
            $Version = "(,{0}]" -f $Dependency.MaximumVersion
        } elseif($Dependency.Version) {
            $Version = "{0}" -f $Dependency.Version
        }

        if ([System.string]::IsNullOrWhiteSpace($Version)) {
            "<dependency id='{0}'/>" -f $Dependency.Name
        } else {
            "<dependency id='{0}' version='{1}' />" -f $Dependency.Name, $Version
        }
    }
}
