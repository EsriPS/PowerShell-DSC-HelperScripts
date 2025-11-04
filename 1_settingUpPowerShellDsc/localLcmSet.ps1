#Copyright 2025 Esri

#Licensed under the Apache License Version 2.0 (the "License"); you may not use this file except in compliance with the License.
#You may obtain a copy of the License at
#
#    http://www.apache.org/licenses/LICENSE-2.0
#
#Unless required by applicable law or agreed to in writing, software distributed under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the License for the specific language governing permissions and limitations under the License.


# Brendan Bladdick

# This script sets the Local DSC configuration to Stop on Restart and to ApplyOnly so logs don't pile up

#change the machine1, machine2 with your machines
#if only one machine in deployment then can simply run the contents of the invoke command
$arcgisservers = @('machine1','machine2')

foreach ($server in $arcgisservers) {
    Write-Host "Connecting to $server";
    $session = New-PSSession -ComputerName $server;
    Invoke-Command -Session $session -ScriptBlock {
        Write-Host 'Setting Local DSC Configuration Manager to ApplyOnly and Stop Configuration';
        Set-Location C:\Windows\System32;
        [DSCLocalConfigurationManager()]
        configuration LCMConfig {
            Node localhost {
                Settings {
                    ConfigurationMode='ApplyOnly'
                    ActionAfterReboot = 'StopConfiguration'
                }
            }
        }
        LCMConfig;
        Set-DscLocalConfigurationManager -Path 'C:\Windows\System32\LCMConfig' -Force;
        Write-Host 'Local DSC Configuration Manager is now set to ApplyOnly';
    }
    Write-Host "Disconnected from $server";
    Remove-PSSession $session;
}





