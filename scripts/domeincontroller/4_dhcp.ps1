#------------------------------------------------------------------------------
# Domaincontroller
#------------------------------------------------------------------------------

#------------------------------------------------------------------------------
# Variables
#------------------------------------------------------------------------------

# inlezen config bestanden
$generalSettings = Get-Content -Path "../settings.json" | ConvertFrom-Json
$settings = Get-Content -Path settings.json | ConvertFrom-Json

# dhcp config
$scopeName = $settings.DHCP.scopeName
$scopeStartIp = $settings.DHCP.scopeStartIp
$scopeEndIp = $settings.DHCP.scopeEndIp
$scopeSubMask= $settings.DHCP.scopeSubnetMask
$scopeDescr= $settings.DHCP.scopeDescr
$scopeLease= $settings.DHCP.scopeLease

# scope id samenstellen
$scopeIdArray = $scopeStartIp.Split(".")
$scopeId = $scopeIdArray[0]+"."+$scopeIdArray[1]+"."+$scopeIdArray[2]+"."+0

$domeinNaam = $generalSettings.ADDS.DomainName
$ipServer1 = $settings.Network[1].IPAdress


#------------------------------------------------------------------------------
# DHCP
#------------------------------------------------------------------------------

# Install dhcp
try {
    $jobs = @()
    $jobs += start-Job -Command {
        Install-WindowsFeature -ConfigurationFilePath F:\configfiles\install_dhcp.xml
    }
    Receive-Job -Job $jobs -Wait | select-Object Success, RestartNeeded, exitCode, FeatureResult
    Write-Host "DHCP successfully installed" -ForegroundColor Green
}
catch {
    Write-Warning -Message $("Failed to install DHCP. Error: " + $_.Exception.Message)
}

# Configure DHCP
try {
    # Create DHCP security groups
    netsh dhcp add securitygroups

    # Add DHCP to DC
    Add-DhcpServerInDC
    Write-Host "DHCP added in DC" -ForegroundColor Green

    # Add IPv4 scope
    Add-DHCPServerv4Scope -Name $scopeName -StartRange $scopeStartIp -EndRange $scopeEndIp -SubnetMask $scopeSubMask -Description $scopeDescr -LeaseDuration $scopeLease -State Active
    Write-Host "DHCP scope added" -ForegroundColor Green

    # authorize DHCP server
    Set-DHCPServerv4OptionValue -ScopeID $scopeId -DnsDomain $domeinNaam -DnsServer $ipServer1 -Router $ipServer1
    Write-Host "Scope authorized" -ForegroundColor Green

    # Restart DHCP server
    Restart-Service dhcpserver
    
    # Notify Server Manager that post-install DHCP configuration is complete
    Set-ItemProperty –Path registry::HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\ServerManager\Roles\12 –Name ConfigurationState –Value 2

    Write-Host "DHCP configured succesfully" -ForegroundColor Green
}
catch {
    Write-Warning -Message $("Failed to configure DHCP. Error: " + $_.Exception.Message)
}

Pause