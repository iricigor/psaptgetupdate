[Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSAvoidUsingWriteHost','')]
param()

$ModName = 'PSAptGetUpdate'
Get-Module $ModName | Remove-Module -Force

$V = [bool]($ImportModuleWithOutput) # manually defined global variable, for personal testing only!


if ($V) {Write-Host "`n`n$ModName module import starting`n" -ForegroundColor Cyan}

#
#
#

Import-Module PowerShellGet


#
# Import main functions
#

$Public = @(Get-ChildItem (Join-Path $PSScriptRoot 'Public') -Filter *.ps1)
$Private = @(Get-ChildItem (Join-Path $PSScriptRoot 'Private') -Filter *.ps1 -ErrorAction SilentlyContinue)
$MaxLen = ($Private+$Public).Name | ForEach-Object {$_.Length} | Sort-Object | Select-Object -Last 1

foreach ($F in ($Private+$Public) ) {

    if ($V) {Write-Host ("Importing $($F.Name)... ") $(' '*($MaxLen - $F.Name.Length)) -NoNewline}

    try {
        . ($F.FullName)
        if ($V) {Write-Host '  OK  ' -ForegroundColor Green}
    } catch {
        if ($V) {Write-Host 'FAILED' -ForegroundColor Red}
    }
}

Export-ModuleMember -Function $Public.BaseName
if ($V) {Write-Host "Exported $($Public.Count) member(s)"}
Export-ModuleMember -Alias *


if ($V) {
    Write-Host "`nModule web site github.com/iricigor/aptgetupdate"
    Write-Host "`nType 'Get-Command -Module $ModName' for list of commands, 'Get-Help <CommandName>' for help, or"
    Write-Host "'Get-Command -Module $ModName | Get-Help | Select Name, Synopsis' for explanation on all commands`n"
}

# initial actions
if (Test-Path $TP.LockFile) {Remove-Item $TP.LockFile -Force}
Update-PSRepositoryCache