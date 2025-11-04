#Copyright 2025 Esri

#Licensed under the Apache License Version 2.0 (the "License"); you may not use this file except in compliance with the License.
#You may obtain a copy of the License at
#
#    http://www.apache.org/licenses/LICENSE-2.0
#
#Unless required by applicable law or agreed to in writing, software distributed under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the License for the specific language governing permissions and limitations under the License.


# Brendan Bladdick

# Invoking ArcGIS Configuration Script
# Set Path to easily access logs (the location you run the Invoke from will be where the Logs show up)

Set-Location -Path "E:\Logs"

Invoke-ArcGISConfiguration -ConfigurationParametersFile "D:\EsriInstall\DSC\BaseEnterpriseDeployment.json" -Mode InstallLicenseConfigure -DebugSwitch

# if successful, run without -DebugSwitch to turn off Debug Mode on ArcGIS Components
# Invoke-ArcGISConfiguration -ConfigurationParametersFile "D:\EsriInstall\DSC\BaseEnterpriseDeployment.json" -Mode InstallLicenseConfigure







