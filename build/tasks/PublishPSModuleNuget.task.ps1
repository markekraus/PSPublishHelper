Task PublishPSModuleNuget Initialize, ImportModule, {
    $Module = Get-Module -Name $ModuleName
    'Publishing Module "{0}" Nupkg' -f $Module.Name
    $Script:PSModuleNupkg = $Module | Publish-PSModuleNuget -OutputPath $OutputPath -Verbose -PassThru |
        Foreach-Object -MemberName FullName
    'PSModuleNupkg: {0}' -f $Script:PSModuleNupkg
}
