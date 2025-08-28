##Adrien Hafner
##This script is intended to be used for migrations that make use of PowerShell DSC.  
##After content is migrated between a source and a target system, you can run this script targeting the ArcGIS Server logs to search for the string of text "Failed to create the service" to see if any services failed to migrate over.
##If entries are found in the logs with a time stamp coincident with that of the migration attempt, you should investigate the /arcgisserver/config-store/services folder to see if the service is present, and if not, manually copy it from the source.

#$remoteserver should be the FQDN of the ArcGIS Server
$remoteServer = "servername.domain.com"

#$logPath should be the root location of the ArcGIS Server log files for server
$logPath = "C:\arcgisserver\logs\MACHINE.DOMAIN.COM\server\*.log"

$searchPattern = "Failed to create the service"

Invoke-Command -ComputerName $remoteServer -ScriptBlock {
    param($logPath, $searchPattern)
    
    # Ensure the files exist before attempting to search
    if (Test-Path $logPath) {
        $results = Select-String -Path $logPath -Pattern $searchPattern
        
        if ($results) {
            $results | ForEach-Object {
                Write-Host "Found in file: $($_.Path)"
                Write-Host "Line: $($_.Line)"
            }
        } else {
            Write-Host "No matches found for '$searchPattern' in '$logPath'."
        }
    } else {
        Write-Host "Log path '$logPath' does not exist on the remote server."
    }
} -ArgumentList $logPath, $searchPattern -Credential (Get-Credential)








#Copyright 2025 Esri

#Licensed under the Apache License Version 2.0 (the "License"); you may not use this file except in compliance with the License.
#You may obtain a copy of the License at
#
#    http://www.apache.org/licenses/LICENSE-2.0
#
#Unless required by applicable law or agreed to in writing, software distributed under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the License for the specific language governing permissions and limitations under the License.
