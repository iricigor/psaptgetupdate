$executioncontext.InvokeCommand.CommandNotFoundAction = { 
    param ($e, $e2)  

    $e2.StopSearch = $true

    if ($Module = Find-CommandFromCache $e -ea 0) {
        $e2.CommandScriptblock = {Write-Warning -Verbose "Command $e not found, you can install it with 'Install-Module $($Module.ModuleName)'"}.GetNewClosure()
   }
}


# as per Bruce Payette comment
# https://github.com/PowerShell/PowerShell/issues/1982#issuecomment-391482768