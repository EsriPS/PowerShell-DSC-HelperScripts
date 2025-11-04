#Copyright 2025 Esri

#Licensed under the Apache License Version 2.0 (the "License"); you may not use this file except in compliance with the License.
#You may obtain a copy of the License at
#
#    http://www.apache.org/licenses/LICENSE-2.0
#
#Unless required by applicable law or agreed to in writing, software distributed under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the License for the specific language governing permissions and limitations under the License.


##Adrien Hafner
##This script will report on which version of the ArcGIS PowerShell DSC module is installed on each of the servers in the list you provide the script.
##This information can be helpful when determining whether or not the ArcGIS module version needs upgraded, and also indicates when there is more than one version of the module installed (this can sometimes cause issues and is not recommended).

$servers = @("Server1","Server2","Server3")

foreach ($server in $servers) {
    try {
        # Run Get-Module remotely on each server
        $modules = Invoke-Command -ComputerName $server -ScriptBlock {
            Get-Module -ListAvailable -Name 'ArcGIS'
        }
        
        # If modules are found, output the result
        if ($modules) {
            Write-Host "ArcGIS modules on ${server}:"
            $modules
        }
        else {
            Write-Host "No ArcGIS modules found on ${server}."
        }
    }
    catch {
        # If an error occurs, output the failure message
        Write-Host "Unable to get version on ${server}"
    }
}






