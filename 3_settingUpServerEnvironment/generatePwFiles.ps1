# Brendan Bladdick

# Script to create password files for the accounts and certificates

# Define account types and their respective output file paths in an ordered hashtable
$accounts = [ordered]@{ # Ordered hashtable
    "AD account 'domain\svcArcGIS'" = "D:\EsriInstall\passwordFiles\ADPassword.txt"
    "MyEsri account 'temp'" = "D:\EsriInstall\passwordFiles\myesri.txt"
    "Portal account 'arcgisportal'" = "D:\EsriInstall\passwordFiles\arcgisportal.txt"
    "Server account 'arcgisadmin'" = "D:\EsriInstall\passwordFiles\arcgisadmin.txt"
    "Server 'cert' certificate" = "D:\EsriInstall\passwordFiles\cert.txt"
}

# Ensure the directory exists before creating the password files
foreach ($filePath in $accounts.Values) {
    $directory = [System.IO.Path]::GetDirectoryName($filePath)
    if (-not (Test-Path -Path $directory)) {
        New-Item -Path $directory -ItemType Directory | Out-Null
    }
}

# Iterate over each account, prompt for password, and save to file
foreach ($account in $accounts.GetEnumerator()) { # GetEnumerator() returns a collection of key-value pairs
    Write-Host "Enter the password for the $($account.Key)" # Key is the account type, Value is the file path
    $password = Read-Host -AsSecureString | ConvertFrom-SecureString # Convert to secure string and then to plain text
    $password | Out-File $account.Value # Save to file
}






#Copyright 2025 Esri

#Licensed under the Apache License Version 2.0 (the "License"); you may not use this file except in compliance with the License.
#You may obtain a copy of the License at
#
#    http://www.apache.org/licenses/LICENSE-2.0
#
#Unless required by applicable law or agreed to in writing, software distributed under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the License for the specific language governing permissions and limitations under the License.