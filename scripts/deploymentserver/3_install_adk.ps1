#------------------------------------------------------------------------------
# Deploymentserver
#------------------------------------------------------------------------------

#------------------------------------------------------------------------------
# Variables
#------------------------------------------------------------------------------

# Pad naar de installer voor adk en sql
$file="F:\configfiles\install_adk.exe"
$filesql="F:\configfiles\install_sql2016.exe"
$filessms="F:\configfiles\install_SSMS.exe"

# install adk.exe
try {
    $EXEArguments = @(
        ('"{0}"' -f $file)
    )
    Start-Process "$file" -Wait 
    Write-Host 'Microsoft ADK successfully installed' -ForegroundColor Green
} catch {
    Write-Warning -Message $("Failed to install Microsoft ADK. Error: " + $_.Exception.Message)
}



# install sql.exe
try {
    $EXEArguments = @(
        ('"{0}"' -f $filesql)
    )
    Start-Process "$filesql" -Wait 
    Write-Host 'Microsoft SQL server successfully installed' -ForegroundColor Green
} catch {
    Write-Warning -Message $("Failed to install Microsoft SQL server. Error: " + $_.Exception.Message)
}

# install ssms.exe
try {
    $EXEArguments = @(
        ('"{0}"' -f $filessms)
    )
    Start-Process "$filessms" -Wait 
    Write-Host 'Microsoft SSMS successfully installed' -ForegroundColor Green
} catch {
    Write-Warning -Message $("Failed to install Microsoft SSMS. Error: " + $_.Exception.Message)
}

Pause