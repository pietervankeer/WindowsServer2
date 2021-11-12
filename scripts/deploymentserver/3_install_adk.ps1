#------------------------------------------------------------------------------
# Deploymentserver
#------------------------------------------------------------------------------

#------------------------------------------------------------------------------
# Variables
#------------------------------------------------------------------------------

# Pad naar de installer voor adk
$file="F:\configfiles\install_adk.exe"

# install adk.exe
try {
    $EXEArguments = @(
        ('"{0}"' -f $file)
    )
    Start-Process "$file" -Wait 
    Write-Host 'Microsoft Deployment Toolkit successfully installed' -ForegroundColor Green
} catch {
    Write-Warning -Message $("Failed to install Microsoft Deployment Toolkit. Error: " + $_.Exception.Message)
}

Pause