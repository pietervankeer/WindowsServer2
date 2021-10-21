
$domaincontrollersettings = Get-Content -Path ../domeincontroller/settings.json | ConvertFrom-Json
$algemeneSettings = Get-Content -Path ../settings.json | ConvertFrom-Json

# default gateway
$defaultGateway = $domaincontrollersettings.Network[1].IPAdress

# prepare domain join
$password = ConvertTo-SecureString $algemeneSettings.ADDS.password -AsPlainText -Force
$Cred = New-Object System.Management.Automation.PSCredential ("Administrator", $password)
$domainName = $algemeneSettings.ADDS.DomainName


# Domein joinen
try {
    Add-Computer -DomainName $domainName -OUPath "OU=MemberServers,DC=EP1-PIETER,DC=hogent" -Credential $Cred
    Write-Host "Joined Domein $domainName" -ForegroundColor Green
}
catch {
    Write-Warning -Message $("Failed to join domain $domainName. Error: "+ $_.Exception.Message)
}

Pause
Restart-Computer