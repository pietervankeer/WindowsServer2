#------------------------------------------------------------------------------
# Certificatieserver
#------------------------------------------------------------------------------

#------------------------------------------------------------------------------
# Variables
#------------------------------------------------------------------------------

#$generalSettings = Get-Content -Path "../settings.json" | ConvertFrom-Json
#$settings = Get-Content -Path "settings.json" | ConvertFrom-Json


#------------------------------------------------------------------------------
# Installation Certificatieserver role
#------------------------------------------------------------------------------

# Install benodigde rollen
try {
    $jobs = @()
    $jobs += start-Job -Command {
        Install-WindowsFeature -ConfigurationFilePath "F:\configfiles\install_ca.xml"
    }
    Receive-Job -Job $jobs -Wait | select-Object Success, RestartNeeded, exitCode, FeatureResult
    Write-Host 'webserver successfully installed' -ForegroundColor Green
} catch {
    Write-Warning -Message $("Failed to install AD CS. Error: " + $_.Exception.Message)
}

#------------------------------------------------------------------------------
# Configuration Certificatieserver
#------------------------------------------------------------------------------

# configureer de rol AD CS zodat een deze zich zal gedragen als een Enterprise root CA
try {
    $jobs = @()
    $jobs += start-Job -Command {
        Install-AdcsCertificationAuthority -CAType EnterpriseRootCa -CryptoProviderName "RSA#Microsoft Software Key Storage Provider" -KeyLength 2048 -HashAlgorithmName SHA1 -ValidityPeriod Years -ValidityPeriodUnits 3
    }
    Receive-Job -Job $jobs -Wait | select-Object Success, RestartNeeded, exitCode, FeatureResult
}
catch {
    Write-Warning -Message $("Failed to configure AD CS. Error: " + $_.Exception.Message)
}


Pause