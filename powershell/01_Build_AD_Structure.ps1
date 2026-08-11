# ==============================================================================
# Script: 01_Build_AD_Structure.ps1
# Description: Provisions OUs, Security Groups, and Sample Users for DmonTech
# Domain: dmontech.local
# ==============================================================================

Import-Module ActiveDirectory

# ==============================================================================
# 1. Base OU Hierarchy
# ==============================================================================

$domainDN = "DC=dmontech,DC=local"
$rootOU   = "OU=DmonTech,$domainDN"

New-ADOrganizationalUnit -Name "DmonTech" -Path $domainDN

$baseOUs = @(
    "Administration",
    "Departments",
    "Groups",
    "Workstations",
    "Servers"
)

foreach ($ou in $baseOUs) {
    New-ADOrganizationalUnit `
        -Name $ou `
        -Path $rootOU
}

# ==============================================================================
# 2. Site-Based Organizational Units
# ==============================================================================

$departmentsOU = "OU=Departments,$rootOU"

$sites = @(
    "Cartago-HQ",
    "SanJose-Corp",
    "Heredia-RD",
    "Alajuela-Logistics"
)

foreach ($site in $sites) {
    New-ADOrganizationalUnit `
        -Name $site `
        -Path $departmentsOU
}

# ==============================================================================
# 3. Security Groups
# ==============================================================================

$groupsOU = "OU=Groups,$rootOU"

$groups = @(
    "GRP_Execs",
    "GRP_IT_Admins",
    "GRP_Plant_Ops",
    "GRP_Corporate",
    "GRP_RD_Engineers",
    "GRP_Logistics"
)

foreach ($group in $groups) {
    New-ADGroup `
        -Name $group `
        -GroupScope Global `
        -GroupCategory Security `
        -Path $groupsOU
}

# ==============================================================================
# 4. Initial User Provisioning
# ==============================================================================

$users = @(
    @{
        First = "Carlos"
        Last  = "Mora"
        Title = "IT Manager"
        Dept  = "SanJose-Corp"
        City  = "San Jose"
        Group = "GRP_IT_Admins"
    },
    @{
        First = "Elena"
        Last  = "Vargas"
        Title = "Plant Supervisor"
        Dept  = "Cartago-HQ"
        City  = "Cartago"
        Group = "GRP_Plant_Ops"
    },
    @{
        First = "Andres"
        Last  = "Chaves"
        Title = "R&D Engineer"
        Dept  = "Heredia-RD"
        City  = "Heredia"
        Group = "GRP_RD_Engineers"
    },
    @{
        First = "Sofia"
        Last  = "Castro"
        Title = "Logistics Analyst"
        Dept  = "Alajuela-Logistics"
        City  = "Alajuela"
        Group = "GRP_Logistics"
    }
)

# Lab-only initial password.
# Production environments should use a secure provisioning mechanism.
$password = ConvertTo-SecureString "DmonTech2026!" -AsPlainText -Force

foreach ($u in $users) {

    $sam = ($u.First.Substring(0,1) + $u.Last).ToLower()

    $upn = "$sam@dmontech.local"

    $ouPath = "OU=$($u.Dept),$departmentsOU"

    New-ADUser `
        -Name "$($u.First) $($u.Last)" `
        -GivenName $u.First `
        -Surname $u.Last `
        -SamAccountName $sam `
        -UserPrincipalName $upn `
        -Title $u.Title `
        -Department $u.Dept `
        -City $u.City `
        -Path $ouPath `
        -AccountPassword $password `
        -Enabled $true `
        -ChangePasswordAtLogon $false

    Add-ADGroupMember `
        -Identity $u.Group `
        -Members $sam
}

# ==============================================================================
# 5. Hybrid Identity Preparation
# ==============================================================================

# Add the public UPN suffix used for Microsoft Entra ID integration.
Get-ADForest | Set-ADForest -UPNSuffixes @{Add="dmontech.com"}

Write-Host ""
Write-Host "DmonTech Active Directory structure provisioned successfully." -ForegroundColor Green
Write-Host "Created base OUs, site OUs, security groups, and sample users." -ForegroundColor Green
Write-Host "Added dmontech.com as an alternative UPN suffix for hybrid identity." -ForegroundColor Green