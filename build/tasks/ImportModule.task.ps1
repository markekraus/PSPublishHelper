Task ImportModule Initialize, {
    'Importing module {0}' -f $ModuleOutputManifestFile
    Import-Module -Force $ModuleOutputManifestFile
}
