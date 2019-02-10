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
        $ProjectUri,

        [Parameter(Mandatory = $false, ParameterSetName = 'PSModuleInfo')]
        [Parameter(Mandatory = $false, ParameterSetName = 'NameAndVersion')]
        [Switch]
        $PassThru
    )
    
    begin {
        $Nuget = Resolve-NugetCommand -Cmdlet $PSCmdlet -ErrorAction Stop
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

        $Params = @{
            Module = $InputObject
            PSData = $PSData
            ErrorAction = 'stop'
        }
        $NuspecContents = Get-NuspecContents @Params

        $TempPath = $InputObject | Get-TemporaryPath
        try {
            Copy-PSModule -Module $InputObject -Path $TempPath
            $NuspecPath = Get-NuspecFilePath -Module $InputObject -Path $TempPath
            $NuspecContents | Set-Content -Path $NuspecPath -Force -Confirm:$false -WhatIf:$false
            $NupkgFilePath = Get-NupkgFilePath -Module $InputObject -Path $DestinationPath
            Push-Location -StackName PSPublishHelperNugetPack -Path $TempPath
            $Output = & $Nuget pack $NuspecPath -OutputDirectory $DestinationPath -BasePath $TempPath -Verbosity quiet -NonInteractive
            Write-Verbose "Nuget Pack Output: $Output"
        }
        finally {
            Pop-Location -StackName PSPublishHelperNugetPack
            $Params = @{
                Path = Split-path -Parent $TempPath
                Recurse = $true
                Force = $true
                ErrorAction = 'SilentlyContinue'
            }
            Microsoft.PowerShell.Management\Remove-Item @Params
        }

        if($PassThru) {
            Get-item -Path $NupkgFilePath -ErrorAction SilentlyContinue
        }
    }
}