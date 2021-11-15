#------------------------------------------------------------------------------
# Deploymentserver
#------------------------------------------------------------------------------

#------------------------------------------------------------------------------
# Variables
#------------------------------------------------------------------------------

# Pad naar de installer voor sccm
$file="F:\configfiles\install_sccm.exe"
$sccmInstaller="C:\MEM_Configmgr_2103\splash.hta"

function exec_file {
    param (
        $file
    )
    
    Start-Process "$file" -Wait 
}

# unpack SCCM.exe
if (Test-Path -path $sccmInstaller) {
    Write-Host "Microsoft SCCM installer already exists" -ForegroundColor Green
}
else {
    try {
        exec_file($file)
        Write-Host 'Microsoft SCCM successfully unzipped' -ForegroundColor Green
    } catch {
        Write-Warning -Message $("Failed to unzip Microsoft SCCM. Error: " + $_.Exception.Message)
    }
}

# create folder for sccm updates
if (Test-Path -path "C:\Users\SCCM") {
    Write-Host "C:\Users\SCCM already exists. Moving on..." -ForegroundColor Green
}
else {
    mkdir C:\Users\SCCM
    Write-Host "C:\SCCM created." -ForegroundColor Green
}

# install SCCM
try {
    exec_file($sccmInstaller)
    Write-Host "SCCM successfully installed." -ForegroundColor Green
}
catch {
    Write-Warning -Message @("SCCM not successfully installed. Error: " + $_.Exception.Message)
}


Pause