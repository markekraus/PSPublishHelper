function Publish-PSModuleNuget {
    [CmdletBinding(DefaultParameterSetName = 'NameAndVersion')]
    param (
        [Parameter(
            Mandatory,
            ParameterSetName = 'NameAndVersion'
        )]
        [ValidateNotNullOrEmpty()]
        [string]
        $Name,

        [Parameter(
            Mandatory,
            ParameterSetName = 'NameAndVersion'
        )]
        [ValidateNotNullOrEmpty()]
        [string]
        $RequiredVersion,

        [Parameter(
            Mandatory,
            ParameterSetName = 'PSModuleInfo',
            ValueFromPipeline
        )]
        [ValidateNotNull()]
        [PSModuleInfo]
        $InputObject,

        [Parameter(
            Mandatory,
            ParameterSetName = 'NameAndVersion'
        )]
        [Parameter(
            Mandatory,
            ParameterSetName = 'PSModuleInfo'
        )]
        [ValidateNotNullOrEmpty()]
        [ValidateScript({
            if(-not (Test-Path -PathType Container -Path $_)){throw}
            else {$true}
        })]
        [string]
        $DestinationPath,

        [Parameter(Mandatory = $false, ParameterSetName = 'PSModuleInfo')]
        [Parameter(Mandatory = $false, ParameterSetName = 'NameAndVersion')]
        [string]
        $ReleaseNotes,

        [Parameter(Mandatory = $false, ParameterSetName = 'PSModuleInfo')]
        [Parameter(Mandatory = $false, ParameterSetName = 'NameAndVersion')]
        [string[]]
        $Tags,

        [Parameter(Mandatory = $false, ParameterSetName = 'PSModuleInfo')]
        [Parameter(Mandatory = $false, ParameterSetName = 'NameAndVersion')]
        [Uri]
        $LicenseUri,

        [Parameter(Mandatory = $false, ParameterSetName = 'PSModuleInfo')]
        [Parameter(Mandatory = $false, ParameterSetName = 'NameAndVersion')]
        [Uri]
        $IconUri,

        [Parameter(Mandatory = $false, ParameterSetName = 'PSModuleInfo')]
        [Parameter(Mandatory = $false, ParameterSetName = 'NameAndVersion')]
        [Uri]
        $ProjectUri
    )
    
    begin {
        $TempPath = [System.IO.Path]::GetTempPath()
    }
    
    process {
        if($PSCmdlet.ParameterSetName -eq 'NameAndVersion') {
            $Params = @{
                Cmdlet = $PSCmdlet
                Name = $Name
                RequiredVersion = $RequiredVersion
                ErrorAction = 'stop'
            }
            $InputObject = Resolve-PSModule @Params
        }

        $Params = @{
            IconUri = $IconUri
            ReleaseNotes = $ReleaseNotes
            Module = $InputObject
            Tags = $Tags
            ProjectUri = $ProjectUri
            LicenseUri = $LicenseUri
        }
        $PSData = Resolve-PSData @Params

        $NuspecContents = Get-NuspecContents -Module $InputObject -PSData $PSData
    }

    end {
    }
}