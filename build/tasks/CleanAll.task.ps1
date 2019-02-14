Task CleanAll Initialize, {
    'Cleaning all project directories'
    foreach($Path in $Script:ProjectDirectories) {
        try {
            'Removing {0}...' -f $Path
            Remove-Item -Path $Path -Recurse -Force -ErrorAction Stop
            'Removed path {0}.' -f $Path
        } catch [System.Management.Automation.ItemNotFoundException] {
            '{0} was already removed.' -f $Path
        } catch {
            Write-Error -ErrorRecord $_
        }
    }
}
