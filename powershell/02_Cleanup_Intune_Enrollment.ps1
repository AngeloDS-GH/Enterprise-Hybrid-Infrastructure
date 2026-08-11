# ==============================================================================
# Script: 02_Cleanup_Intune_Enrollment.ps1
# Description:
#   Removes stale Microsoft Intune / MDM enrollment artifacts from a Windows
#   endpoint before attempting automatic MDM enrollment again.
#
# Domain: dmontech.local
#
# WARNING:
#   Run this script as Administrator.
#   Intended for troubleshooting stale or failed Intune enrollment states.
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
Write-Host "Starting Intune enrollment cleanup..." -ForegroundColor Cyan


# ==============================================================================
# 2. Remove EnterpriseMgmt Scheduled Tasks
# ==============================================================================

Write-Host ""
Write-Host "Checking EnterpriseMgmt scheduled tasks..." -ForegroundColor Yellow

$enterpriseMgmtTasks = Get-ScheduledTask -ErrorAction SilentlyContinue |
    Where-Object {
        $_.TaskPath -like "\Microsoft\Windows\EnterpriseMgmt\*"
    }

if ($enterpriseMgmtTasks) {

    foreach ($task in $enterpriseMgmtTasks) {

        Write-Host "Removing scheduled task: $($task.TaskPath)$($task.TaskName)"

        Unregister-ScheduledTask `
            -TaskName $task.TaskName `
            -TaskPath $task.TaskPath `
            -Confirm:$false `
            -ErrorAction SilentlyContinue
    }

    Write-Host "EnterpriseMgmt scheduled tasks removed." -ForegroundColor Green
}
else {
    Write-Host "No EnterpriseMgmt scheduled tasks were found." -ForegroundColor Gray
}


# ==============================================================================
# 3. Remove Stale MDM Enrollment Registry Keys
# ==============================================================================

Write-Host ""
Write-Host "Checking MDM enrollment registry keys..." -ForegroundColor Yellow

$enrollmentPath = "HKLM:\SOFTWARE\Microsoft\Enrollments"

if (Test-Path $enrollmentPath) {

    $enrollmentKeys = Get-ChildItem `
        -Path $enrollmentPath `
        -ErrorAction SilentlyContinue |
        Where-Object {
            $_.PSChildName -match '^[0-9A-Fa-f]{8}-[0-9A-Fa-f]{4}-[0-9A-Fa-f]{4}-[0-9A-Fa-f]{4}-[0-9A-Fa-f]{12}$'
        }

    if ($enrollmentKeys) {

        foreach ($key in $enrollmentKeys) {

            Write-Host "Removing enrollment key: $($key.PSChildName)"

            Remove-Item `
                -Path $key.PSPath `
                -Recurse `
                -Force `
                -ErrorAction SilentlyContinue
        }

        Write-Host "Stale enrollment registry keys removed." -ForegroundColor Green
    }
    else {
        Write-Host "No GUID-based enrollment keys were found." -ForegroundColor Gray
    }
}
else {
    Write-Host "Enrollment registry path was not found." -ForegroundColor Gray
}


# ==============================================================================
# 4. Refresh Group Policy
# ==============================================================================

Write-Host ""
Write-Host "Refreshing Group Policy..." -ForegroundColor Yellow

gpupdate /force


# ==============================================================================
# 5. Completion
# ==============================================================================

Write-Host ""
Write-Host "Intune enrollment cleanup completed successfully." -ForegroundColor Green
Write-Host "The endpoint is ready for a new MDM enrollment attempt." -ForegroundColor Green# ==============================================================================
# Script: 02_Cleanup_Intune_Enrollment.ps1
# Description:
#   Removes stale Microsoft Intune / MDM enrollment artifacts from a Windows
#   endpoint before attempting automatic MDM enrollment again.
#
# Domain: dmontech.local
#
# WARNING:
#   Run this script as Administrator.
#   Intended for troubleshooting stale or failed Intune enrollment states.
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
Write-Host "Starting Intune enrollment cleanup..." -ForegroundColor Cyan


# ==============================================================================
# 2. Remove EnterpriseMgmt Scheduled Tasks
# ==============================================================================

Write-Host ""
Write-Host "Checking EnterpriseMgmt scheduled tasks..." -ForegroundColor Yellow

$enterpriseMgmtTasks = Get-ScheduledTask -ErrorAction SilentlyContinue |
    Where-Object {
        $_.TaskPath -like "\Microsoft\Windows\EnterpriseMgmt\*"
    }

if ($enterpriseMgmtTasks) {

    foreach ($task in $enterpriseMgmtTasks) {

        Write-Host "Removing scheduled task: $($task.TaskPath)$($task.TaskName)"

        Unregister-ScheduledTask `
            -TaskName $task.TaskName `
            -TaskPath $task.TaskPath `
            -Confirm:$false `
            -ErrorAction SilentlyContinue
    }

    Write-Host "EnterpriseMgmt scheduled tasks removed." -ForegroundColor Green
}
else {
    Write-Host "No EnterpriseMgmt scheduled tasks were found." -ForegroundColor Gray
}


# ==============================================================================
# 3. Remove Stale MDM Enrollment Registry Keys
# ==============================================================================

Write-Host ""
Write-Host "Checking MDM enrollment registry keys..." -ForegroundColor Yellow

$enrollmentPath = "HKLM:\SOFTWARE\Microsoft\Enrollments"

if (Test-Path $enrollmentPath) {

    $enrollmentKeys = Get-ChildItem `
        -Path $enrollmentPath `
        -ErrorAction SilentlyContinue |
        Where-Object {
            $_.PSChildName -match '^[0-9A-Fa-f]{8}-[0-9A-Fa-f]{4}-[0-9A-Fa-f]{4}-[0-9A-Fa-f]{4}-[0-9A-Fa-f]{12}$'
        }

    if ($enrollmentKeys) {

        foreach ($key in $enrollmentKeys) {

            Write-Host "Removing enrollment key: $($key.PSChildName)"

            Remove-Item `
                -Path $key.PSPath `
                -Recurse `
                -Force `
                -ErrorAction SilentlyContinue
        }

        Write-Host "Stale enrollment registry keys removed." -ForegroundColor Green
    }
    else {
        Write-Host "No GUID-based enrollment keys were found." -ForegroundColor Gray
    }
}
else {
    Write-Host "Enrollment registry path was not found." -ForegroundColor Gray
}


# ==============================================================================
# 4. Refresh Group Policy
# ==============================================================================

Write-Host ""
Write-Host "Refreshing Group Policy..." -ForegroundColor Yellow

gpupdate /force


# ==============================================================================
# 5. Completion
# ==============================================================================

Write-Host ""
Write-Host "Intune enrollment cleanup completed successfully." -ForegroundColor Green
Write-Host "The endpoint is ready for a new MDM enrollment attempt." -ForegroundColor Green# ==============================================================================
# Script: 02_Cleanup_Intune_Enrollment.ps1
# Description:
#   Removes stale Microsoft Intune / MDM enrollment artifacts from a Windows
#   endpoint before attempting automatic MDM enrollment again.
#
# Domain: dmontech.local
#
# WARNING:
#   Run this script as Administrator.
#   Intended for troubleshooting stale or failed Intune enrollment states.
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
Write-Host "Starting Intune enrollment cleanup..." -ForegroundColor Cyan


# ==============================================================================
# 2. Remove EnterpriseMgmt Scheduled Tasks
# ==============================================================================

Write-Host ""
Write-Host "Checking EnterpriseMgmt scheduled tasks..." -ForegroundColor Yellow

$enterpriseMgmtTasks = Get-ScheduledTask -ErrorAction SilentlyContinue |
    Where-Object {
        $_.TaskPath -like "\Microsoft\Windows\EnterpriseMgmt\*"
    }

if ($enterpriseMgmtTasks) {

    foreach ($task in $enterpriseMgmtTasks) {

        Write-Host "Removing scheduled task: $($task.TaskPath)$($task.TaskName)"

        Unregister-ScheduledTask `
            -TaskName $task.TaskName `
            -TaskPath $task.TaskPath `
            -Confirm:$false `
            -ErrorAction SilentlyContinue
    }

    Write-Host "EnterpriseMgmt scheduled tasks removed." -ForegroundColor Green
}
else {
    Write-Host "No EnterpriseMgmt scheduled tasks were found." -ForegroundColor Gray
}


# ==============================================================================
# 3. Remove Stale MDM Enrollment Registry Keys
# ==============================================================================

Write-Host ""
Write-Host "Checking MDM enrollment registry keys..." -ForegroundColor Yellow

$enrollmentPath = "HKLM:\SOFTWARE\Microsoft\Enrollments"

if (Test-Path $enrollmentPath) {

    $enrollmentKeys = Get-ChildItem `
        -Path $enrollmentPath `
        -ErrorAction SilentlyContinue |
        Where-Object {
            $_.PSChildName -match '^[0-9A-Fa-f]{8}-[0-9A-Fa-f]{4}-[0-9A-Fa-f]{4}-[0-9A-Fa-f]{4}-[0-9A-Fa-f]{12}$'
        }

    if ($enrollmentKeys) {

        foreach ($key in $enrollmentKeys) {

            Write-Host "Removing enrollment key: $($key.PSChildName)"

            Remove-Item `
                -Path $key.PSPath `
                -Recurse `
                -Force `
                -ErrorAction SilentlyContinue
        }

        Write-Host "Stale enrollment registry keys removed." -ForegroundColor Green
    }
    else {
        Write-Host "No GUID-based enrollment keys were found." -ForegroundColor Gray
    }
}
else {
    Write-Host "Enrollment registry path was not found." -ForegroundColor Gray
}


# ==============================================================================
# 4. Refresh Group Policy
# ==============================================================================

Write-Host ""
Write-Host "Refreshing Group Policy..." -ForegroundColor Yellow

gpupdate /force


# ==============================================================================
# 5. Completion
# ==============================================================================

Write-Host ""
Write-Host "Intune enrollment cleanup completed successfully." -ForegroundColor Green
Write-Host "The endpoint is ready for a new MDM enrollment attempt." -ForegroundColor Green# ==============================================================================
# Script: 02_Cleanup_Intune_Enrollment.ps1
# Description:
#   Removes stale Microsoft Intune / MDM enrollment artifacts from a Windows
#   endpoint before attempting automatic MDM enrollment again.
#
# Domain: dmontech.local
#
# WARNING:
#   Run this script as Administrator.
#   Intended for troubleshooting stale or failed Intune enrollment states.
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
Write-Host "Starting Intune enrollment cleanup..." -ForegroundColor Cyan


# ==============================================================================
# 2. Remove EnterpriseMgmt Scheduled Tasks
# ==============================================================================

Write-Host ""
Write-Host "Checking EnterpriseMgmt scheduled tasks..." -ForegroundColor Yellow

$enterpriseMgmtTasks = Get-ScheduledTask -ErrorAction SilentlyContinue |
    Where-Object {
        $_.TaskPath -like "\Microsoft\Windows\EnterpriseMgmt\*"
    }

if ($enterpriseMgmtTasks) {

    foreach ($task in $enterpriseMgmtTasks) {

        Write-Host "Removing scheduled task: $($task.TaskPath)$($task.TaskName)"

        Unregister-ScheduledTask `
            -TaskName $task.TaskName `
            -TaskPath $task.TaskPath `
            -Confirm:$false `
            -ErrorAction SilentlyContinue
    }

    Write-Host "EnterpriseMgmt scheduled tasks removed." -ForegroundColor Green
}
else {
    Write-Host "No EnterpriseMgmt scheduled tasks were found." -ForegroundColor Gray
}


# ==============================================================================
# 3. Remove Stale MDM Enrollment Registry Keys
# ==============================================================================

Write-Host ""
Write-Host "Checking MDM enrollment registry keys..." -ForegroundColor Yellow

$enrollmentPath = "HKLM:\SOFTWARE\Microsoft\Enrollments"

if (Test-Path $enrollmentPath) {

    $enrollmentKeys = Get-ChildItem `
        -Path $enrollmentPath `
        -ErrorAction SilentlyContinue |
        Where-Object {
            $_.PSChildName -match '^[0-9A-Fa-f]{8}-[0-9A-Fa-f]{4}-[0-9A-Fa-f]{4}-[0-9A-Fa-f]{4}-[0-9A-Fa-f]{12}$'
        }

    if ($enrollmentKeys) {

        foreach ($key in $enrollmentKeys) {

            Write-Host "Removing enrollment key: $($key.PSChildName)"

            Remove-Item `
                -Path $key.PSPath `
                -Recurse `
                -Force `
                -ErrorAction SilentlyContinue
        }

        Write-Host "Stale enrollment registry keys removed." -ForegroundColor Green
    }
    else {
        Write-Host "No GUID-based enrollment keys were found." -ForegroundColor Gray
    }
}
else {
    Write-Host "Enrollment registry path was not found." -ForegroundColor Gray
}


# ==============================================================================
# 4. Refresh Group Policy
# ==============================================================================

Write-Host ""
Write-Host "Refreshing Group Policy..." -ForegroundColor Yellow

gpupdate /force


# ==============================================================================
# 5. Completion
# ==============================================================================

Write-Host ""
Write-Host "Intune enrollment cleanup completed successfully." -ForegroundColor Green
Write-Host "The endpoint is ready for a new MDM enrollment attempt." -ForegroundColor Green# ==============================================================================
# Script: 02_Cleanup_Intune_Enrollment.ps1
# Description:
#   Removes stale Microsoft Intune / MDM enrollment artifacts from a Windows
#   endpoint before attempting automatic MDM enrollment again.
#
# Domain: dmontech.local
#
# WARNING:
#   Run this script as Administrator.
#   Intended for troubleshooting stale or failed Intune enrollment states.
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
Write-Host "Starting Intune enrollment cleanup..." -ForegroundColor Cyan


# ==============================================================================
# 2. Remove EnterpriseMgmt Scheduled Tasks
# ==============================================================================

Write-Host ""
Write-Host "Checking EnterpriseMgmt scheduled tasks..." -ForegroundColor Yellow

$enterpriseMgmtTasks = Get-ScheduledTask -ErrorAction SilentlyContinue |
    Where-Object {
        $_.TaskPath -like "\Microsoft\Windows\EnterpriseMgmt\*"
    }

if ($enterpriseMgmtTasks) {

    foreach ($task in $enterpriseMgmtTasks) {

        Write-Host "Removing scheduled task: $($task.TaskPath)$($task.TaskName)"

        Unregister-ScheduledTask `
            -TaskName $task.TaskName `
            -TaskPath $task.TaskPath `
            -Confirm:$false `
            -ErrorAction SilentlyContinue
    }

    Write-Host "EnterpriseMgmt scheduled tasks removed." -ForegroundColor Green
}
else {
    Write-Host "No EnterpriseMgmt scheduled tasks were found." -ForegroundColor Gray
}


# ==============================================================================
# 3. Remove Stale MDM Enrollment Registry Keys
# ==============================================================================

Write-Host ""
Write-Host "Checking MDM enrollment registry keys..." -ForegroundColor Yellow

$enrollmentPath = "HKLM:\SOFTWARE\Microsoft\Enrollments"

if (Test-Path $enrollmentPath) {

    $enrollmentKeys = Get-ChildItem `
        -Path $enrollmentPath `
        -ErrorAction SilentlyContinue |
        Where-Object {
            $_.PSChildName -match '^[0-9A-Fa-f]{8}-[0-9A-Fa-f]{4}-[0-9A-Fa-f]{4}-[0-9A-Fa-f]{4}-[0-9A-Fa-f]{12}$'
        }

    if ($enrollmentKeys) {

        foreach ($key in $enrollmentKeys) {

            Write-Host "Removing enrollment key: $($key.PSChildName)"

            Remove-Item `
                -Path $key.PSPath `
                -Recurse `
                -Force `
                -ErrorAction SilentlyContinue
        }

        Write-Host "Stale enrollment registry keys removed." -ForegroundColor Green
    }
    else {
        Write-Host "No GUID-based enrollment keys were found." -ForegroundColor Gray
    }
}
else {
    Write-Host "Enrollment registry path was not found." -ForegroundColor Gray
}


# ==============================================================================
# 4. Refresh Group Policy
# ==============================================================================

Write-Host ""
Write-Host "Refreshing Group Policy..." -ForegroundColor Yellow

gpupdate /force


# ==============================================================================
# 5. Completion
# ==============================================================================

Write-Host ""
Write-Host "Intune enrollment cleanup completed successfully." -ForegroundColor Green
Write-Host "The endpoint is ready for a new MDM enrollment attempt." -ForegroundColor Green