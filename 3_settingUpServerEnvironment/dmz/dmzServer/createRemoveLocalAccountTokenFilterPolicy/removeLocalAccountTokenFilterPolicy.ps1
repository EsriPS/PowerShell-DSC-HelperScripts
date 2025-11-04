#Copyright 2025 Esri

#Licensed under the Apache License Version 2.0 (the "License"); you may not use this file except in compliance with the License.
#You may obtain a copy of the License at
#
#    http://www.apache.org/licenses/LICENSE-2.0
#
#Unless required by applicable law or agreed to in writing, software distributed under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the License for the specific language governing permissions and limitations under the License.

# Remove LocalAccountTokenFilterPolicy
$regPath = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System"
$regName = "LocalAccountTokenFilterPolicy"

try {
    if (Get-ItemProperty -Path $regPath -Name $regName -ErrorAction SilentlyContinue) {
        Remove-ItemProperty -Path $regPath -Name $regName -Force
        Write-Output "LocalAccountTokenFilterPolicy registry entry removed successfully."
    } else {
        Write-Output "LocalAccountTokenFilterPolicy registry entry does not exist."
    }
} catch {
    Write-Output "An error occurred: $_"
}

# Verify the removal
try {
    Get-ItemProperty -Path $regPath -Name $regName -ErrorAction Stop
    Write-Output "Failed to remove LocalAccountTokenFilterPolicy registry entry."
} catch {
    Write-Output "LocalAccountTokenFilterPolicy registry entry is confirmed as removed."
}





