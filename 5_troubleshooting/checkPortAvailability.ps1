#Copyright 2025 Esri

#Licensed under the Apache License Version 2.0 (the "License"); you may not use this file except in compliance with the License.
#You may obtain a copy of the License at
#
#    http://www.apache.org/licenses/LICENSE-2.0
#
#Unless required by applicable law or agreed to in writing, software distributed under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the License for the specific language governing permissions and limitations under the License.


#Adrien Hafner
#This script was built for testing port connectivity and availability during the preliminary stages of a deployment when you may not have yet installed the Esri applications that would be listening on their specific ports, but you still need to determine if the ports are open or if they're being blocked by a firewall.
#The script first translates an fqdn to its IP address so it can be used by nmap, and also as a test of resolvability
#The script then checks to see if nmap is installed, and if not, downloads and installs it.
#The script then has nmap run a scan for the specified fqdn's IP and port, and returns the resulting state and the nmap-defined interpretation of that state to the console
#A state value of "CLOSED" is common or expected if this script is run against one of the ArcGIS Enterprise component ports before the software is installed.
#A state value of "FILTERED" is more telling and suggests that there may be a firewall or other filter blocking the traffic

#Change the $targetFQDN and $targetPort values before running

# ========================
# Configurable Variables
# ========================
$targetFQDN   = "server.domain.com"       # <-- Replace with your FQDN
$targetPort   = 12345               # <-- Replace with your port

# ========================
# nmap download and install variables
# ========================

$nmapInstaller = "$env:TEMP\nmap-setup.exe"
$nmapOutputFile = "$env:TEMP\nmap_output.txt"
$nmapUrl      = "https://nmap.org/dist/nmap-7.94-setup.exe"

# ========================
# Resolve FQDN to IP
# ========================
Write-Host "Resolving $targetFQDN..."
try {
    $ipAddress = [System.Net.Dns]::GetHostAddresses($targetFQDN) | Where-Object { $_.AddressFamily -eq 'InterNetwork' } | Select-Object -First 1
    if (-not $ipAddress) {
        throw "No IPv4 address found for $targetFQDN"
    }
    Write-Host "Resolved $targetFQDN to IP: $ipAddress"
} catch {
    Write-Error "Failed to resolve `${targetFQDN}`: $_"
    exit 1
}

# ========================
# Check if Nmap is already installed
# ========================
Write-Host "Checking if Nmap is already installed..."

$nmapPath = "C:\Program Files (x86)\Nmap\nmap.exe"

if (Test-Path $nmapPath) {
    Write-Host "Nmap is already installed at: $nmapPath"
} else {
    Write-Host "Nmap not found. Installing Nmap..."
    # Download and install Nmap
    Invoke-WebRequest -Uri $nmapUrl -OutFile $nmapInstaller
    Write-Host "Installing Nmap silently..."
    Start-Process -FilePath $nmapInstaller -ArgumentList "/S" -Wait
}

# ========================
# Run Nmap Scan and Save Output to File
# ========================
Write-Host "Running Nmap scan on $ipAddress port $targetPort..."
& $nmapPath -p $targetPort $ipAddress.IPAddressToString | Out-File -FilePath $nmapOutputFile

# ========================
# Parse Nmap Output and Check Port State
# ========================
Write-Host "Parsing Nmap scan results..."

$scanResult = Get-Content -Path $nmapOutputFile

# Check for "open" state in the output
if ($scanResult -match "open") {
    Write-Host "Port $targetPort is OPEN on $targetFQDN. A service is actively listening."
} 
# Check for "closed" state in the output
elseif ($scanResult -match "closed") {
    Write-Host "Port $targetPort is CLOSED on $targetFQDN. No service is running on this port."
} 
# Check for "filtered" state in the output
elseif ($scanResult -match "filtered") {
    Write-Host "Port $targetPort is FILTERED on $targetFQDN. The scan was blocked by a firewall or filter."
} 
# Check for "open|filtered" state in the output (especially for UDP)
elseif ($scanResult -match "open|filtered") {
    Write-Host "Port $targetPort is OPEN or FILTERED on $targetFQDN. No response received, or it might be blocked by a firewall."
}
else {
    Write-Host "Could not determine the state of port $targetPort on $targetFQDN."
}

# Clean up the temporary Nmap output file
Remove-Item -Path $nmapOutputFile -Force







