# Get Computer System
$CS = Get-WmiObject Win32_ComputerSystem

# Get OperatingSystem
$OS = Get-WmiObject Win32_OperatingSystem

# Get-Cluster
$Cluster = Get-Cluster
# Get-ClusterNode
$ClusterNodes = Get-ClusterNode

# Get-ClusterStorageSpacesDirect
$S2D = Get-ClusterStorageSpacesDirect

# Get-VirtualDisk
$VirtualDisks = Get-VirtualDisk

# Physical Disks
$PhysicalDisks = Get-PhysicalDisk

# Get-StorageJob
$StorageJobs = Get-StorageJob

# Determine health statuses
$NodesHealthy = ($ClusterNodes | Where-Object { $_.State -ne 'Up' }).Count -eq 0
$VirtualDisksHealthy = ($VirtualDisks | Where-Object { $_.OperationalStatus -ne 'OK' }).Count -eq 0
$PhysicalDisksHealthy = ($PhysicalDisks | Where-Object { $_.OperationalStatus -ne 'OK' }).Count -eq 0
$S2DHealthy = $S2D -and $S2D.State -eq 'Enabled'

# Create custom object
$HealthObject = [PSCustomObject]@{
    ClusterName = $Cluster.Name
    Nodes = if ($NodesHealthy) { 'Healthy' } else { 'Unhealthy' }
    VirtualDisk = if ($VirtualDisksHealthy) { 'Healthy' } else { 'Unhealthy' }
    PhysicalDisk = if ($PhysicalDisksHealthy) { 'Healthy' } else { 'Unhealthy' }
    StorageSpacesDirect = if ($S2DHealthy) { 'Healthy' } else { 'Unhealthy' }
}

# Output as JSON
$HealthObject | ConvertTo-Json