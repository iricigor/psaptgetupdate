# size in MB of a given file
function size ([string]$Path) {
    [int]( (Get-Item $Path).Length / 1MB)
} 
