Task UpdateExportFunctionsAndAliases Initialize, InstallDependencies, {
    "Parsing {0} for Functions and Aliases" -f $ModuleSrcPublicPath
    $FunctionFiles = Get-ChildItem $ModuleSrcPublicPath -Filter '*.ps1' -Recurse |
        Where-Object { $_.Name -notmatch '\.tests{0,1}\.ps1' }
    $ExportFunctions = [System.Collections.Generic.HashSet[String]]::New([System.StringComparer]::InvariantCultureIgnoreCase)
    $ExportAliases = [System.Collections.Generic.HashSet[String]]::New([System.StringComparer]::InvariantCultureIgnoreCase)
    foreach ($FunctionFile in $FunctionFiles) {
        "- Processing $($FunctionFile.FullName)"
        $AST = [System.Management.Automation.Language.Parser]::ParseFile($FunctionFile.FullName, [ref]$null, [ref]$null)
        $Functions = $AST.FindAll( {
                $args[0] -is [System.Management.Automation.Language.FunctionDefinitionAst]
            }, $true)
        foreach ($FunctionName in $Functions.Name) {
            '  Found Function {0}' -f $FunctionName
            if(-not $ExportFunctions.Add($FunctionName)) {
                throw "'$FunctionName' is a duplicate function."
            }
        }
        $Aliases = $AST.FindAll( {
                $args[0] -is [System.Management.Automation.Language.AttributeAst] -and
                $args[0].parent -is [System.Management.Automation.Language.ParamBlockAst] -and
                $args[0].TypeName.FullName -eq 'alias'
            }, $true)
        Foreach ($Alias in $Aliases.PositionalArguments.value) {
            '  Found Alias {0}' -f $Alias
            if(-not $ExportAliases.Add($Alias)) {
                throw "'$Alias' is a duplicate alias."
            }
        }
    }

    'Updating FunctionsToExport in {0}' -f $ModuleOutputManifestFile
    Update-Metadata -Path $ModuleOutputManifestFile -PropertyName 'FunctionsToExport' -Value $ExportFunctions
    'Updating AliasesToExport in {0}' -f $ModuleOutputManifestFile
    Update-Metadata -Path $ModuleOutputManifestFile -PropertyName 'AliasesToExport' -Value $ExportAliases
}