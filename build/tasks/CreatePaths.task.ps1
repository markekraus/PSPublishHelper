Task CreatePaths Initialize, {
    'Creating project directories'
    foreach($Path in $Script:ProjectDirectories) {
        New-Item -ItemType Directory -Path $Path -Force | ForEach-Object -MemberName FullName
    }
}