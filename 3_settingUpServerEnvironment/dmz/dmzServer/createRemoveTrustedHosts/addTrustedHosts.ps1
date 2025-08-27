# Creates a comma-separated string of IP addresses and hostnames and sets the TrustedHosts configuration setting for WinRM.

# Variables
$trustedHosts = @(
    "192.168.1.1",  # Replace with your IP addresses
    "192.168.1.2",
    "hostname1.domain.com",  # Replace with your hostnames
    "hostname2.domain.com"
)

# Convert the array to a comma-separated string
$trustedHostsString = $trustedHosts -join ','

# Prepare the input in the required format
$input = "@{TrustedHosts=`"$trustedHostsString`"}"

# Set TrustedHosts
try {
    winrm set winrm/config/client $input
    Write-Host "TrustedHosts set to: $trustedHostsString"
} catch {
    Write-Host "An error occurred: $_"
}

# Output the current winrm/config/client configuration
$currentConfig = winrm get winrm/config/client
Write-Host "Current winrm/config/client configuration:"
$currentConfig | ForEach-Object { Write-Host $_ }
