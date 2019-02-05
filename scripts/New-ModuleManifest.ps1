$ModuleName = 'PSPublishHelper'
$ProjectRoot = (Resolve-Path (Join-Path $PSScriptRoot '..')).Path
$SrcFolder = Join-Path $ProjectRoot 'src'
$ModuleSrcPath = Join-Path $SrcFolder $ModuleName
$ModuleManifestFile = Join-Path $ModuleSrcPath "$ModuleName.psd1"
$Params = @{
    Path = $ModuleManifestFile
    Author = "Mark E. Kraus"
    CompanyName = "Mark E. Kraus"
    Copyright = "Copyright (c) Mark E. Kraus. All rights reserved."
    RootModule = "$ModuleName.psm1"
    ModuleVersion = "0.0.1"
    Description = 'A module to assist with "Build Once, Deploy Many" publishing paradigms for PowerShell'
    Tags = "Module","Builder","Publishing","Template","CI","CD","CI/CD"
    ProjectUri = "https://github.com/markekraus/$ModuleName"
    LicenseUri = "https://github.com/markekraus/$ModuleName/blob/master/LICENSE"
    FunctionsToExport = @()
    CmdletsToExport = @()
    VariablesToExport = @()
    AliasesToExport = @()
}
New-ModuleManifest @Params 
(Get-Content -Path $ModuleManifestFile) | ForEach-Object {
    if($_ -match '^#[^=]*$') {return}
    if($_ -match '^/s*$') {return}
    if($_ -match '^$') {return}
    if($_ -notmatch '^@\{|^\}$'){
        "    $_"
    } else {
        $_
    }
} | Set-Content -Encoding utf8 -Path $ModuleManifestFile