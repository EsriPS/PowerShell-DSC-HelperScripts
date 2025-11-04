#Copyright 2025 Esri

#Licensed under the Apache License Version 2.0 (the "License"); you may not use this file except in compliance with the License.
#You may obtain a copy of the License at
#
#    http://www.apache.org/licenses/LICENSE-2.0
#
#Unless required by applicable law or agreed to in writing, software distributed under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the License for the specific language governing permissions and limitations under the License.


# Reset TrustedHosts to default (empty value)
try {
    winrm set winrm/config/client '@{TrustedHosts=""}'
    Write-Host "TrustedHosts has been reset to default (empty value)."
} catch {
    Write-Host "An error occurred: $_"
}

# Output the current winrm/config/client configuration
$currentConfig = winrm get winrm/config/client
Write-Host "Current winrm/config/client configuration:"
$currentConfig | ForEach-Object { Write-Host $_ }






