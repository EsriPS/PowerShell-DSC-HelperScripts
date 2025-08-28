#Adrien Hafner
#This script can be used in instances where you may wish to stop a running Windows Service for either troubleshooting or environment preparation (setting hosts file entries, etc)
#Replace the 'server1' text and the 'W3SVC' text to represent the server name and the service name you'd like to target


$targetServer = 'server1'
#service option suggestions include: "ArcGIS Server", "Portal for ArcGIS", "ArcGIS Data Store" and "W3SVC" (IIS)
$serviceName = 'W3SVC'
$service = Get-Service -Name $serviceName -Computer $targetServer


Write-Host "Connecting to $targetServer";
Write-Host "Stopping $serviceName service";
Stop-Service -inputObject $service; 
Start-Sleep -seconds 20;
$service.Refresh()
   if ($service.Status -eq 'Stopped')
      {
         Write-Host "$serviceName service has been stopped"
      }
Write-Host "Disconnected from $targetServer";







#Copyright 2025 Esri

#Licensed under the Apache License Version 2.0 (the "License"); you may not use this file except in compliance with the License.
#You may obtain a copy of the License at
#
#    http://www.apache.org/licenses/LICENSE-2.0
#
#Unless required by applicable law or agreed to in writing, software distributed under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the License for the specific language governing permissions and limitations under the License.