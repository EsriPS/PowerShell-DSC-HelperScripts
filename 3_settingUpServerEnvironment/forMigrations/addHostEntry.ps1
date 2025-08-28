# This script adds an entry to the hosts file on multiple remote machines

# Define the host entry details to add
$ipAddress = "10.0.0.1" # IP address to map to the DNS name and machine name
$machineName = "machine1" # Name of the machine whose IP address is being mapped (FQDN)
$dnsName = "host.domain.com" # DNS name to map to the IP address

# List of target machine names to modify the hosts file
$targetMachines = @("machine1", "machine2", "machine3", "machine4")

# Loop through each target machine
foreach ($machine in $targetMachines) {
    # Use Invoke-Command for remote execution
    Invoke-Command -ComputerName $machine -ScriptBlock {
        param($ipAddress, $dnsName, $machineName)

        # Path to the hosts file
        $hostsPath = "C:\Windows\System32\drivers\etc\hosts"

        # Entry to add
        $entry = "$ipAddress`t$machineName`t$dnsName"

        # Check if the entry already exists
        $existingEntry = Get-Content $hostsPath | Select-String -Pattern "$ipAddress`t$machineName`t$dnsName"

        if (-not $existingEntry) {
            # Add the entry if it doesn't exist
            Add-Content -Path $hostsPath -Value $entry
            Write-Host "Added entry: $entry" -ForegroundColor Cyan
        } else {
            Write-Host "Entry for $dnsName already exists in $using:machine." -ForegroundColor Yellow
        }

        # Verify the DNS resolution
        $resolvedIp = [System.Net.Dns]::GetHostAddresses($dnsName) | Select-Object -First 1
        if ($resolvedIp.IPAddressToString -eq $ipAddress) {
            Write-Host "DNS resolution for $dnsName on $using:machine is correct ($resolvedIp)." -ForegroundColor Green
        } else {
            Write-Host "DNS resolution for $dnsName on $using:machine is incorrect. Expected: $ipAddress, Got: $resolvedIp" -ForegroundColor Red
        }
    } -ArgumentList $ipAddress, $dnsName, $machineName
}






#Copyright 2025 Esri

#Licensed under the Apache License Version 2.0 (the "License"); you may not use this file except in compliance with the License.
#You may obtain a copy of the License at
#
#    http://www.apache.org/licenses/LICENSE-2.0
#
#Unless required by applicable law or agreed to in writing, software distributed under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the License for the specific language governing permissions and limitations under the License.