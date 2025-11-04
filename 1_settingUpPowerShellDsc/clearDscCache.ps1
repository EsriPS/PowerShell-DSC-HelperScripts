#Copyright 2025 Esri

#Licensed under the Apache License Version 2.0 (the "License"); you may not use this file except in compliance with the License.
#You may obtain a copy of the License at
#
#    http://www.apache.org/licenses/LICENSE-2.0
#
#Unless required by applicable law or agreed to in writing, software distributed under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the License for the specific language governing permissions and limitations under the License.

# Brendan Bladdick

# change the machine1, machine2 with your machines
# This script sets the Local DSC configuration to Stop on Restart and to ApplyOnly so logs don't pile up and so it won't run again on restart 

$arcgisservers = @('machine1','machine2')

foreach ($server in $arcgisservers) {
    Write-Host "Connecting to $server";
    $session = New-PSSession -ComputerName $server;
    Invoke-Command -Session $session -ScriptBlock {
        Write-Host 'clearing dsc config';
        Remove-DscConfigurationDocument -Stage Current, Pending, Previous -Verbose -Force;
        Write-Host 'cleared dsc config';
    }
    Write-Host "Disconnected from $server";
    Remove-PSSession $session;
}






