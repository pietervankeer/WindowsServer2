#------------------------------------------------------------------------------
# Webserver
#------------------------------------------------------------------------------

#------------------------------------------------------------------------------
# Variables
#------------------------------------------------------------------------------

$generalSettings = Get-Content -Path "../settings.json" | ConvertFrom-Json
$settings = Get-Content -Path settings.json | ConvertFrom-Json


#------------------------------------------------------------------------------
# Installation Webserver role
#------------------------------------------------------------------------------

# Install roles
try {
    $job = @()
    $jobs += start-Job -Command {
        Install-WindowsFeature –ConfigurationFilePath F:\configfiles\install_webserver.xml
    }
    Receive-Job -Job $jobs -Wait | select-Object Success, RestartNeeded, exitCode, FeatureResult
    Write-Host "webserver successfully installed" -ForegroundColor Green
}
catch {
    Write-Warning -Message $("Failed to install webserver. Error: "+ $_.Exception.Message)
}

#------------------------------------------------------------------------------
# Configuration Webserver
#------------------------------------------------------------------------------

# TODO

Pause