# ==============================================================================
# Script: 01_Build_AD_Structure.ps1
# Description: Provisions OUs, Security Groups, and Sample Users for DmonTech
# Domain: dmontech.local
# ==============================================================================

# 1. Base OU Hierarchy
New-ADOrganizationalUnit -Name "DmonTech" -Path "DC=dmontech,DC=local"
New-ADOrganizationalUnit -Name "Administration" -Path "OU=DmonTech,DC=dmontech,DC=local"
New-ADOrganizationalUnit -Name "Departments"    -Path "OU=DmonTech,DC=dmontech,DC=local"
New-ADOrganizationalUnit -Name "Groups"         -Path "OU=DmonTech,DC=dmontech,DC=local"
New-ADOrganizationalUnit -Name "Workstations"   -Path "OU=DmonTech,DC=dmontech,DC=local"
New-ADOrganizationalUnit -Name "Servers"        -Path "OU=DmonTech,DC=dmontech,DC=local"

# 2. Site-Based OUs
$sites = @("Cartago-HQ", "SanJose-Corp", "Heredia-RD", "Alajuela-Logistics")
foreach ($site in $sites) {
    New-ADOrganizationalUnit -Name $site -Path "OU=Departments,OU=DmonTech,DC=dmontech,DC=local"
}

# 3. Security Groups
$groups = @("GRP_Execs", "GRP_IT_Admins", "GRP_Plant_Ops", "GRP_Corporate", "GRP_RD_Engineers", "GRP_Logistics")
foreach ($group in $groups) {
    New-ADGroup -Name $group -GroupScope Global -GroupCategory Security -Path "OU=Groups,OU=DmonTech,DC=dmontech,DC=local"
}

# 4. Initial Provisioning - Users
$users = @(
    @{First="Carlos";  Last="Mora";     Title="IT Manager";          Dept="SanJose-Corp";       City="San Jose";  Group="GRP_IT_Admins"},
    @{First="Elena";   Last="Vargas";   Title="Plant Supervisor";     Dept="Cartago-HQ";         City="Cartago";   Group="GRP_Plant_Ops"},
    @{First="Andres";  Last="Chaves";   Title="R&D Engineer";         Dept="Heredia-RD";         City="Heredia";   Group="GRP_RD_Engineers"},
    @{First="Sofia";   Last="Castro";   Title="Logistics Analyst";   Dept="Alajuela-Logistics"; City="Alajuela";  Group="GRP_Logistics"}
)

$password = ConvertTo-SecureString "DmonTech2026!" -AsPlainText -Force

foreach ($u in $users) {
    $sam = ($u.First.Substring(0,1) + $u.Last).ToLower()
    $upn = "$sam@dmontech.local"
    $ouPath = "OU=$($u.Dept),OU=Departments,OU=DmonTech,DC=dmontech,DC=local"
    
    New-ADUser -Name "$($u.First) $($u.Last)" `
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

    Add-ADGroupMember -Identity $u.Group -Members $sam
}


# Add UPN Suffix to forest for hybrid preparation (Entra ID)
Get-ADForest | Set-ADForest -UPNSuffixes @{Add="dmontech.com"}