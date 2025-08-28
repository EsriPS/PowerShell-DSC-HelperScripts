# Create a local user account on a Windows machine

# Variables
$username = "dmzUser"
#$password = ConvertTo-SecureString "P@ssw0rd!" -AsPlainText -Force
$password = Read-Host "Enter password for the new user" -AsSecureString
$description = "Local user for DMZ and Non-DMZ machines"

try {
    # Create local user
    if (-not (Get-LocalUser -Name $username -ErrorAction SilentlyContinue)) {
        New-LocalUser -Name $username -Password $password -Description $description
        Write-Host "Local user $username created successfully."
    } else {
        Write-Host "Local user $username already exists."
    }

    # Add user to the Administrators group
    if (-not (Get-LocalGroupMember -Group "Administrators" -Member $username -ErrorAction SilentlyContinue)) {
        Add-LocalGroupMember -Group "Administrators" -Member $username
        Write-Host "User $username added to Administrators group."
    } else {
        Write-Host "User $username is already a member of the Administrators group."
    }
} catch {
    Write-Host "An error occurred: $_"
}





#Copyright 2025 Esri

#Licensed under the Apache License Version 2.0 (the "License"); you may not use this file except in compliance with the License.
#You may obtain a copy of the License at
#
#    http://www.apache.org/licenses/LICENSE-2.0
#
#Unless required by applicable law or agreed to in writing, software distributed under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the License for the specific language governing permissions and limitations under the License.
