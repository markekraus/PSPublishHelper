Task VersionBump Initialize, InstallDependencies, {
    if(-Not $BuildVersion) {
        'BuildVersion not present'
        'Locating GitVersion binary'
        $command = Get-Command -Name 'gitversion' -CommandType 'Application' |
            Where-Object {$_.Version -eq '4.0.0.0'} |
            select-object -First 1
        Push-Location $ProjectRoot
        try {
            'Executing GitVersion'
            $GtVersion = & $command | ConvertFrom-Json -ErrorAction 'Stop'
        } finally {
            Pop-Location
        }

        $Script:BuildVersion = $GtVersion.NuGetVersionV2
    } else {
        'BuildVersion {0} was supplied' -f $BuildVersion
    }

    $NewVersion, $PreviewVersion = $BuildVersion -split '-'
    $PreviewVersion = -join $PreviewVersion

    $Manifest = Import-PowerShellDataFile -Path $ModuleOutputManifestFile
    $PreviousVersion = $Manifest.ModuleVersion

    If (-not $Manifest.PrivateData) {
        'PrivateData was not found'
        $Manifest['PrivateData'] = @{}
    }

    'Updating {0} with version {1}' -f $ModuleOutputManifestFile, $NewVersion
    Update-Metadata -Path $ModuleOutputManifestFile -PropertyName 'ModuleVersion' -Value $NewVersion

    if($PreviewVersion) {
        'Updating {0} with Prerelease {1}' -f $ModuleOutputManifestFile, $PreviewVersion
        $Manifest.PrivateData['Prerelease'] = $PreviewVersion
        Update-Metadata -Path $ModuleOutputManifestFile -PropertyName 'PrivateData' -Value $Manifest.PrivateData
    } else {
        'Remove Prerelease from {0}' -f 
        $Manifest.PrivateData.Remove('Prerelease')
        Update-Metadata -Path $ModuleOutputManifestFile -PropertyName 'PrivateData' -Value $Manifest.PrivateData
    }

    $NewManifest = Import-PowerShellDataFile -Path $ModuleOutputManifestFile

    'OldManifestVersion:    {0}' -f $PreviousVersion
    'BuildVersion:          {0}' -f $BuildVersion
    'NewVersion:            {0}' -f $NewVersion
    'NewManifestVersion:    {0}' -f $NewManifest.ModuleVersion
    'NewManifestPrerelease: {0}' -f $NewManifest.PrivateData.Prerelease
}