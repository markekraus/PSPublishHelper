Task Initialize {
    $Script:SrcPath = Join-Path $ProjectRoot 'src'
    $ModuleSrc = Get-ChildItem -Path $SrcPath -Directory
    $Script:ModuleSrcPath = $ModuleSrc.FullName
    $Script:ModuleName = $ModuleSrc.Name
    $Script:ModuleSrcManifestFile = Join-Path $ModuleSrcPath "$ModuleName.psd1"
    $Script:ModuleSrcRootModuleFile = Join-Path $ModuleSrcPath "$ModuleName.psm1"
    $Script:ModuleSrcPublicPath = Join-Path $ModuleSrcPath 'public'
    $Script:ModuleSrcPrivatePath = Join-Path $ModuleSrcPath 'private'
    $Script:ModuleSrcClassesPath = Join-Path $ModuleSrcPath 'classes'
    $Script:ModuleSrcEnumsPath = Join-Path $ModuleSrcPath 'enums'
    $Script:ModuleSrcAssetsPath = Join-Path $ModuleSrcPath 'assets'
    $Script:TestPath = Join-Path $ProjectRoot 'test'
    $Script:TestIntegrationPath = Join-Path $TestPath 'integration'
    $Script:TestUnitPath = Join-Path $TestPath 'unit'
    $Script:LocalPSModulePath = Join-Path $ProjectRoot 'psmodules'
    $Script:ConfigPath = Join-Path $ProjectRoot 'config'
    $Script:DependenciesFile = Join-Path $ConfigPath 'dependencies.json'

    if($OutputPath) {
        'OutputPath derived from user input'
    }
    if(-not $OutputPath -and $env:Build_ArtifactStagingDirectory) {
        'OutputPath derived from Build_ArtifactStagingDirectory'
        $Script:OutputPath = $env:Build_ArtifactStagingDirectory
    }
    if(-not $OutputPath) {
        'OutputPath derived from ProjectRoot'
        $Script:OutputPath = Join-Path $ProjectRoot 'bin'
    }

    $Script:ModulesOutputPath = Join-Path $OutputPath 'modules'
    $Script:ModuleOutputPath = Join-Path $ModulesOutputPath $ModuleName
    $Script:ModuleOutputAssetsPath = Join-Path $ModuleOutputPath 'assets'
    $Script:ModuleOutputManifestFile = Join-Path $ModuleOutputPath "$ModuleName.psd1"
    $Script:ModuleOutputRootModuleFile = Join-Path $ModuleOutputPath "$ModuleName.psm1"

    $ModulePaths = $env:PSModulePath -split [System.IO.Path]::PathSeparator
    if($ModulePaths -NotContains $LocalPSModulePath) {
        $env:PSModulePath = '{0}{1}{2}' -f @(
            $env:PSModulePath
            [System.IO.Path]::PathSeparator
            $LocalPSModulePath
        )
    }

    $Script:ProjectDirectories = @(
        $OutputPath
        $ModulesOutputPath
        $ModuleOutputPath
        $LocalPSModulePath
    )

    ' '
    'ProjectRoot:                  {0}' -f $Script:ProjectRoot
    'ModuleName:                   {0}' -f $Script:ModuleName
    'SrcPath:                      {0}' -f $Script:SrcPath
    'ModuleSrcPath:                {0}' -f $Script:ModuleSrcPath
    'ModuleSrcManifestFile:        {0}' -f $Script:ModuleSrcManifestFile
    'ModuleSrcRootModuleFile:      {0}' -f $Script:ModuleSrcRootModuleFile
    'ModuleSrcPublicPath:          {0}' -f $Script:ModuleSrcPublicPath
    'ModuleSrcPrivatePath:         {0}' -f $Script:ModuleSrcPrivatePath
    'ModuleSrcClassesPath:         {0}' -f $Script:ModuleSrcClassesPath
    'ModuleSrcEnumsPath:           {0}' -f $Script:ModuleSrcEnumsPath
    'ModuleSrcAssetsPath:          {0}' -f $Script:ModuleSrcAssetsPath
    'TestPath:                     {0}' -f $Script:TestPath
    'TestIntegrationPath:          {0}' -f $Script:TestIntegrationPath
    'TestUnitPath:                 {0}' -f $Script:TestUnitPath
    'OutputPath:                   {0}' -f $Script:OutputPath
    'ModulesOutputPath:            {0}' -f $Script:ModulesOutputPath
    'ModuleOutputPath:             {0}' -f $Script:ModuleOutputPath
    'ModuleOutputAssetsPath:       {0}' -f $Script:ModuleOutputAssetsPath
    'ModuleOutputManifestFile:     {0}' -f $Script:ModuleOutputManifestFile
    'ModuleOutputRootModuleFile:   {0}' -f $Script:ModuleOutputRootModuleFile
    'LocalPSModulePath:            {0}' -f $Script:LocalPSModulePath
    'ConfigPath:                   {0}' -f $Script:ConfigPath
    'DependenciesFile:             {0}' -f $Script:DependenciesFile
    'env:PSModulePath:             {0}' -f $env:PSModulePath
    'ProjectDirectories:           {0}' -f ($Script:ProjectDirectories -join ', ')
    'Phase:                        {0}' -f $Script:Phase
    'PSGalleryApiKey present:      {0}' -f (-not [string]::IsNullOrWhiteSpace($Script:PSGalleryApiKey))
    'PSRepositoryName:             {0}' -f $Script:PSRepositoryName
    'PSRepositoryUrl:              {0}' -f $Script:PSRepositoryUrl
    'PSRepositoryUrl:              {0}' -f $Script:PSRepositoryUrl
    'PSRepositoryAuthMethod:       {0}' -f $Script:PSRepositoryAuthMethod
    'PSRepositoryUser:             {0}' -f $Script:PSRepositoryUser
    'PSRepositoryPassword present: {0}' -f (-not [string]::IsNullOrWhiteSpace($Script:PSRepositoryPassword))
    'PSRepositoryApiKey present:   {0}' -f (-not [string]::IsNullOrWhiteSpace($Script:PSRepositoryApiKey))
    'BuildVersion:                 {0}' -f $Script:BuildVersion
}