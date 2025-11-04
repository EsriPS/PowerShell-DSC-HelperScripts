#Copyright 2025 Esri

#Licensed under the Apache License Version 2.0 (the "License"); you may not use this file except in compliance with the License.
#You may obtain a copy of the License at
#
#    http://www.apache.org/licenses/LICENSE-2.0
#
#Unless required by applicable law or agreed to in writing, software distributed under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the License for the specific language governing permissions and limitations under the License.


#Adrien Hafner
#This script can be used for troubleshooting an issue with your deployment and simply restarts the Windows service specified on the machine specified, remotely
#The script first gets the status of the service and writes it to the console, and then restarts the service, and provides the status after restart
#Replace the 'server1' text and the 'W3SVC' text to represent the server name and the service name you'd like to target

$targetServer = 'server1'
#service option suggestions include: "ArcGIS Server", "Portal for ArcGIS", "ArcGIS Data Store" and "W3SVC" (IIS)
$serviceName = 'W3SVC'
$service = Get-Service -Name $serviceName -Computer $targetServer

Write-Host "Connecting to $targetServer";
Write-Host "Checking $serviceName service status";
Write-Host $service.Status;
Write-Host "Restarting $serviceName service";
Restart-Service -InputObject $service;
Start-Sleep -Seconds 20;
Write-Host $service.Status;
Write-Host "Disconnected from $targetServer";








