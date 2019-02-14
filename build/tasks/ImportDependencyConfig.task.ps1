Task ImportDependencyConfig Initialize, {
    'Importing dependency configuration from {0}' -f $DependenciesFile
    $Script:DependencyConfig = Get-Content -Raw $DependenciesFile -ErrorAction stop | ConvertFrom-Json -ErrorAction stop
}