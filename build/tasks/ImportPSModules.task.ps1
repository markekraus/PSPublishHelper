Task ImportPSModules Initialize, ImportDependencyConfig, {
    'Importing PowerShell Modules for phase {0}' -f $Phase
    if(-not $DependencyConfig.PowerShell) {
        'No PowerShell dependencies found. Skipping.'
        return
    }

    foreach($Dependency in $DependencyConfig.PowerShell){
        if($Dependency.Phases -notcontains $Phase) {
            "{0} is not required in this phase, skipping." -f $Dependency.Name
            continue
        }
        'Importing module {0} version {1}' -f $Dependency.Name, $Dependency.Version
        Import-Module -Force -Name $Dependency.Name -RequiredVersion $Dependency.Version -scope Global
    }
}