# This script creates a new firewall rule to block inbound traffic from multiple IP addresses on multiple machines.

$arcgisservers = @('machine1','machine2','machine3')  # List of machines to run the script on
$blockIPs = '192.168.1.1,10.0.0.1,172.16.0.1'  # List of IP addresses to block as a comma-separated string
$environment = "Target Non-Production"  # Name of the environment to block traffic from

# Convert the comma-separated string of IPs into an array
$blockIPsArray = $blockIPs -split ','

$parameters = @{
    ComputerName = $arcgisservers
    ScriptBlock = {
        param($blockIPsArray, $environment)  # Accepts the block IPs array and environment as parameters

        # Validate each IP address
        foreach ($ip in $blockIPsArray) {
            if (-not [System.Net.IPAddress]::TryParse($ip, [ref]$null)) {
                Write-Error "Invalid IP address: $ip"
                return
            }
        }

        # Create a single firewall rule to block inbound traffic from all specified IPs
        New-NetFirewallRule -DisplayName "Block Multiple IPs from $environment" -Direction Inbound -Action Block -RemoteAddress $blockIPsArray -Profile Any
    }
    ArgumentList = ($blockIPsArray, $environment)  # Pass the $blockIPs array and $environment as arguments to the ScriptBlock
}

Invoke-Command @parameters







#Copyright 2025 Esri

#Licensed under the Apache License Version 2.0 (the "License"); you may not use this file except in compliance with the License.
#You may obtain a copy of the License at
#
#    http://www.apache.org/licenses/LICENSE-2.0
#
#Unless required by applicable law or agreed to in writing, software distributed under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the License for the specific language governing permissions and limitations under the License.

