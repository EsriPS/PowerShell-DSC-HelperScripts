# Create LocalAccountTokenFilterPolicy
# Set LocalAccountTokenFilterPolicy to 1
$regPath = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System"
$regName = "LocalAccountTokenFilterPolicy"
$regValue = 1

try {
    if (-not (Get-ItemProperty -Path $regPath -Name $regName -ErrorAction SilentlyContinue)) {
        New-ItemProperty -Path $regPath -Name $regName -PropertyType DWORD -Value $regValue -Force
        Write-Output "LocalAccountTokenFilterPolicy registry entry created and set to 1."
    } else {
        Set-ItemProperty -Path $regPath -Name $regName -Value $regValue
        Write-Output "LocalAccountTokenFilterPolicy registry entry already existed and if it was not set to 1, it was updated to 1."
    }
} catch {
    Write-Output "An error occurred: $_"
}

# Verify the setting
$setValue = Get-ItemProperty -Path $regPath -Name $regName
if ($setValue.LocalAccountTokenFilterPolicy -eq $regValue) {
    Write-Output "LocalAccountTokenFilterPolicy is successfully set to 1."
} else {
    Write-Output "Failed to set LocalAccountTokenFilterPolicy to 1."
}
