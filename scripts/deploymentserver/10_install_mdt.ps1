#------------------------------------------------------------------------------
# Deploymentserver
#------------------------------------------------------------------------------

#------------------------------------------------------------------------------
# Variables
#------------------------------------------------------------------------------

# Pad naar de installer voor mdt
$file="F:\configfiles\install_mdt.msi"

# install mdt.msi
try {
    $MSIArguments = @(
        "/i"
        ('"{0}"' -f $file)
    )
    Start-Process "msiexec.exe" -ArgumentList $MSIArguments -Wait 
    Write-Host 'Microsoft Deployment Toolkit successfully installed' -ForegroundColor Green
} catch {
    Write-Warning -Message $("Failed to install Microsoft Deployment Toolkit. Error: " + $_.Exception.Message)
}

Pause