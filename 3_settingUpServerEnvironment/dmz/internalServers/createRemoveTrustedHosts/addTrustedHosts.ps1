#Copyright 2025 Esri

#Licensed under the Apache License Version 2.0 (the "License"); you may not use this file except in compliance with the License.
#You may obtain a copy of the License at
#
#    http://www.apache.org/licenses/LICENSE-2.0
#
#Unless required by applicable law or agreed to in writing, software distributed under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the License for the specific language governing permissions and limitations under the License.


# List of target machines
$computers = @("Machine1", "Machine2", "Machine3")

# Trusted hosts array
$trustedHosts = @(
    "192.168.1.1",  # Replace with your IP addresses
    "192.168.1.2",
    "hostname1.domain.com",  # Replace with your hostnames
    "hostname2.domain.com"
)

# Convert the array to a comma-separated string
$trustedHostsString = $trustedHosts -join ','

# Script block to execute on each machine
$scriptBlock = {
    param($trustedHostsString)
    $input = "@{TrustedHosts=`"$trustedHostsString`"}"
    try {
        winrm set winrm/config/client $input
        Write-Host "TrustedHosts set to: $trustedHostsString"
    } catch {
        Write-Host "An error occurred: $_"
    }

    # Output the current winrm/config/client configuration
    $currentConfig = winrm get winrm/config/client
    Write-Host "Current winrm/config/client configuration:"
    $currentConfig | ForEach-Object { Write-Host $_ }
}

# Execute the script block on each target machine
foreach ($computer in $computers) {
    Invoke-Command -ComputerName $computer -ScriptBlock $scriptBlock -ArgumentList $trustedHostsString
}





