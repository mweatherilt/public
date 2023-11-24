### The code below Local Standard User Account and setup Auto Logon on Windows computers ###

$Username = 'AutoLogon'
$Password = 'XXnAsbfBBntsiuehtavutZZdFF'

$params = @{
    Name        = $Username
    Password    = ConvertTo-SecureString $Password -AsPlainText -Force
    FullName    = 'Auto Logon'
    Description = 'Local Auto Login Account.'
}

New-LocalUser @params -PasswordNeverExpires

$RegistryPath = 'HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon'
Set-ItemProperty $RegistryPath 'AutoAdminLogon' -Value "1" -Type String 
Set-ItemProperty $RegistryPath 'DefaultUsername' -Value $Username -type String 
Set-ItemProperty $RegistryPath 'DefaultPassword' -Value $Password -type String

# Remove-LocalUser -Name $Username
# Remove-ItemProperty -Path $RegistryPath -Name 'AutoAdminLogon'
# Remove-ItemProperty -Path $RegistryPath -Name 'DefaultUsername'
# Remove-ItemProperty -Path $RegistryPath -Name 'DefaultPassword'

