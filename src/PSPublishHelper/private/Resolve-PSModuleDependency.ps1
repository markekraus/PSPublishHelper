function Resolve-PSModuleDependency {
    [OutputType([Microsoft.PowerShell.Commands.ModuleSpecification])]
    [CmdletBinding()]
    param (
        [Parameter(Mandatory, ValueFromPipeline)]
        [PSModuleInfo]
        $Module
    )
    process {
        # The manifest contains the actual ModuleSpec used for Version requirements
        $ModuleData = Import-PowerShellDataFile -Path $Module.Path 

        $ModuleData.RequiredModules | Resolve-PSModuleInfo

        $NestModuleInfo = $ModuleData.NestedModules | Resolve-PSModuleInfo

        # A module in NestedModules become a dependency
        # when it is not not packaged with the module
        $NestedDependencies = $Module.NestedModules | Where-Object {
            -not $_.ModuleBase.StartsWith($Module.ModuleBase, [System.StringComparison]::OrdinalIgnoreCase) -or
            -not $_.Path -or
            -not (Microsoft.PowerShell.Management\Test-Path -LiteralPath $_.Path)
        } | Foreach-Object -MemberName Name

        $NestModuleInfo | Where-Object {$_.Name -in $NestedDependencies}
    }
}
