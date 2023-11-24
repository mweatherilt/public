### The code below configures Auto-Login on Windows computers ###
 
<#
 
Author: Matt Weatherilt

Date: 06/01/2023

Version: 1.0

Changes:
   
#>
 
$Username = Read-Host 'Enter username for auto-logon (f.e. contoso\user1)'
$Password = Read-Host "Enter password for $Username"

$params = @{
    Name        = $Username
    Password    = $Password
    FullName    = 'Auto Logon'
    Description = 'Local Auto Logon Account.'
}

New-LocalUser @params -PasswordNeverExpires
$RegistryPath = 'HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon'
Set-ItemProperty $RegistryPath 'AutoAdminLogon' -Value "1" -Type String 
Set-ItemProperty $RegistryPath 'DefaultUsername' -Value "$Username" -type String 
Set-ItemProperty $RegistryPath 'DefaultPassword' -Value "$Password" -type String
 
Write-Warning "Auto-Login for $username configured. Please restart computer."
 
$restart = Read-Host 'Do you want to restart your computer now for testing auto-logon? (Y/N)'
 
If ($restart -eq 'Y') {### The code below configures Auto-Login on Windows computers ###

$Username = Read-Host 'Enter username for auto-logon (f.e. contoso\user1)'
$Password = Read-Host "Enter password for $Username"

$params = @{
    Name        = $Username
    Password    = $Password
    FullName    = 'Auto Logon'
    Description = 'Local Auto Logon Account.'
}

New-LocalUser @params -PasswordNeverExpires
$RegistryPath = 'HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon'
Set-ItemProperty $RegistryPath 'AutoAdminLogon' -Value "1" -Type String 
Set-ItemProperty $RegistryPath 'DefaultUsername' -Value "$Username" -type String 
Set-ItemProperty $RegistryPath 'DefaultPassword' -Value "$Password" -type String
 
Write-Warning "Auto-Login for $username configured. Please restart computer."
 
$restart = Read-Host 'Do you want to restart your computer now for testing auto-logon? (Y/N)'
 
If ($restart -eq 'Y') {
 
    Restart-Computer -Force
 
}
 
    Restart-Computer -Force
 
}
