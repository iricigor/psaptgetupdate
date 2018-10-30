$executioncontext.InvokeCommand.CommandNotFoundAction = { 
    param ($e, $e2)  

    $e2.StopSearch = $true
    $Module = @(Find-CommandFromCache $e -ea 0)

    if ($Module.Count -gt 1) {
        $Msg = "Command $e not found, but it is available in multiple modules, run 'Find-CommandFromCache $e' to find them and then 'Install-Module <ModuleName>'."
        $e2.CommandScriptblock = {Write-Warning -Verbose $Msg}.GetNewClosure()
    } elseif ($Module.Count -eq 1) {
        $Msg = "Command $e not found, you can install it with 'Install-Module $($Module.ModuleName)'"
        $e2.CommandScriptblock = {Write-Warning -Verbose $Msg}.GetNewClosure()
   } else {
       # no action needed, throws default error
   }
}


# as per Bruce Payette comment
# https://github.com/PowerShell/PowerShell/issues/1982#issuecomment-391482768