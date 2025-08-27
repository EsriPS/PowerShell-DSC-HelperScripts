# Reset TrustedHosts to default (empty value)
try {
    winrm set winrm/config/client '@{TrustedHosts=""}'
    Write-Host "TrustedHosts has been reset to default (empty value)."
} catch {
    Write-Host "An error occurred: $_"
}

# Output the current winrm/config/client configuration
$currentConfig = winrm get winrm/config/client
Write-Host "Current winrm/config/client configuration:"
$currentConfig | ForEach-Object { Write-Host $_ }
