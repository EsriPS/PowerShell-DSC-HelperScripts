# List of target machines
$computers = @("Machine1", "Machine2", "Machine3")

# Define the list of folders to exclude
$foldersToExclude = @(
    "E:\ArcGIS",
    "E:\arcgisportal",
    "E:\arcgisserver",
    "E:\arcgisdatastore",
    "E:\Automation"
)

# Script block to execute on each machine
$scriptBlock = {
    param($foldersToExclude)
    $serverName = $env:COMPUTERNAME
    Write-Host "Starting to exclude folders from Windows Defender on $serverName"
    foreach ($folder in $foldersToExclude) {
        Add-MpPreference -ExclusionPath $folder
        Write-Host "Excluded $folder on $serverName"
    }
    Write-Host "Completed excluding folders from Windows Defender on $serverName"
}

# Execute the script block on each target machine
foreach ($computer in $computers) {
    Invoke-Command -ComputerName $computer -ScriptBlock $scriptBlock -ArgumentList $foldersToExclude
}






#Copyright 2025 Esri

#Licensed under the Apache License Version 2.0 (the "License"); you may not use this file except in compliance with the License.
#You may obtain a copy of the License at
#
#    http://www.apache.org/licenses/LICENSE-2.0
#
#Unless required by applicable law or agreed to in writing, software distributed under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the License for the specific language governing permissions and limitations under the License.