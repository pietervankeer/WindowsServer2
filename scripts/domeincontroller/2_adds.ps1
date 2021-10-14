#------------------------------------------------------------------------------
# Domaincontroller
#------------------------------------------------------------------------------

#------------------------------------------------------------------------------
# Variables
#------------------------------------------------------------------------------

$generalSettings = Get-Content -Path "../settings.json" | ConvertFrom-Json
$settings = Get-Content -Path settings.json | ConvertFrom-Json

$domainName = $generalSettings.ADDS.domainName
$netBiosName = $generalSettings.ADDS.netBiosName
$password = $generalSettings.ADDS.password


#------------------------------------------------------------------------------
# Installation ADDS
#------------------------------------------------------------------------------

Try {

    Install-WindowsFeature AD-Domain-Services -IncludeManagementTools -Restart -ErrorAction Stop
    Write-Host "Active Directory Domain Services installed successfully" -ForegroundColor Green

} Catch {

    Write-Warning -Message $("Failed to install Active Directory Domain Services. Error: "+ $_.Exception.Message)
}

#------------------------------------------------------------------------------
# Promotion to domain controller
#------------------------------------------------------------------------------

try {
    Import-Module ADDSDeployment
    Install-ADDSForest `
    -CreateDnsDelegation:$false `
    -DatabasePath "C:\Windows\NTDS" `
    -DomainMode "WinThreshold" `
    -DomainName $domainName `
    -DomainNetbiosName $netBiosName `
    -ForestMode "WinThreshold" `
    -InstallDns:$true `
    -LogPath "C:\Windows\NTDS" `
    -NoRebootOnCompletion:$false `
    -SysvolPath "C:\Windows\SYSVOL" `
    -SafeModeAdministratorPassword (ConvertTo-SecureString -String $password -AsPlainText -Force) `
    -Force:$true
    Write-Host "Active Directory Domain Services have been configured successfully" -ForegroundColor Green
}
catch {
    Write-Warning -Message $("Failed to configure Active Directory Domain Services. Error: "+ $_.Exception.Message)
}

try {
    NEW-ADOrganizationalUnit "MemberServers”
    Write-Host "Active Directory Domain Services Organisational Unit has been added" -ForegroundColor Green
}
catch {
    Write-Warning -Message $("Failed to add Active Directory Domain Services organisational unit. Error: "+ $_.Exception.Message)
}

Pause