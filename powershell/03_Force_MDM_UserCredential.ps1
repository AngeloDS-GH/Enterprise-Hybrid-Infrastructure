# ==============================================================================
# Script: 03_Force_MDM_UserCredential.ps1
# Description: Injects local registry overrides for Intune User Credential Auto-Enrollment
# Domain: dmontech.local
# ==============================================================================

$MDMKey = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\CurrentVersion\MDM"

if (-not (Test-Path $MDMKey)) {
    New-Item -Path $MDMKey -Force | Out-Null
}

# Set AutoEnrollMDM = 1 and UseAADCredentialType = 1 (User Credential)
Set-ItemProperty -Path $MDMKey -Name "AutoEnrollMDM" -Value 1 -Type DWord
Set-ItemProperty -Path $MDMKey -Name "UseAADCredentialType" -Value 1 -Type DWord

Write-Host "MDM User Credential policies forced successfully." -ForegroundColor Green