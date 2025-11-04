#Copyright 2025 Esri

#Licensed under the Apache License Version 2.0 (the "License"); you may not use this file except in compliance with the License.
#You may obtain a copy of the License at
#
#    http://www.apache.org/licenses/LICENSE-2.0
#
#Unless required by applicable law or agreed to in writing, software distributed under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the License for the specific language governing permissions and limitations under the License.


# This script removes an entry from the hosts file on multiple remote machines
 
# Define the host entry details to remove
$ipAddress = "10.1.1.1" # IP address currently mapped in the hosts file
$desiredIpAddress = "10.2.2.2" # The desired IP address you want the DNS name to resolve to after removal
$machineName = "machine.domain.com" # Name of the machine whose IP address is being mapped
$dnsName = "gis.website.gov" # DNS name to map to the IP address
 
# List of target machine names/IP addresses
$targetMachines = @("machine1", "machine2", "machine3")

# Get the local machine name
$localMachine = $env:COMPUTERNAME

# Function to remove entry from the hosts file
function Remove-HostEntry {
    param (
        [string]$hostsPath,
        [string]$ipAddress,
        [string]$machineName,
        [string]$dnsName
    )
    
    # Read the content of the hosts file
    $hostsContent = Get-Content $hostsPath

    # Filter the content to remove the entry, if it exists
    $newHostsContent = $hostsContent | Where-Object { $_ -notmatch "$ipAddress\s+$machineName\s+$dnsName" }

    # Check if any change is made
    if ($hostsContent.Count -ne $newHostsContent.Count) {
        # Write the updated content back to the hosts file
        $newHostsContent | Set-Content $hostsPath
        Write-Host "Entry for $dnsName and $machineName removed from $localMachine." -ForegroundColor Cyan
    } else {
        Write-Host "Entry for $dnsName and $machineName does not exist in $localMachine." -ForegroundColor Yellow
    }
}

# Loop through each target machine
foreach ($machine in $targetMachines) {
    if ($machine -eq $localMachine) {
        # If the target machine is the local machine, modify the hosts file directly
        $hostsPath = "C:\Windows\System32\drivers\etc\hosts"
        Remove-HostEntry -hostsPath $hostsPath -ipAddress $ipAddress -machineName $machineName -dnsName $dnsName

        # Verify if the DNS now resolves to the desired IP address locally
        $resolvedIp = [System.Net.Dns]::GetHostAddresses($dnsName) | Select-Object -First 1
        if ($resolvedIp.IPAddressToString -eq $desiredIpAddress) {
            Write-Host "DNS resolution for $dnsName on $localMachine is correctly set to the desired IP: $desiredIpAddress." -ForegroundColor Green
        } else {
            Write-Host "DNS resolution for $dnsName on $localMachine is NOT the desired IP. It currently resolves to: $resolvedIp." -ForegroundColor Red
        }
    } else {
        # Use Invoke-Command for remote execution on other machines
        Invoke-Command -ComputerName $machine -ScriptBlock {
            param($ipAddress, $dnsName, $machineName, $desiredIpAddress)
            
            # Path to the hosts file
            $hostsPath = "C:\Windows\System32\drivers\etc\hosts"
            
            # Read the content of the hosts file
            $hostsContent = Get-Content $hostsPath

            # Filter the content to remove the entry, if it exists
            $newHostsContent = $hostsContent | Where-Object { $_ -notmatch "$ipAddress\s+$machineName\s+$dnsName" }

            # Check if any change is made
            if ($hostsContent.Count -ne $newHostsContent.Count) {
                # Write the updated content back to the hosts file
                $newHostsContent | Set-Content $hostsPath
                Write-Host "Entry for $dnsName and $machineName removed from $env:COMPUTERNAME." -ForegroundColor Cyan
            } else {
                Write-Host "Entry for $dnsName and $machineName does not exist in $env:COMPUTERNAME." -ForegroundColor Yellow
            }

            # Verify if the DNS now resolves to the desired IP address
            $resolvedIp = [System.Net.Dns]::GetHostAddresses($dnsName) | Select-Object -First 1
            if ($resolvedIp.IPAddressToString -eq $desiredIpAddress) {
                Write-Host "DNS resolution for $dnsName on $env:COMPUTERNAME is correctly set to the desired IP: $desiredIpAddress." -ForegroundColor Green
            } else {
                Write-Host "DNS resolution for $dnsName on $env:COMPUTERNAME is NOT the desired IP. It currently resolves to: $resolvedIp." -ForegroundColor Red
            }
        } -ArgumentList $ipAddress, $dnsName, $machineName, $desiredIpAddress
    }
}






