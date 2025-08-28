# This script sets the firewall rules on the specified machines to allow inbound traffic on the specified ports.

# Define the list of machines to set the firewall rules on
$machines = @('machine1', 'machine2', 'machine3')

# Define the ports
$ports = 80, 135, 443, 445, 2443, 5985, 5986, 6080, 6443, 7080, 7443, 9320, 9220, 9829, 20443, 20301, 21443, 29080, 29081, 29878, 29879, 45672, 45671

# Convert the ports array to a comma-separated string
$portsString = $ports -join ','

# Define the name and description of the rule
$ruleName = "Allow Inbound ArcGIS Enterprise, Automation and File Share traffic"
$ruleDescription = "Allows inbound traffic on ports: $portsString"

# Define the script block to be executed on each machine
$scriptBlock = {
    param($ports, $ruleName, $ruleDescription)

    # Create the firewall rule for the Domain profile
    New-NetFirewallRule -DisplayName $ruleName -Description $ruleDescription -Direction Inbound -Action Allow -Protocol TCP -LocalPort $ports -Profile Domain, Private

    Write-Output "Firewall rules created successfully for Domain and Private profiles on $env:COMPUTERNAME."
}

# Iterate through each machine and execute the script block
foreach ($machine in $machines) {
    Invoke-Command -ComputerName $machine -ScriptBlock $scriptBlock -ArgumentList $ports, $ruleName, $ruleDescription
}






#Copyright 2025 Esri

#Licensed under the Apache License Version 2.0 (the "License"); you may not use this file except in compliance with the License.
#You may obtain a copy of the License at
#
#    http://www.apache.org/licenses/LICENSE-2.0
#
#Unless required by applicable law or agreed to in writing, software distributed under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the License for the specific language governing permissions and limitations under the License.
