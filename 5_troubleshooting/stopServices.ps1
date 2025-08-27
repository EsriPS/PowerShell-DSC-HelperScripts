#Adrien Hafner
#This script can be used in instances where you may wish to stop a running Windows Service for either troubleshooting or environment preparation (setting hosts file entries, etc)
#Replace the 'server1' text and the 'W3SVC' text to represent the server name and the service name you'd like to target


$targetServer = 'server1'
#service option suggestions include: "ArcGIS Server", "Portal for ArcGIS", "ArcGIS Data Store" and "W3SVC" (IIS)
$serviceName = 'W3SVC'
$service = Get-Service -Name $serviceName -Computer $targetServer


Write-Host "Connecting to $targetServer";
Write-Host "Stopping $serviceName service";
Stop-Service -inputObject $service; 
Start-Sleep -seconds 20;
$service.Refresh()
   if ($service.Status -eq 'Stopped')
      {
         Write-Host "$serviceName service has been stopped"
      }
Write-Host "Disconnected from $targetServer";

