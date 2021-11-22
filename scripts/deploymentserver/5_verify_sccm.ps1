#------------------------------------------------------------------------------
# Deploymentserver
#------------------------------------------------------------------------------

#------------------------------------------------------------------------------
# Variables
#------------------------------------------------------------------------------

$sccm_console="C:\Program Files (x86)\Microsoft Configuration Manager\AdminConsole\bin\Microsoft.ConfigurationManagement.exe"


# try to open sccm console
try {
    # Check is path is valid
    if (Test-Path -Path "$sccm_console") {
        Write-Host "$sccm_console found." -ForegroundColor Green

        # open sccm console
        Start-Process "$sccm_console" -Wait
    }
    else {
        Write-Warning -Message "$sccm_console not found."
    }
}
catch {
    Write-Warning -Message @("Something went wrong. Error: " + $_.Exception.Message)
}

Pause