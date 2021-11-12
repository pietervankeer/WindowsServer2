#------------------------------------------------------------------------------
# Domaincontroller
#------------------------------------------------------------------------------

# Create container "System management"
New-ADObject -Name "System Management" -Type "container" -Path "CN=System,DC=ep1-pieter,DC=hogent"
Write-Host "Container: System Management succesfully created" -ForegroundColor Green

Pause