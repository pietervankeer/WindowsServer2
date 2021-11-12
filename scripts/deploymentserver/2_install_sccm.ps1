#------------------------------------------------------------------------------
# Deploymentserver
#------------------------------------------------------------------------------

#------------------------------------------------------------------------------
# Variables
#------------------------------------------------------------------------------

# install nodige features and roles voor SCCM
try {
    $jobs = @()
    $jobs += start-Job -Command {
        Install-WindowsFeature -ConfigurationFilePath F:\configfiles\install_prerequisites.xml
    }
    Receive-Job -Job $jobs -Wait | select-Object Success, RestartNeeded, exitCode, FeatureResult
    Write-Host "SCCM prerequisites successfully installed" -ForegroundColor Green
}
catch {
    Write-Warning -Message $("Failed to install SCCM prerequisites. Error: " + $_.Exception.Message)
}

Pause
Restart-Computer