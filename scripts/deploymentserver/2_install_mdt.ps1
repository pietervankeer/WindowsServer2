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
    $DataStamp = get-date -Format yyyyMMddTHHmmss
    $logFile = '{0}-{1}.log' -f $file.fullname,$DataStamp
    $MSIArguments = @(
        "/i"
        ('"{0}"' -f $file.fullname)
        "/qn"
        "/norestart"
        "/L*v"
        $logFile
    )
    Start-Process "msiexec.exe" -ArgumentList $MSIArguments -Wait -NoNewWindow 
    Write-Host 'Microsoft Deployment Toolkit successfully installed' -ForegroundColor Green
} catch {
    Write-Warning -Message $("Failed to install Microsoft Deployment Toolkit. Error: " + $_.Exception.Message)
}

Pause