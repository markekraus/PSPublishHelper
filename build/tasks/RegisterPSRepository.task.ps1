Task RegisterPSRepository -If {$Script:PSRepositoryName} Initialize, {
    'Ensuring repository {0} at {1}' -f $PSRepositoryName, $PSRepositoryUrl
    $PSRepository = Get-PSRepository -Name $PSRepositoryName -ErrorAction SilentlyContinue

    if ($PSRepository -and $PSRepository.SourceLocation -eq $PSRepositoryUrl) {
        'PSRepository {0} already exists. Skipping.' -f $PSRepositoryName
        return
    }

    if($PSRepository -and ($PSRepository.SourceLocation -ne $PSRepositoryUrl -or $PSRepository.InstallationPolicy -ne 'Trusted')) {
        'PSRepository {0} has invalid SourceLocation {1}. expected {2}' -f @(
            $PSRepositoryName,
            $PSRepository.SourceLocation,
            $PSRepositoryUrl
        )
        Unregister-PSRepository -Name $PSRepositoryName -Verbose
    }

    $Params = @{
        Name = $PSRepositoryName
        SourceLocation =  $PSRepositoryUrl
        PublishLocation =  $PSRepositoryUrl
        InstallationPolicy = "Trusted"
        Verbose = $true
    }
    if($PSRepositoryUser -and $PSRepositoryPassword) {
        'PSRepositoryUser and PSRepositoryPassword present and will be used for registration'
        $SecurePass = $PSRepositoryPassword | ConvertTo-SecureString -AsPlainText -Force
        $Params['Credential'] = [PSCredential]::new($PSRepositoryUser, $SecurePass)
    }
    'Registering PSRepository {0} at {1}' -f $PSRepositoryName, $PSRepositoryUrl
    Register-PSRepository @Params
}