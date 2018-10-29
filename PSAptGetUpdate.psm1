[Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSAvoidUsingWriteHost','')]
param()

$ModName = 'PSAptGetUpdate'
Get-Module $ModName | Remove-Module -Force

Write-Host "`n`n$ModName module import starting`n" -ForegroundColor Cyan

#
# Import main functions
#

$Public = @(Get-ChildItem (Join-Path $PSScriptRoot 'Public') -Filter *.ps1)
$Private = @(Get-ChildItem (Join-Path $PSScriptRoot 'Private') -Filter *.ps1 -ErrorAction SilentlyContinue)
$MaxLen = ($Private+$Public).Name | ForEach-Object {$_.Length} | Sort-Object | Select-Object -Last 1

foreach ($F in ($Private+$Public) ) {

    Write-Host ("Importing $($F.Name)... ") -NoNewline
    Write-Host $(' '*($MaxLen - $F.Name.Length)) -NoNewline

    try {
        . ($F.FullName)
        Write-Host '  OK  ' -ForegroundColor Green
    } catch {
        Write-Host 'FAILED' -ForegroundColor Red
    }
}

Export-ModuleMember -Function $Public.BaseName
Write-Host "Exported $($Public.Count) member(s)"
Export-ModuleMember -Alias *


Write-Host "`nModule web site github.com/iricigor/aptgetupdate"
Write-Host "`nType 'Get-Command -Module $ModName' for list of commands, 'Get-Help <CommandName>' for help, or"
Write-Host "'Get-Command -Module $ModName | Get-Help | Select Name, Synopsis' for explanation on all commands`n"
