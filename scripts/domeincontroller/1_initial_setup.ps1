#------------------------------------------------------------------------------
# Domaincontroller
#------------------------------------------------------------------------------

#------------------------------------------------------------------------------
# Variables
#------------------------------------------------------------------------------

$settings = Get-Content -Path settings.json | ConvertFrom-Json

# Networkinstellingen ophalen uit configuratiebestand
$netAdapters= $settings.Network
# Hostnameinstellingen ophalen uit configuratiebestand
$hostname = $settings.Hostname

#------------------------------------------------------------------------------
# Hostname
#------------------------------------------------------------------------------

# Set hostname
try {
    Rename-Computer -NewName $hostname
    Write-Host "Hostname changed successfully" -ForegroundColor Green   
}
catch {
    Write-Host "Hostname not changed, something failed" -ForegroundColor Red   
}

#------------------------------------------------------------------------------
# Windows updates
#------------------------------------------------------------------------------

Try{
    # Stop windows update service
    Stop-Service wuauserv
    Write-Host "wuauserv stopped" -ForegroundColor Green
}
catch{
    Write-Host "Updates not Stopped, something failed" -ForegroundColor Red
    Get-Service wuauserv
}

try {
    # disable windows update service
    Set-Service -service "wuauserv" -startupType "Disabled"
    Write-Host "wuauserv disabled" -ForegroundColor Green
}
catch {
    Write-Host "Updates not disabled, something failed" -ForegroundColor Red
    Get-Service wuauserv
}
#------------------------------------------------------------------------------
# Network Adapters
#------------------------------------------------------------------------------

function Update-NetAdapter($name, $newName, $ipv4Address, $dhcp) {

    Try {
        # Adapter exists?
        $tmp = Get-NetAdapter -Name $name -ErrorAction Stop 

        # Rename adapter
        Rename-NetAdapter -Name $name -NewName $newName

        # Disable IPv6
        Disable-NetAdapterBinding -Name $newName -ComponentID ms_tcpip6

        # Set static IP
        if (-Not [string]::IsNullOrEmpty($ipv4Address)) {
            New-NetIPAddress -InterfaceAlias $newName -IPAddress $ipv4Address -AddressFamily IPv4 -PrefixLength "24" | Out-Null
        }

        # DHCP
        if (-Not $dhcp) {
            Set-NetIPInterface -InterfaceAlias $newName -Dhcp Disabled
        }

        Write-Host "Network Adapter " $name " updated successfully" -ForegroundColor Green

    } Catch {

        Write-Warning -Message $("Failed to Update Network Adapter " + $name  + ". Error: "+ $_.Exception.Message)
    }
}

# WAN
Update-NetAdapter -name "Ethernet" -newName $netAdapters[0].Name -dhcp $True

# LAN
Update-NetAdapter -name "Ethernet 2" -newName $netAdapters[1].Name -ipv4Address $netAdapters[1].IPAdress -dhcp $False



# Restart computer
Write-Host "All changes will take effect after the startup"
Pause
Restart-Computer