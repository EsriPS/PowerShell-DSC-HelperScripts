#Copyright 2025 Esri

#Licensed under the Apache License Version 2.0 (the "License"); you may not use this file except in compliance with the License.
#You may obtain a copy of the License at
#
#    http://www.apache.org/licenses/LICENSE-2.0
#
#Unless required by applicable law or agreed to in writing, software distributed under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the License for the specific language governing permissions and limitations under the License.


#Adrien Hafner
#This script can be used for troubleshooting an issue with your deployment and simply restarts the server specified, remotely
#The script first forces a restart and then waits for the reboot and for PowerShell to be available post-restart
#Replace the 'server1', 'server2', etc text with the machines you'd like to restart



$servers = @('server1','server2','server3')

foreach ($server in $servers) {
    Write-Host "Connecting to $server";
    Restart-Computer -ComputerName $server -Force -Wait -For PowerShell -Timeout 300 -Delay 10;
    Write-Host 'The machine has been restarted and PowerShell is available';
    Write-Host "Disconnected from $server";
}







