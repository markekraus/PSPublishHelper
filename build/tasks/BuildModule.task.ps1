Task BuildModule {
    $Script:Phase = 'Build'
}, Initialize, CreatePaths, InstallDependencies, CopyModuleBaseFiles, CopyModuleSourceFiles, CopyModuleAssets, UpdateExportFunctionsAndAliases, VersionBump