Task Clean Initialize, {
    'Removing OutputPath contents'
    Get-ChildItem -Path $OutputPath -Force -ErrorAction SilentlyContinue | Remove-Item -Recurse -Force -Verbose
}