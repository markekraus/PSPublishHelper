Task InstallDependenciesPS Initialize, CreatePaths, RegisterPSRepository, ImportDependencyConfig, {
    'Installing PowerShell Dependencies for phase {0}' -f $Phase
    if(-not $DependencyConfig.PowerShell) {
        'No PowerShell dependencies found. Skipping.'
        return
    }

    $AvailableModules = Get-Module -ListAvailable
    $Params = @{
        Repository = 'PSGallery'
        Path = $LocalPSModulePath
        Force = $true
        AllowPrerelease = $true
        AcceptLicense = $true
        Verbose = $true
    }

    If($PSRepositoryName) {
        $Params['Repository'] = $PSRepositoryName, 'PSGallery'
    }

    if($PSRepositoryUser -and $PSRepositoryPassword) {
        'PSRepositoryUser and PSRepositoryPassword present and will be used'
        $SecurePass = $PSRepositoryPassword | ConvertTo-SecureString -AsPlainText -Force
        $Params['Credential'] = [PSCredential]::new($PSRepositoryUser, $SecurePass)
    }

    foreach($Dependency in $DependencyConfig.PowerShell){
        if($Dependency.Phases -notcontains $Phase) {
            "{0} is not required in this phase, skipping." -f $Dependency.Name
            continue
        }
        'Checking for existence of module {0} version {1}' -f $Dependency.Name, $Dependency.Version
        $Installed = $AvailableModules.Where({$_.Name -eq $Dependency.Name -and $_.Version -eq $Dependency.Version})
        if ($Installed) {
            'module {0} version {1} already installed. Skipping.' -f $Dependency.Name, $Dependency.Version
            continue
        }
        Save-Module @Params -Name $Dependency.Name -RequiredVersion $Dependency.Version
        ' '
        ' '
    }
}