#Adrien Hafner
#This script can be used for troubleshooting an issue with your deployment and simply restarts the Windows service specified on the machine specified, remotely
#The script first gets the status of the service and writes it to the console, and then restarts the service, and provides the status after restart
#Replace the 'server1' text and the 'W3SVC' text to represent the server name and the service name you'd like to target

$targetServer = 'server1'
#service option suggestions include: "ArcGIS Server", "Portal for ArcGIS", "ArcGIS Data Store" and "W3SVC" (IIS)
$serviceName = 'W3SVC'
$service = Get-Service -Name $serviceName -Computer $targetServer

Write-Host "Connecting to $targetServer";
Write-Host "Checking $serviceName service status";
Write-Host $service.Status;
Write-Host "Restarting $serviceName service";
Restart-Service -InputObject $service;
Start-Sleep -Seconds 20;
Write-Host $service.Status;
Write-Host "Disconnected from $targetServer";