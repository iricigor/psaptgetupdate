# size in MB of a given file(s)
function size ([string]$Path) {
    $Sum = Get-Item $Path | Measure-Object -Sum -Property Length
    [int]( $Sum.Sum / 1MB)
} 


function CreateTempFolder {
    if (!(Test-Path $Config.TempPath)) {
        Write-Log -Message "Creating temp folder $($Config.TempPath)"
        New-Item $Config.TempPath -ItemType Directory -Force | Out-Null
    }
}

function RemoveTempFolder {
    if (Test-Path $Config.TempPath) {
        Write-Log -Message "Removing temporary items"
        Remove-Item $Config.TempPath -Recurse -Force     
    }
}

function Hash ([string[]]$Name) {
    foreach ($N1 in $Name) {
        $Sum = $N1.ToUpper().ToCharArray() | % {[byte]$_} | Measure-Object -Sum
        [char]([int]($Sum.Sum % 26)+65)
    }
}
