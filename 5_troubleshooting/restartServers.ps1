#Adrien Hafner
#This script can be used for troubleshooting an issue with your deployment and simply restarts the server specified, remotely
#The script first forces a restart and then waits for the reboot and for PowerShell to be available post-restart
#Replace the 'server1', 'server2', etc text with the machines you'd like to restart



$servers = @('server1','server2','server3')

foreach ($server in $servers) {
    Write-Host "Connecting to $server";
    Restart-Computer -ComputerName $server -Force -Wait -For PowerShell -Timeout 300 -Delay 10;
    Write-Host 'The machine has been restarted and PowerShell is available';
    Write-Host "Disconnected from $server";
}