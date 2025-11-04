#Copyright 2025 Esri

#Licensed under the Apache License Version 2.0 (the "License"); you may not use this file except in compliance with the License.
#You may obtain a copy of the License at
#
#    http://www.apache.org/licenses/LICENSE-2.0
#
#Unless required by applicable law or agreed to in writing, software distributed under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the License for the specific language governing permissions and limitations under the License.

# Create LocalAccountTokenFilterPolicy
# Set LocalAccountTokenFilterPolicy to 1
$regPath = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System"
$regName = "LocalAccountTokenFilterPolicy"
$regValue = 1

try {
    if (-not (Get-ItemProperty -Path $regPath -Name $regName -ErrorAction SilentlyContinue)) {
        New-ItemProperty -Path $regPath -Name $regName -PropertyType DWORD -Value $regValue -Force
        Write-Output "LocalAccountTokenFilterPolicy registry entry created and set to 1."
    } else {
        Set-ItemProperty -Path $regPath -Name $regName -Value $regValue
        Write-Output "LocalAccountTokenFilterPolicy registry entry already existed and if it was not set to 1, it was updated to 1."
    }
} catch {
    Write-Output "An error occurred: $_"
}

# Verify the setting
$setValue = Get-ItemProperty -Path $regPath -Name $regName
if ($setValue.LocalAccountTokenFilterPolicy -eq $regValue) {
    Write-Output "LocalAccountTokenFilterPolicy is successfully set to 1."
} else {
    Write-Output "Failed to set LocalAccountTokenFilterPolicy to 1."
}





