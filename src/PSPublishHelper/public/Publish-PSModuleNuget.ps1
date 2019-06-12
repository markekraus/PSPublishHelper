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
        $OutputPath,

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
        Write-Verbose "Nuget found at $($Nuget.Path)"
        $OutputPath = Convert-Path $OutputPath -ErrorAction Stop
        Write-Verbose "Output Path: $OutputPath"
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

        Write-Verbose "Using Module from $($InputObject.ModuleBase)"

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
            Copy-PSModule -Module $InputObject -Path $TempPath -ErrorAction Stop
            $NuspecPath = Get-NuspecFilePath -Module $InputObject -Path $TempPath -ErrorAction Stop
            $NuspecContents | Set-Content -Path $NuspecPath -Force -Confirm:$false -WhatIf:$false -ErrorAction Stop
            $NupkgFilePath = Get-NupkgFilePath -Module $InputObject -Path $OutputPath -ErrorAction Stop
            Push-Location -StackName PSPublishHelperNugetPack -Path $TempPath -ErrorAction Stop
            $Output = & $Nuget pack $NuspecPath -OutputDirectory $OutputPath -BasePath $TempPath -Verbosity detailed -NonInteractive -NoDefaultExcludes
            Write-Verbose "Nuget Pack Output:"
            foreach($Line in $Output) {
                if($Line -notmatch 'NU5110|NU5111'){
                    Write-Verbose $Line
                }
            }
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
