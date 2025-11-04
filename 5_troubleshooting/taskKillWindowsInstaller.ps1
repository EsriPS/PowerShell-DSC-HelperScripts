#Copyright 2025 Esri

#Licensed under the Apache License Version 2.0 (the "License"); you may not use this file except in compliance with the License.
#You may obtain a copy of the License at
#
#    http://www.apache.org/licenses/LICENSE-2.0
#
#Unless required by applicable law or agreed to in writing, software distributed under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the License for the specific language governing permissions and limitations under the License.


#Adrien Hafner
#This script checks to see if there is a hung Windows Installer process running on the server specified.
#If a Windows Installer process is found running, the script kills it to help prepare for the next invoke attempt after failure.
#Replace the value of the serverName variable with the machine you'd like to check/kill Windows Installer on.

$serverName = "server1"

# Establish remote session
Enter-PSSession -ComputerName $serverName 


# Check if process is running
Invoke-Command -ComputerName $serverName -ScriptBlock {
$processName = "msiserver"
if (Get-Service -Name $processName -ErrorAction SilentlyContinue) {
    Write-Output "$processName is running. Attempting to stop..."
    # Stop the process
    Stop-Service -Name $processName -Force
    Write-Output "$processName stopped."
} else {
    Write-Output "$processName is not running."
}

# Exit remote session
Exit-PSSession
}







