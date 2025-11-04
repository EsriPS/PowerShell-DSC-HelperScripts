#Copyright 2025 Esri

#Licensed under the Apache License Version 2.0 (the "License"); you may not use this file except in compliance with the License.
#You may obtain a copy of the License at
#
#    http://www.apache.org/licenses/LICENSE-2.0
#
#Unless required by applicable law or agreed to in writing, software distributed under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the License for the specific language governing permissions and limitations under the License.

# This script removes a local user from the Administrators group and then deletes the user account from the local machine.

# Variables
$username = "dmzUser"

try {
    # Remove user from the Administrators group (if added)
    if (Get-LocalGroupMember -Group "Administrators" -Member $username -ErrorAction SilentlyContinue) {
        Remove-LocalGroupMember -Group "Administrators" -Member $username
        Write-Host "User $username removed from Administrators group."
    } else {
        Write-Host "User $username was not a member of the Administrators group."
    }

    # Remove the local user
    if (Get-LocalUser -Name $username -ErrorAction SilentlyContinue) {
        Remove-LocalUser -Name $username
        Write-Host "Local user $username removed successfully."
    } else {
        Write-Host "Local user $username does not exist."
    }
} catch {
    Write-Host "An error occurred: $_"
}





