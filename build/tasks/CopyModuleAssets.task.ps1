Task CopyModuleAssets Initialize, {
    if(-not (Test-Path -PathType Container -Path $ModuleSrcAssetsPath)) {
        'Assets directory {0} does not exist. skipping.' -f $ModuleSrcAssetsPath
        return
    }
    'Copying assets from {0} to ' -f $ModuleSrcAssetsPath, $ModuleOutputAssetsPath
    $Null = New-Item -Path $ModuleOutputAssetsPath -Force -ItemType Directory
    Get-ChildItem $ModuleSrcAssetsPath -Force | ForEach-Object {
        if($_.PSIsContainer) {
            'Copying Directory {0}' -f $_.FullName
            Copy-Item -Container -Recurse -Path $_.FullName -Destination $ModuleOutputAssetsPath -Force
        } else {
            'Copying file {0}' -f $_.FullName
            Copy-Item -Path $_.FullName -Destination $ModuleOutputAssetsPath -Force
        }
    }
}