
$domaincontrollersettings = Get-Content -Path ../domeincontroller/settings.json | ConvertFrom-Json

# default gateway
$defaultGateway = $domaincontrollersettings.Network[1].IPAdress

# domain join
$password = ConvertTo-SecureString $generalsettings.ADDS.password -AsPlainText -Force
$Cred = New-Object System.Management.Automation.PSCredential ("Administrator", $password)


# Domein joinen
Add-Computer -DomainName EP1-PIETER.hogent -OUPath "OU=MemberServers,DC=EP1-PIETER,DC=hogent" -Credential $Cred