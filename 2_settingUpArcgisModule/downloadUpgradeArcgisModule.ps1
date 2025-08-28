# Brendan Bladdick

# connects to each machine in the arcgisservers array and removes the old ArcGIS module from the machine then installs the new module

# change the machine1, machine2 with your machines

$arcgisservers = ("machine1","machine2")

# Start a new job for each server
$jobs = $arcgisservers | ForEach-Object {
    $server = $_
    Start-Job -ScriptBlock {
        param($server)
        Write-Host "Connecting to $server"
        $session = New-PSSession -ComputerName $server
        Invoke-Command -Session $session -ScriptBlock {
            Remove-Item -Path "C:\Program Files\WindowsPowerShell\Modules\ArcGIS" -Recurse -Force -ErrorAction SilentlyContinue
            # Set the security protocol to TLS 1.2
            [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
            # Install NuGet provider
            Install-PackageProvider -Name NuGet -MinimumVersion 2.8.5.201 -Force
            #install new module to this machine
            Install-Module ArcGIS -Force
        }
    } -ArgumentList $server
}

# Wait for all jobs to complete
$jobs | Wait-Job

# Get the results of the jobs and print them
$jobs | Receive-Job | ForEach-Object { Write-Host $_ }

# Clean up the jobs
$jobs | Remove-Job





#Copyright 2025 Esri

#Licensed under the Apache License Version 2.0 (the "License"); you may not use this file except in compliance with the License.
#You may obtain a copy of the License at
#
#    http://www.apache.org/licenses/LICENSE-2.0
#
#Unless required by applicable law or agreed to in writing, software distributed under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the License for the specific language governing permissions and limitations under the License.