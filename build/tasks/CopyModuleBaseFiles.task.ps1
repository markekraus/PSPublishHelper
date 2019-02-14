Task CopyModuleBaseFiles Initialize, CreatePaths, {
    'Copying base module files from {0} to {1}' -f $ModuleSrcPath, $ModuleOutputPath
    $Null = Push-Location $ModuleSrcPath
    Copy-Item *.psm1, *.psd1, *.ps1xml -Destination $ModuleOutputPath -Force -Verbose
    $Null = Pop-Location
}