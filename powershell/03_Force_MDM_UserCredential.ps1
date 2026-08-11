# ==============================================================================
# Script: 03_Force_MDM_UserCredential.ps1
# Description:
#   Configures the local Windows MDM policy registry values required to trigger
#   Microsoft Intune automatic enrollment using Microsoft Entra user credentials.
#
# Domain: dmontech.local
#
# WARNING:
#   Run this script as Administrator.
#   Intended for troubleshooting or enforcing Intune automatic MDM enrollment
#   configuration on hybrid Microsoft Entra joined Windows endpoints.
# ==============================================================================


# ==============================================================================
# 1. Administrator Check
# ==============================================================================

$principal = New-Object Security.Principal.WindowsPrincipal(
    [Security.Principal.WindowsIdentity]::GetCurrent()
)

if (-not $principal.IsInRole(
    [Security.Principal.WindowsBuiltInRole]::Administrator
)) {
    Write-Error "This script must be run as Administrator."
    exit 1
}

Write-Host ""
Write-Host "Configuring Intune MDM User Credential enrollment..." -ForegroundColor Cyan


# ==============================================================================
# 2. Define MDM Policy Registry Path
# ==============================================================================

$MDMKey = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\CurrentVersion\MDM"

Write-Host ""
Write-Host "Checking MDM policy registry path..." -ForegroundColor Yellow

if (-not (Test-Path $MDMKey)) {

    New-Item `
        -Path $MDMKey `
        -Force |
        Out-Null

    Write-Host "MDM policy registry path created." -ForegroundColor Green
}
else {
    Write-Host "MDM policy registry path already exists." -ForegroundColor Gray
}


# ==============================================================================
# 3. Enable Automatic MDM Enrollment
# ==============================================================================

Write-Host ""
Write-Host "Enabling automatic MDM enrollment..." -ForegroundColor Yellow

New-ItemProperty `
    -Path $MDMKey `
    -Name "AutoEnrollMDM" `
    -PropertyType DWord `
    -Value 1 `
    -Force |
    Out-Null

Write-Host "AutoEnrollMDM = 1" -ForegroundColor Green


# ==============================================================================
# 4. Configure User Credential Authentication
# ==============================================================================

Write-Host ""
Write-Host "Configuring User Credential authentication..." -ForegroundColor Yellow

New-ItemProperty `
    -Path $MDMKey `
    -Name "UseAADCredentialType" `
    -PropertyType DWord `
    -Value 1 `
    -Force |
    Out-Null

Write-Host "UseAADCredentialType = 1" -ForegroundColor Green


# ==============================================================================
# 5. Validate Registry Configuration
# ==============================================================================

Write-Host ""
Write-Host "Validating MDM configuration..." -ForegroundColor Yellow

$MDMConfig = Get-ItemProperty `
    -Path $MDMKey `
    -ErrorAction Stop

$AutoEnrollMDM       = $MDMConfig.AutoEnrollMDM
$UseAADCredentialType = $MDMConfig.UseAADCredentialType

Write-Host ""
Write-Host "Current MDM configuration:" -ForegroundColor Cyan
Write-Host "----------------------------------------"
Write-Host "AutoEnrollMDM        : $AutoEnrollMDM"
Write-Host "UseAADCredentialType : $UseAADCredentialType"
Write-Host "----------------------------------------"


# ==============================================================================
# 6. Configuration Validation
# ==============================================================================

if (
    $AutoEnrollMDM -eq 1 -and
    $UseAADCredentialType -eq 1
) {
    Write-Host ""
    Write-Host "MDM User Credential policy configured successfully." -ForegroundColor Green
}
else {
    Write-Host ""
    Write-Warning "MDM policy values do not match the expected configuration."
    exit 1
}


# ==============================================================================
# 7. Refresh Group Policy
# ==============================================================================

Write-Host ""
Write-Host "Refreshing Group Policy..." -ForegroundColor Yellow

gpupdate /force


# ==============================================================================
# 8. Completion
# ==============================================================================

Write-Host ""
Write-Host "Intune automatic enrollment configuration completed." -ForegroundColor Green
Write-Host "Expected configuration:" -ForegroundColor Cyan
Write-Host "  AutoEnrollMDM        = 1"
Write-Host "  UseAADCredentialType = 1"
Write-Host ""
Write-Host "Sign in with the synchronized Entra ID user and verify the device enrollment state." -ForegroundColor Cyan