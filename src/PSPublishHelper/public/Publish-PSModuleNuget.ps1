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
            $InputObject = Get-Module -ListAvailable -Name $Name |
                Where-Object {$_.Version.ToString() -eq $RequiredVersion} |
                Select-Object -First 1
            if (-not $InputObject) {
                $ErrorRecord = [System.Management.Automation.ErrorRecord]::new(
                    [System.Management.Automation.ItemNotFoundException]::new("Unable to find Module $Name Version $RequiredVersion"),
                    "ModuleNotFound",
                    [System.Management.Automation.ErrorCategory]::InvalidArgument,
                    $null
                )
                $PSCmdlet.ThrowTerminatingError($ErrorRecord)
            }
        }

        $Params = @{
            IconUri = $IconUri
            ReleaseNotes = $ReleaseNotes
            PSModuleInfo = $InputObject
            Tags = $Tags
            ProjectUri = $ProjectUri
            LicenseUri = $LicenseUri
        }
        $PSData = Resolve-PSData @Params
    }
    
    end {
    }
}