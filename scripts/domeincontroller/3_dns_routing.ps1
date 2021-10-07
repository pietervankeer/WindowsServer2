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
