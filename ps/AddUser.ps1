$Attributes = @{

    Enabled = $true
    ChangePasswordAtLogon = $true
 
    UserPrincipalName = "tguy@walkerford.com"
    Name = "Test Guy"
    GivenName = "Test"
    Surname = "Guy"
    DisplayName = "Test Guy"
    Description = "This is the account for the third test guy."
    Office = "Server Room"
    EmailAddress = "Test.Guy@walkerford.com"
 
    Company = "Walker Ford"
    Department = "IT"
    Title = "IT Manager"
    City = "Clearwater"
    State = "FL"
    OtherAttributes = @{
     extensionAttribute1="Manager"
     extensionAttribute2="IT"
     proxyAddresses="smtp:Test.Guy@walkerford.com"
    }
 
    AccountPassword = "TotallyFakePassword123" | ConvertTo-SecureString -AsPlainText -Force
 
 }
 
 $path="OU=Test,DC=walkerford,DC=local"
 
 #Get-ADUser -Filter * -SearchBase "OU=Managers,OU=Parts Department,OU=Users,OU=Walker Ford,DC=walkerford,DC=local" | Set-ADUser -Add @{extensionAttribute1="Manager";extensionAttribute2="Front Department"}
 #Get-ADUser -Filter * -SearchBase $path | Set-ADUser -Replace @{Title="Test PS"}
 New-ADUser @Attributes -Path $path 
 
  
 #Remove-ADUser pstestperson -Path $path 
 
 #Get-Help Set-ADUser