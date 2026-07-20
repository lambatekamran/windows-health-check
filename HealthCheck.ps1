# ==========================================
# Windows Health Check
# Version: 1.0
# Author: Kamran Lambate
# ==========================================

Clear-Host

# =====================================================
# Helper Function
# =====================================================

function Show-Section {
    param(
        [string]$Title
    )

    Write-Host ""
    Write-Host "=========================================" -ForegroundColor Cyan
    Write-Host $Title -ForegroundColor Cyan
    Write-Host "=========================================" -ForegroundColor Cyan
}

# =====================================================
# System Information
# =====================================================

function Get-SystemInformation {

    $os = Get-CimInstance Win32_OperatingSystem

    [PSCustomObject]@{
        ComputerName    = $env:COMPUTERNAME
        CurrentUser     = $env:USERNAME
        OperatingSystem = $os.Caption
        Version         = $os.Version
        Build           = $os.BuildNumber
        LastBoot        = $os.LastBootUpTime

    }

}

# =====================================================
# CPU Information
# =====================================================

function Get-CPUInformation {

    $cpu = Get-CimInstance Win32_Processor

    [PSCustomObject]@{
        Name              = $cpu.Name.Trim()
        Load              = $cpu.LoadPercentage
        Cores             = $cpu.NumberOfCores
        LogicalProcessors = $cpu.NumberOfLogicalProcessors

    }

}

# =====================================================
# Memory Information
# =====================================================

function Get-MemoryInformation {

    $os = Get-CimInstance Win32_OperatingSystem

    $total = [math]::Round($os.TotalVisibleMemorySize / 1MB, 2)
    $free = [math]::Round($os.FreePhysicalMemory / 1MB, 2)
    $used = [math]::Round($total - $free, 2)
    $usage = [math]::Round(($used / $total) * 100, 0)

    [PSCustomObject]@{

        TotalMemory = $total
        UsedMemory  = $used
        FreeMemory  = $free
        Usage       = $usage

    }

}

# =====================================================
# Disk Information
# =====================================================

function Get-DiskInformation {

    Get-CimInstance Win32_LogicalDisk -Filter "DriveType=3" | ForEach-Object {

        $total = [math]::Round($_.Size / 1GB, 2)
        $free = [math]::Round($_.FreeSpace / 1GB, 2)
        $used = [math]::Round($total - $free, 2)
        $freePercent = [math]::Round(($free / $total) * 100, 0)

        if ($freePercent -gt 20) {
            $status = "Healthy"
        }
        elseif ($freePercent -gt 10) {
            $status = "Warning"
        }
        else {
            $status = "Critical"
        }

        [PSCustomObject]@{

            Drive       = $_.DeviceID
            Label       = $_.VolumeName
            TotalGB     = $total
            UsedGB      = $used
            FreeGB      = $free
            FreePercent = $freePercent
            Status      = $status
        }

    }

}

# =====================================================
# Network Information
# =====================================================

function Get-NetworkInformation {

    $adapter = Get-NetAdapter |
    Where-Object Status -eq "Up" |
    Select-Object -First 1

    $ip = Get-NetIPAddress `
        -InterfaceIndex $adapter.InterfaceIndex `
        -AddressFamily IPv4 |
    Select-Object -First 1

    $gateway = Get-NetRoute `
        -DestinationPrefix "0.0.0.0/0" |
    Where-Object InterfaceIndex -eq $adapter.InterfaceIndex |
    Select-Object -First 1

    $dns = Get-DnsClientServerAddress `
        -InterfaceIndex $adapter.InterfaceIndex `
        -AddressFamily IPv4

    [PSCustomObject]@{

        Adapter = $adapter.Name
        IPv4    = $ip.IPAddress
        Gateway = $gateway.NextHop
        DNS     = ($dns.ServerAddresses -join ", ")
        MAC     = $adapter.MacAddress
    }

}

# =====================================================
# Internet Connectivity
# =====================================================

function Test-InternetConnection {

    if (Test-Connection -ComputerName "8.8.8.8" -Count 1 -Quiet) {
        return "Connected"
    }
    else {
        return "No Internet"
    }

}

# =====================================================
# Installed Software
# =====================================================

function Get-InstalledSoftware {

    $paths = @(
        "HKLM:\Software\Microsoft\Windows\CurrentVersion\Uninstall\*",
        "HKLM:\Software\WOW6432Node\Microsoft\Windows\CurrentVersion\Uninstall\*"
    )

    $software = foreach ($path in $paths) {

        Get-ItemProperty $path -ErrorAction SilentlyContinue |
        Where-Object { $_.DisplayName } |
        Select-Object DisplayName, DisplayVersion, Publisher

    }

    $software | Sort-Object DisplayName -Unique

}

# =====================================================
# Health Score
# =====================================================

function Get-HealthScore {

    param(
        $CPU,
        $Memory,
        $Disks,
        $Internet
    )

    $score = 0

    if ($CPU.Load -lt 80) {
        $score += 25
    }

    if ($Memory.Usage -lt 80) {
        $score += 25
    }

    if (($Disks | Where-Object { $_.Status -ne "Healthy" }).Count -eq 0) {
        $score += 25
    }

    if ($Internet -eq "Connected") {
        $score += 25
    }

    return $score

}

function Get-HealthRating {

    param($Score)

    switch ($Score) {
        { $_ -ge 90 } { "Excellent"; break }
        { $_ -ge 75 } { "Good"; break }
        { $_ -ge 60 } { "Fair"; break }
        default { "Poor" }
    }

}

# =====================================================
# Export Report
# =====================================================

function Export-HealthReport {

    param(
        [string[]]$Report
    )

    $Folder = ".\reports"
    if (!(Test-Path $Folder)) {
        New-Item -ItemType Directory -Path $Folder | Out-Null
    }

    $File = Join-Path $Folder ("HealthReport_{0}.txt" -f (Get-Date -Format "yyyy-MM-dd_HHmmss"))

    $Report | Out-File -FilePath $File -Encoding UTF8

    Write-Host ""
    Write-Host "Report saved to:"
    Write-Host $File -ForegroundColor Green

}

# =====================================================
# Main Execution
# =====================================================

$System   = Get-SystemInformation
$CPU      = Get-CPUInformation
$Memory   = Get-MemoryInformation
$Disks    = Get-DiskInformation
$Network  = Get-NetworkInformation
$Internet = Test-InternetConnection
$Software = Get-InstalledSoftware
$Score    = Get-HealthScore `
    -CPU $CPU `
    -Memory $Memory `
    -Disks $Disks `
    -Internet $Internet

$Rating = Get-HealthRating $Score

$Report = @()

$Report += "=============================================="
$Report += "        WINDOWS HEALTH CHECK REPORT"
$Report += "=============================================="
$Report += ""
$Report += "Computer Name : $($System.ComputerName)"
$Report += "Current User  : $($System.CurrentUser)"
$Report += "Operating System : $($System.OperatingSystem)"
$Report += "OS Version    : $($System.Version)"
$Report += ""

$Report += "CPU INFORMATION"
$Report += "-----------------------------"
$Report += "Processor     : $($CPU.Name)"
$Report += "CPU Usage     : $($CPU.Load)%"
$Report += "Cores         : $($CPU.Cores)"
$Report += "Logical CPU   : $($CPU.LogicalProcessors)"
$Report += ""

$Report += "MEMORY INFORMATION"
$Report += "-----------------------------"
$Report += "Total Memory  : $($Memory.TotalMemory) GB"
$Report += "Used Memory   : $($Memory.UsedMemory) GB"
$Report += "Free Memory   : $($Memory.FreeMemory) GB"
$Report += "Usage         : $($Memory.Usage)%"
$Report += ""

$Report += "DISK INFORMATION"
$Report += "-----------------------------"

foreach ($disk in $Disks) {

    $Report += "Drive         : $($disk.Drive)"
    $Report += "Label         : $($disk.Label)"
    $Report += "Total Space   : $($disk.TotalGB) GB"
    $Report += "Used Space    : $($disk.UsedGB) GB"
    $Report += "Free Space    : $($disk.FreeGB) GB"
    $Report += "Free Percent  : $($disk.FreePercent)%"
    $Report += "Status        : $($disk.Status)"
    $Report += ""

}

$Report += "NETWORK INFORMATION"
$Report += "-----------------------------"
$Report += "Adapter       : $($Network.Adapter)"
$Report += "IPv4 Address  : $($Network.IPv4)"
$Report += "Gateway       : $($Network.Gateway)"
$Report += "DNS Servers   : $($Network.DNS)"
$Report += "MAC Address   : $($Network.MAC)"
$Report += "Internet      : $Internet"
$Report += ""

$Report += "INSTALLED SOFTWARE"
$Report += "-----------------------------"

foreach ($app in $Software) {

    $Report += "{0} ({1})" -f $app.DisplayName, $app.DisplayVersion

}

$Report += ""
$Report += "Total Installed Applications : $($Software.Count)"
$Report += ""

$Report += "OVERALL HEALTH"
$Report += "-----------------------------"
$Report += "Health Score : $Score / 100"
$Report += "Status       : $Rating"

# Display report on screen
$Report | ForEach-Object { Write-Host $_ }

# Export report
Export-HealthReport -Report $Report