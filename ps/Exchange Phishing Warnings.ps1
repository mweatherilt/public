# Import commonly used functions
Import-Module ./common.psm1

#Connect & Login to ExchangeOnline (MFA)
Write-Host "Connect to Exchange Online" -ForegroundColor Cyan
Test-ExchangeConnected

$RuleName = "External Emails Notice"
 
# Test if transport rule exists
$Rule = Get-TransportRule $RuleName -ErrorAction SilentlyContinue
If ($Rule -eq $null) {
    Write-Host -ForegroundColor Red "`nRule [$RuleName] does not exist"
    Break
    $HTMLDisclaimer = '
    <table border=0 cellspacing=0 cellpadding=0 align="left" width="100%">
        <tr>
            <td style="background:#ffb900;padding:5pt 2pt 5pt 2pt"></td>
            <td width="100%" cellpadding="7px 6px 7px 15px" style="background:#fff8e5;padding:5pt 4pt 5pt 12pt;word-wrap:break-word">
                <div style="color:#222222;">
                    <span style="color:#222; font-weight:bold;">Caution:</span>
                    This is an external email and has a suspicious content. Please take care when clicking links or opening attachments. When in doubt, contact your IT Department
                </div>
            </td>
        </tr>
    </table>
    <br/>'

    Write-Host $RuleName -ForegroundColor Cyan

    # Create new Transport Rule
    New-TransportRule -Name $RuleName `
                    -FromScope NotInOrganization `
                    -SentToScope InOrganization `
                    -SubjectOrBodyMatchesPatterns (Get-Content $PSScriptRoot\PhishingPatterns.txt) `
                    -ApplyHtmlDisclaimerLocation Prepend `
                    -ApplyHtmlDisclaimerText $HTMLDisclaimer `
                    -ApplyHtmlDisclaimerFallbackAction Wrap

    Write-Host "Transport rule created" -ForegroundColor Green
}
Else {
    # Update the transport rule with all the patterns
    Set-TransportRule -Identity $RuleName -SubjectOrBodyMatchesPatterns (Get-Content $PSScriptRoot\PhishingPatterns.txt)
}


