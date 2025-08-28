#Adrien Hafner
#This script is designed to assist with confirming WinRM connectivity between an orchestration server and other servers in the deployment before attempting a PowerShellDSC install.  The script can also assist with troubleshooting if you feel there may be an issue with connecting from an orchestration or deployment server to remote servers in the environment. 
#If successful, this script should allow you to enter a PowerShell session on the remote computer specified.
#change the "Server1","Server2", Server3" text with your machine names


# List of servers
$servers = @("Server1", "Server2", "Server3")

# Loop through each server
foreach ($server in $servers) {
    try {
        # Enter the PSSession
        Enter-PSSession -ComputerName $server -ErrorAction Stop

        # Do any necessary tasks in the session here if needed (Optional)
        Write-Host "Entered session for $server"

    } catch {
        # Handle any errors if the connection fails
        Write-Host "Failed to connect to $server. Error: $_"
    } finally {
        # Exit the session
        Exit-PSSession
        Write-Host "Exited session for $server"
    }
}




#Copyright 2025 Esri

#Licensed under the Apache License Version 2.0 (the "License"); you may not use this file except in compliance with the License.
#You may obtain a copy of the License at
#
#    http://www.apache.org/licenses/LICENSE-2.0
#
#Unless required by applicable law or agreed to in writing, software distributed under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the License for the specific language governing permissions and limitations under the License.