# Remove LocalAccountTokenFilterPolicy
$regPath = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System"
$regName = "LocalAccountTokenFilterPolicy"

try {
    if (Get-ItemProperty -Path $regPath -Name $regName -ErrorAction SilentlyContinue) {
        Remove-ItemProperty -Path $regPath -Name $regName -Force
        Write-Output "LocalAccountTokenFilterPolicy registry entry removed successfully."
    } else {
        Write-Output "LocalAccountTokenFilterPolicy registry entry does not exist."
    }
} catch {
    Write-Output "An error occurred: $_"
}

# Verify the removal
try {
    Get-ItemProperty -Path $regPath -Name $regName -ErrorAction Stop
    Write-Output "Failed to remove LocalAccountTokenFilterPolicy registry entry."
} catch {
    Write-Output "LocalAccountTokenFilterPolicy registry entry is confirmed as removed."
}
