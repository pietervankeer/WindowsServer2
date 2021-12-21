#------------------------------------------------------------------------------
# Domaincontroller
#------------------------------------------------------------------------------

#------------------------------------------------------------------------------
# Variables
#------------------------------------------------------------------------------

# inlezen config bestanden
$generalSettings = Get-Content -Path "../settings.json" | ConvertFrom-Json
$settings = Get-Content -Path settings.json | ConvertFrom-Json

# variabelen initialiseren
$netwerkid = $generalSettings.DNS.NetworkID

#------------------------------------------------------------------------------
# DNS config
#------------------------------------------------------------------------------

try {
    # Add reverse lookup zone
    Add-DnsServerPrimaryZone -NetworkID $netwerkid -ReplicationScope "Domain" -DynamicUpdate "Secure"
    Write-Host "Reverse lookup zone successfully addedd" -ForegroundColor Green
}
catch {
    Write-Warning -Message $("Failed to add reverse lookup zone. Error: "+ $_.Exception.Message)
}

#------------------------------------------------------------------------------
# NAT routing
#------------------------------------------------------------------------------

# installeer benodigde role
try {
    $jobs = @()
    $jobs += start-Job -Command {
        Install-WindowsFeature -ConfigurationFilePath F:\configfiles\install_natrouting.xml
    }
    Receive-Job -Job $jobs -Wait | select-Object Success, RestartNeeded, exitCode, FeatureResult
    Write-Host "Natrouting successfully installed" -ForegroundColor Green
}
catch {
    Write-Warning -Message $("Failed to install natrouting. Error: " + $_.Exception.Message)
}

Pause