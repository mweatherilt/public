function Test-Module ($n) 
{
    if (Get-Module | Where-Object {$_.name -eq $n}) {
        Write-Host "Module $n is already imported."
    }
    else {
        if (Get-Module -ListAvailable | Where-Object {$_.name -eq $n}) {
            Import-Module $n -Verbose
        }
        else {
            if (Find-Module -Name $n | Where-Object {$_.name -eq $n}) {
                Install-Module -Name $n -Force -Verbose -Scope CurrentUser
                Import-Module $n -Verbose
            }
            else {
                Write-Host "Module $n not imported, not available and not in an online gallery, exiting."
                Exit 1
            }
        }
    }
}

function Test-ExchangeConnected
{
    #Check to see if ExchangeOnlineManagement Module is installed
    Test-Module ExchangeOnlineManagement

    $GetSessions = Get-PSSession | Select-Object -Property State, Name
    $IsConnected = (@($GetSessions) -like '@{State=Opened; Name=ExchangeOnlineInternalSession*').Count -gt 0
    If ($IsConnected -ne "True") {
        Connect-ExchangeOnline
    }
}

