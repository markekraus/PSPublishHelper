Task CopyModuleSourceFiles Initialize, CreatePaths, {
    'Copying module source files into {0}' -f $ModuleOutputRootModuleFile
    $Null = Push-Location $ProjectRoot

    $AddContentCmd = $ExecutionContext.InvokeCommand.GetCommand('Microsoft.PowerShell.Management\Add-Content', [System.Management.Automation.CommandTypes]::Cmdlet)
    $AddContent = {& $AddContentCmd -Path $ModuleOutputRootModuleFile -Encoding Utf8 }.GetSteppablePipeline($myInvocation.CommandOrigin)
    $AddContent.Begin($true)

    $Folders = @(
        $ModuleSrcEnumsPath
        $ModuleSrcClassesPath
        $ModuleSrcPrivatePath
        $ModuleSrcPublicPath
    )
    foreach ($Folder in $Folders) {
        if(-not (Test-Path -PathType Container -Path $Folder)){
            '{0} does not existing. skipping' -f $Folder
            continue
        }
        'Copying source from {0} into {1}' -f $Folder, $ModuleOutputRootModuleFile
        $Params = @{
            Filter = '*.ps1'
            Path = $Folder
            Recurse = $true
            File = $true
            Force = $true
        }
        Get-ChildItem @Params | ForEach-Object {
            'Processing {0}' -f $_.FullName
            $FileName = Resolve-Path -Path $_.FullName -Relative
            $Prefix = "#Region '{0}' 0" -f $FileName
            $AddContent.Process($Prefix)
            Get-Content $_.FullName -OutVariable Content | ForEach-Object {
                $AddContent.Process($_)
            }
            $Suffix = "#EndRegion '{0}' {1}" -f $FileName, $Content.Count
            $AddContent.Process($Suffix)
        }
    }
    $AddContent.End()
    $Null = Pop-Location
}