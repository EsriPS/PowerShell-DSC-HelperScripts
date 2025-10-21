# Brendan Bladdick and Adrien Hafner

# this script is designed to transfer downloaded Esri patches to all the machines in the $remoteServers block from the $localServer orchestration machine, and at the end of the script, it will report the contents of the folder on your remote servers so you can confirm the patches have been transferred.

# change the $localServer and $remoteServers lists to reflect your machines

# change the $localDrive, $remoteDrive, $mainDirectory and $subDirectory to match your environment

# Define the local and remote servers
$localServer = @('localserver')   # The machine running the script
$remoteServers = @('remoteserver1','remoteserver2') # Remote targets

# Drive letter and file path setup
$localDrive = "C:" # Define the drive letter as a variable (no trailing slash or $)
$remoteDrive = "D:" # Define the drive letter as a variable (no trailing slash or $)
$mainDirectory = "Automation"  # Change this to the directory that contains the folder that contains the patches folder
$subDirectory = "patches\Portal" # Change this to the directory that contains the individual patches for each component

# Source path on local machine
$sourcePath = Join-Path -Path $localDrive -ChildPath "$mainDirectory\$subDirectory\*"

# Loop through all target servers
foreach ($server in $localServer + $remoteServers) {
    $serverTrimmed = $server.Trim()

    if ($localServer -contains $serverTrimmed) {
        Write-Host "Skipping local server to avoid accidental overwrite: $serverTrimmed"
        continue
    }

    $driveShare = "$($remoteDrive.TrimEnd(':'))$"
    $targetDir = "\\$serverTrimmed\$driveShare\$mainDirectory\$subDirectory"

    try {
        # Ensure destination exists
        if (-not (Test-Path -Path $targetDir)) {
            Write-Host "Creating remote directory: ${targetDir}"
            New-Item -ItemType Directory -Path $targetDir -Force
        } else {
            Write-Host "Clearing existing contents in: ${targetDir}"
            Remove-Item "${targetDir}\*" -Recurse -Force
        }

        # Copy from local to remote
        Write-Host "Copying from ${sourcePath} to ${targetDir}"
        Copy-Item -Path $sourcePath -Destination $targetDir -Recurse -Force

        Write-Host "Files now at ${targetDir}:"
        Get-ChildItem -Path $targetDir -Recurse | ForEach-Object { Write-Host $_.FullName }

    } catch {
        Write-Error "Failed on ${serverTrimmed}: $_"
    }
}






#Copyright 2025 Esri

#Licensed under the Apache License Version 2.0 (the "License"); you may not use this file except in compliance with the License.
#You may obtain a copy of the License at
#
#    http://www.apache.org/licenses/LICENSE-2.0
#
#Unless required by applicable law or agreed to in writing, software distributed under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the License for the specific language governing permissions and limitations under the License.