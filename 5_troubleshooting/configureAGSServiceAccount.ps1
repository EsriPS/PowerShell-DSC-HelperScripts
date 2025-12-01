#Copyright 2025 Esri

#Licensed under the Apache License Version 2.0 (the "License"); you may not use this file except in compliance with the License.
#You may obtain a copy of the License at
#
#    http://www.apache.org/licenses/LICENSE-2.0
#
#Unless required by applicable law or agreed to in writing, software distributed under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the License for the specific language governing permissions and limitations under the License.


## Usage instructions
# Run this script in an Administrator session of PowerShell
# This script is intended to replace the functionality previously offered by the built-in Configure ArcGIS Server Account utlity that has been retired as of Enterprise 12.0.
# Use "" for the Account parameter, but not for the ConfigStorePath, DirectoriesRootPath or LogsPath parameters
<#
.SYNOPSIS
  Change a Windows service's logon account and give that account full control on three directories (config-store, directories root, logs).

.PARAMETER Account
  Account to set as service logon. Accepts DOMAIN\User, .\user, LocalSystem, NetworkService, LocalService, or just 'user' (local account implied).

.PARAMETER ConfigStorePath
  Path to Configuration Store directory to grant permissions.  Quotes around the path are not needed.

.PARAMETER DirectoriesRootPath
  Path to Root Server directory to grant permissions.  Quotes around the path are not needed.

.PARAMETER LogsPath
  Path to Logs directory to grant permissions.  Quotes around the path are not needed.

.PARAMETER Password
  (Optional) Plain password. If omitted, you will be prompted securely.

.EXAMPLE
  .\configureAGSServiceAccount.ps1 -Account "MYDOMAIN\svcaccount" -ConfigStorePath C:\arcgisserver\config-store -DirectoriesRootPath C:\arcgisserver\directories -LogsPath C:\arcgisserver\logs
#>

param(
    [Parameter(Mandatory=$true)] [string]$Account,
    [Parameter(Mandatory=$true)] [string]$ConfigStorePath,
    [Parameter(Mandatory=$true)] [string]$DirectoriesRootPath,
    [Parameter(Mandatory=$true)] [string]$LogsPath,
    [Parameter(Mandatory=$false)] [string]$Password
)

function Write-ErrAndExit {
    param($msg)
    Write-Error $msg
    exit 1
}

# Run elevated check
if (-not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltinRole] "Administrator")) {
    Write-ErrAndExit "This script must be run elevated (Run as Administrator)."
}

# Prompt for password if not provided
if (-not $Password) {
    $securePw = Read-Host -Prompt "Enter password for account $Account" -AsSecureString
    # convert SecureString to plain for service Change method; note this exposes in memory/command; consider alternative secrets store for production.
    $BSTR = [System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($securePw)
    try { $PlainPassword = [System.Runtime.InteropServices.Marshal]::PtrToStringAuto($BSTR) } finally { [System.Runtime.InteropServices.Marshal]::ZeroFreeBSTR($BSTR) }
} else {
    $PlainPassword = $Password
}

# Normalize account names for ACLs / known built-in tokens
function Normalize-AccountForAcl([string]$acct) {
    switch -Regex ($acct) {
        '^(?:LocalSystem|SYSTEM)$' { return 'NT AUTHORITY\SYSTEM' }
        '^(?:NetworkService|NETWORK SERVICE)$' { return 'NT AUTHORITY\NETWORK SERVICE' }
        '^(?:LocalService|LOCAL SERVICE)$' { return 'NT AUTHORITY\LOCAL SERVICE' }
        '^[.\\]?' { 
            # if starts with .\ or contains no backslash assume local machine
            if ($acct -match '^[.\\](.+)$') { $user = $matches[1] ; return "$env:COMPUTERNAME\$user" }
            if ($acct -notmatch '\\') { return "$env:COMPUTERNAME\$acct" }
            return $acct
        }
        default { return $acct }
    }
}

$AclAccount = Normalize-AccountForAcl $Account
Write-Host "ACL account mapped to: $AclAccount"

# Verify service exists

$ServiceName = "ArcGIS Server"

try {
    $svc = Get-CimInstance -ClassName Win32_Service -Filter "Name='$ServiceName'"
    if (-not $svc) { Write-ErrAndExit "Service '$ServiceName' not found on this machine." }
} catch {
    Write-ErrAndExit "Failed to query service '$ServiceName': $_"
}

Write-Host "Changing service '$ServiceName' logon to '$Account'..."

# Attempt to change service account via Win32_Service.Change
try {
    $res = $svc | Invoke-CimMethod -MethodName Change -Arguments @{
        DisplayName = $null;
        PathName = $null;
        ServiceType = $null;
        ErrorControl = $null;
        StartMode = $null;
        DesktopInteract = $null;
        StartName = $Account;
        StartPassword = $PlainPassword;
        LoadOrderGroup = $null;
        LoadOrderGroupDependencies = $null;
        ServiceDependencies = $null
    }
    if ($res.ReturnValue -ne 0) {
        Write-Warning "Change() returned code $($res.ReturnValue). Attempting 'sc.exe config' fallback..."
        $scArgs = "config `"$ServiceName`" obj= `"$Account`" password= `"$PlainPassword`""
        $scOutput = sc.exe $scArgs 2>&1
        Write-Host $scOutput
    } else {
        Write-Host "Service account changed successfully (Change() returned 0)."
    }
} catch {
    Write-Warning "Failed to change service account via CIM: $_. Trying 'sc.exe config' fallback..."
    try {
        $scArgs = "config `"$ServiceName`" obj= `"$Account`" password= `"$PlainPassword`""
        $scOutput = sc.exe $scArgs 2>&1
        Write-Host $scOutput
    } catch {
        Write-ErrAndExit "Failed to change service account: $_"
    }
}

# Restart service
Write-Host "Restarting service '$ServiceName'..."
try {
    Restart-Service -Name $ServiceName -Force -ErrorAction Stop
    Start-Sleep -Seconds 2
    $svc2 = Get-Service -Name $ServiceName -ErrorAction Stop
    Write-Host "Service status after restart: $($svc2.Status)"
} catch {
    Write-Warning "Service failed to start after account change: $_"
    Write-Warning "Common cause: the account does not have 'Log on as a service' rights or the password is incorrect."
    Write-Warning "You may need to grant 'Log on as a service' to $Account and then start the service (instructions printed at end)."
}

# Function to apply full control via icacls
function Grant-FullControlRecursive {
    param([string]$Path, [string]$User)
    if (-not (Test-Path $Path)) {
        Write-Warning "Path '$Path' does not exist. Creating..."
        try {
            New-Item -ItemType Directory -Path $Path -Force | Out-Null
        } catch {
            Write-Warning "Failed to create path '$Path': $_"
            return $false
        }
    }

    # Use icacls to grant (OI)(CI)F and propagate. Wrap user in quotes if contains spaces.
    $escapedUser = $User
    # icacls expects backslashes; ensure proper quoting
    $arg = "`"$Path`" /grant `"$escapedUser`":(OI)(CI)F /T /C"
    Write-Host "Applying ACL: icacls $arg"
    $p = Start-Process -FilePath icacls.exe -ArgumentList $arg -NoNewWindow -Wait -PassThru -ErrorAction SilentlyContinue
    if ($p.ExitCode -ne 0) {
        Write-Warning "icacls exited with code $($p.ExitCode). You may need to run elevated or the account name may be invalid."
        return $false
    }
    return $true
}

# Apply permissions to the three paths
$allPaths = @{
    "Configuration Store" = $ConfigStorePath;
    "Root Server Directory" = $DirectoriesRootPath;
    "Logs Directory" = $LogsPath
}

foreach ($k in $allPaths.Keys) {
    $p = $allPaths[$k]
    Write-Host "`n-- $k => $p"
    $ok = Grant-FullControlRecursive -Path $p -User $AclAccount
    if ($ok) { Write-Host "SUCCESS: Full control applied to '$p' for '$AclAccount'." } else { Write-Warning "FAILED: Could not apply ACL to '$p'." }
}

# Final messages / help for "Log on as a service"
Write-Host "`n---- Done."
if ((Get-Service -Name $ServiceName).Status -ne 'Running') {
    Write-Warning "Service '$ServiceName' is not running. Common reasons:"
    Write-Warning "  - The account/password is incorrect."
    Write-Warning "  - The account does not have 'Log on as a service' (SeServiceLogonRight)."

    Write-Host "`nTo add 'Log on as a service' for a domain or local user, you can do one of the following:"
    Write-Host "1) Use Group Policy (recommended in domain environments):"
    Write-Host "   Computer Configuration -> Windows Settings -> Security Settings -> Local Policies -> User Rights Assignment -> 'Log on as a service' (add the account)."
    Write-Host "2) On standalone servers, use a local security policy GUI: secpol.msc -> Local Policies -> User Rights Assignment -> 'Log on as a service'."
    Write-Host "3) Use an automated SeServiceLogonRight grant (advanced): export current rights, append SID, re-import via secedit.exe. (This script does not attempt that automatically.)"
    Write-Host "`nAfter granting the right, start the service:"
    Write-Host "   Start-Service -Name '$ServiceName'"
    Write-Host "`nIf you want, re-run this script with correct credentials to ensure ACLs are still set."
}

Write-Host "`nIf anything failed, re-run with -Verbose to see more details."
