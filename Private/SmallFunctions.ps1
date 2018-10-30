# size in MB of a given file
function size ([string]$Path) {
    [int]( (Get-Item $Path).Length / 1MB)
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
