#Adrien Hafner
#This script checks to see if there is a hung Windows Installer process running on the server specified.
#If a Windows Installer process is found running, the script kills it to help prepare for the next invoke attempt after failure.
#Replace the value of the serverName variable with the machine you'd like to check/kill Windows Installer on.

$serverName = "server1"

# Establish remote session
Enter-PSSession -ComputerName $serverName 


# Check if process is running
Invoke-Command -ComputerName $serverName -ScriptBlock {
$processName = "msiserver"
if (Get-Service -Name $processName -ErrorAction SilentlyContinue) {
    Write-Output "$processName is running. Attempting to stop..."
    # Stop the process
    Stop-Service -Name $processName -Force
    Write-Output "$processName stopped."
} else {
    Write-Output "$processName is not running."
}

# Exit remote session
Exit-PSSession
}
