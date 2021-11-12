#------------------------------------------------------------------------------
# Deploymentserver
#------------------------------------------------------------------------------

#------------------------------------------------------------------------------
# Variables
#------------------------------------------------------------------------------

# Pad naar de installer voor sccm
$sccmfiles="F:\configfiles\install_sccm.exe"
$extendSchemaFile="C:\SC_Configmgr_SCEP_1606\SMSSETUP\BIN\X64\extadsch.exe"
$logfile="C:\ExtADSch.log"

try {
    $jobs = @()
    $jobs += start-Job -Command {
        Install-WindowsFeature -ConfigurationFilePath F:\configfiles\install_prerequisites.xml
    }
    Receive-Job -Job $jobs -Wait | select-Object Success, RestartNeeded, exitCode, FeatureResult
    Write-Host "SCCM prerequisites successfully installed" -ForegroundColor Green
}
catch {
    Write-Warning -Message $("Failed to install SCCM prerequisites. Error: " + $_.Exception.Message)
}

Pause