#------------------------------------------------------------------------------
# Webserver
#------------------------------------------------------------------------------

#------------------------------------------------------------------------------
# Variables
#------------------------------------------------------------------------------

$generalSettings = Get-Content -Path "../settings.json" | ConvertFrom-Json
$settings = Get-Content -Path settings.json | ConvertFrom-Json

$webserverPath = "C:\inetpub\wwwroot"

$html = '
<!DOCTYPE html>
<html>
<head>
<title>IIS Windows Server</title>
<style type="text/css">
body {
	color:#000000;
	background-color:#0072C6;
	margin:0;
}
</style>
</head>
<body>
	<h1>Hallo, Welkom op de webserver in het domein EP1-PIETER.HoGent</h1>
</body>
</html>
'

#------------------------------------------------------------------------------
# Installation Webserver role
#------------------------------------------------------------------------------

# Install roles
try {
    $jobs = @()
    $jobs += start-Job -Command {
        Install-WindowsFeature -configurationFilePath F:\configfiles\install_webserver.xml
    }
    Receive-Job -Job $jobs -Wait | select-Object Success, RestartNeeded, exitCode, FeatureResult
    Write-Host "Webserver succesfully installed" -ForegroundColor Green
}
catch {
    Write-Warning -Message $("Failed to install Webserver. Error: " + $_.Exception.Message)
}

#------------------------------------------------------------------------------
# Configuration Webserver
#------------------------------------------------------------------------------

# replace existing html file.
try {
    # remove html file
    rm $webserverPath\iisstart.*

    # make new html file
    New-Item $webserverPath\index.html -ItemType File
    # add html to file
    Set-Content $webserverPath\index.html $html

    Write-Host "html file succesfully removed." -ForegroundColor Green
}
catch {
    Write-Warning -Message $("Failed to configure Webserver. Error: " + $_.Exception.Message)
}

Pause