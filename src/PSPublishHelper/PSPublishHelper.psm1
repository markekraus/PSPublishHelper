$Script:Nuspec = @"
<?xml version="1.0"?>
<package >
    <metadata>
        <id>{0}</id>
        <version>{1}</version>
        <authors>{2}</authors>
        <owners>{3}</owners>
        <description>{4}</description>
        <releaseNotes>{5}</releaseNotes>
        <requireLicenseAcceptance>{6}</requireLicenseAcceptance>
        <copyright>{7}</copyright>
        <tags>{8}</tags>
        {9}
        {10}
        {11}
        <dependencies>
            {12}
        </dependencies>
    </metadata>
</package>
"@