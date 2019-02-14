Task Clean Initialize, {
    'Removing OutputPath contents'
    Get-ChildItem -Path $OutputPath -Force | Remove-Item -Recurse -Force -Verbose
}