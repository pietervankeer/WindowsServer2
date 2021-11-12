#------------------------------------------------------------------------------
# Deploymentserver
#------------------------------------------------------------------------------

#------------------------------------------------------------------------------
# Variables
#------------------------------------------------------------------------------

# Pad naar de installer voor sccm
$file="F:\configfiles\install_sccm.exe"

# install sccm.exe
try {
    $EXEArguments = @(
        ('"{0}"' -f $file)
    )
    Start-Process "$file" -Wait 
    Write-Host 'Microsoft SCCM successfully installed' -ForegroundColor Green
} catch {
    Write-Warning -Message $("Failed to install Microsoft SCCM. Error: " + $_.Exception.Message)
}

Pause