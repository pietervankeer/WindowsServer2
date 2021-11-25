#------------------------------------------------------------------------------
# Deploymentserver
#------------------------------------------------------------------------------

#------------------------------------------------------------------------------
# Variables
#------------------------------------------------------------------------------

$Win10WimPath="F:\configfiles\install.wim"

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

# Maak deployment share

try {
    # controlleren of pad al bestaat
    if (Test-Path -Path 'C:\DeploymentShare') {
        # Pad bestaat
        Write-Host 'Microsoft Deployment Toolkit: Deployment share already created' -ForegroundColor Green
    } else {
        # pad bestaat niet
        New-Item -Path "C:\DeploymentShare" -ItemType directory
        New-SmbShare -Name "DeploymentShare$" -Path "C:\DeploymentShare" -FullAccess Administrators
        Import-Module "C:\Program Files\Microsoft Deployment Toolkit\bin\MicrosoftDeploymentToolkit.psd1"
        new-PSDrive -Name "DS001" -PSProvider "MDTProvider" -Root "C:\DeploymentShare" -Description "MDT Deployment Share" -NetworkPath "\\EP1-SCCM\DeploymentShare$" -Verbose | add-MDTPersistentDrive -Verbose
        Write-Host 'Microsoft Deployment Toolkit: Deployment share created' -ForegroundColor Green
    }
}
catch {
    Write-Warning -Message $("Failed to create Microsoft Deployment Toolkit: Deployment share. Error: " + $_.Exception.Message)
}

# Maak Windows 10 folder onder operating systems
try {
    if (Test-Path -Path "C:\DeploymentShare\Operating Systems\Windows 10") {
        # Pad bestaat
        Write-Host 'Folder already created' -ForegroundColor Green
    } else {
        # Pad bestaat niet
        Import-Module "C:\Program Files\Microsoft Deployment Toolkit\bin\MicrosoftDeploymentToolkit.psd1"
        New-PSDrive -Name "DS001" -PSProvider MDTProvider -Root "C:\DeploymentShare"
        new-item -path "DS001:\Operating Systems" -enable "True" -Name "Windows 10" -Comments "" -ItemType "folder" -Verbose
        new-item -path "DS001:\Operating Systems" -enable "True" -Name "Windows Server 2019" -Comments "" -ItemType "folder" -Verbose
        Write-Host 'Folder created' -ForegroundColor Green
    }
}
catch {
    Write-Warning -Message $("Failed to create a folder. Error: " + $_.Exception.Message)
}

# import Windows 10
try {
    if (Test-Path -Path $Win10WimPath) {
        # pad bestaat

        Import-Module "C:\Program Files\Microsoft Deployment Toolkit\bin\MicrosoftDeploymentToolkit.psd1"
        New-PSDrive -Name "DS001" -PSProvider MDTProvider -Root "C:\DeploymentShare"
        import-mdtoperatingsystem -path "DS001:\Operating Systems\Windows 10" -SourceFile $Win10WimPath -DestinationFolder "Windows 10 Desktop" -Verbose
        Write-Host 'Windows 10 image imported' -ForegroundColor Green
    }
}
catch {
    Write-Warning -Message $("Failed to import windows 10 image. Error: " + $_.Exception.Message)
}

# import windows server 19
try {
    Import-Module "C:\Program Files\Microsoft Deployment Toolkit\bin\MicrosoftDeploymentToolkit.psd1"
    New-PSDrive -Name "DS001" -PSProvider MDTProvider -Root "C:\DeploymentShare"
    import-mdtoperatingsystem -path "DS001:\Operating Systems\Windows Server 2019" -SourceFile "F:\configfiles\winserv19.wim" -DestinationFolder "Windows Server 2019" -Verbose

}
catch {
    
}

# aanmaken task sequence windows 10 pro

try {
    Import-Module "C:\Program Files\Microsoft Deployment Toolkit\bin\MicrosoftDeploymentToolkit.psd1"
    New-PSDrive -Name "DS001" -PSProvider MDTProvider -Root "C:\DeploymentShare"
    import-mdttasksequence -path "DS001:\Task Sequences" -Name "Windows 10 Pro Clean install" -Template "Client.xml" -Comments "" -ID "Win10ProClean" -Version "1.0" -OperatingSystemPath "DS001:\Operating Systems\Windows 10\Windows 10 Pro in Windows 10 Desktop install.wim" -FullName "Gebruiker" -OrgName "EP1-PIETER.HoGent" -HomePage "Hogent.be" -Verbose

}
catch {
    
}

# aanmaken task sequence windows Server 19

try {
    Import-Module "C:\Program Files\Microsoft Deployment Toolkit\bin\MicrosoftDeploymentToolkit.psd1"
New-PSDrive -Name "DS001" -PSProvider MDTProvider -Root "C:\DeploymentShare"
import-mdttasksequence -path "DS001:\Task Sequences" -Name "Server 19 Clean install" -Template "Client.xml" -Comments "" -ID "WinServ19Clean" -Version "1.0" -OperatingSystemPath "DS001:\Operating Systems\Windows Server 2019\Windows Server 2019 SERVERSTANDARD in Windows Server 2019 winserv19.wim" -FullName "Gebruiker" -OrgName "EP1-PIETER" -HomePage "about:blank" -Verbose

}
catch {
    
}

# update deploymentshare

try {
    Import-Module "C:\Program Files\Microsoft Deployment Toolkit\bin\MicrosoftDeploymentToolkit.psd1"
    New-PSDrive -Name "DS001" -PSProvider MDTProvider -Root "C:\DeploymentShare"
    update-MDTDeploymentShare -path "DS001:" -Force -Verbose
}
catch {
    
}

Pause