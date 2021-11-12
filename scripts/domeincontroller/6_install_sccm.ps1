#------------------------------------------------------------------------------
# Domeincontroller
#------------------------------------------------------------------------------

# Pad naar de installer voor sccm
$sccmfiles="F:\configfiles\install_sccm.exe"
$extendSchemaFile="C:\SC_Configmgr_SCEP_1606\SMSSETUP\BIN\X64\extadsch.exe"
$logfile="C:\ExtADSch.log"

# install sccm.exe
try {
    if (Test-Path -Path $extendSchemaFile -PathType Leaf) {
        Write-Host 'SCCM already unzipped, Moving on...' -ForegroundColor Green
    }
    else {
        
        $EXEArguments = @(
            ('"{0}"' -f $sccmfiles)
            )
        Start-Process "$sccmfiles" -Wait 
        Write-Host 'Microsoft SCCM successfully Unzipped' -ForegroundColor Green
    }
} catch {
    Write-Warning -Message $("Failed to Unzip Microsoft SCCM. Error: " + $_.Exception.Message)
}

# Extend schema
try {
    if (Test-Path -Path $logfile -PathType Leaf) {
        Write-Host 'Active directory Schema already extended, Moving on...' -ForegroundColor Green
    }
    else {
        
        $EXEArguments = @(
            ('"{0}"' -f $extendSchemaFile)
            )
        Start-Process "$extendSchemaFile" -Wait
        # get log message
        Get-Content $logfile | Where-Object {$_ -like '*Successfully extended*'}
        Write-Host 'Active directory Schema extended' -ForegroundColor Green
    }
} catch {
    Write-Warning -Message $("Failed to extend Active directory Schema. Error: " + $_.Exception.Message)
}

Pause