# This script removes a local user from the Administrators group and then deletes the user account from the local machine.

# Variables
$username = "dmzUser"

try {
    # Remove user from the Administrators group (if added)
    if (Get-LocalGroupMember -Group "Administrators" -Member $username -ErrorAction SilentlyContinue) {
        Remove-LocalGroupMember -Group "Administrators" -Member $username
        Write-Host "User $username removed from Administrators group."
    } else {
        Write-Host "User $username was not a member of the Administrators group."
    }

    # Remove the local user
    if (Get-LocalUser -Name $username -ErrorAction SilentlyContinue) {
        Remove-LocalUser -Name $username
        Write-Host "Local user $username removed successfully."
    } else {
        Write-Host "Local user $username does not exist."
    }
} catch {
    Write-Host "An error occurred: $_"
}
