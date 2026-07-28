# ==============================================================================
# Script: 02_Cleanup_Intune_Enrollment.ps1
# Description: Clears orphaned MDM enrollment registry keys and scheduled tasks
# Domain: dmontech.local
# ==============================================================================

# 1. Unregister lingering EnterpriseMgmt scheduled tasks
Get-ScheduledTask -TaskPath "\Microsoft\Windows\EnterpriseMgmt\*" | Unregister-ScheduledTask -Confirm:$false

# 2. Delete GUID enrollment subkeys using native reg.exe to bypass PS provider issues
reg query "HKLM\SOFTWARE\Microsoft\Enrollments" /k /f "*-*-*-*-*" | ForEach-Object { 
    reg delete $_ /f 
} 2>$null

# 3. Force policy refresh
gpupdate /force