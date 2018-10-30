#
# This is a PowerShell Unit Test file.
# You need a unit test framework such as Pester to run PowerShell Unit tests.
# You can download Pester from http://go.microsoft.com/fwlink/?LinkID=534084
#

#
# Import module
#

$ModuleName = 'PSAptGetUpdate'
$here = Split-Path -Parent $MyInvocation.MyCommand.Path # test folder
$root = (get-item $here).Parent.FullName                # module root folder
Import-Module (Join-Path $root "$ModuleName.psm1") -Force


#
# Fake test
#

Describe "Fake-Test" {
    It "Should be fixed by developer" {
        $true | Should -Be $true
    }
}


#
# Module should import six functions
#


Describe 'Proper Declarations' {

    It 'Checks for existence of functions' {
        @(Get-Command -Module $ModuleName -CommandType Function).Count | Should -Be 6 -Because 'We should have six functions defined'
        Get-Command NonExistingCommand -ea 0 | Should -Be $Null
        # cache management
        Get-Command New-PSRepositoryCache -ea 0 | Should -Not -Be $Null
        Get-Command Update-PSRepositoryCache -ea 0 | Should -Not -Be $Null
        # find operations
        Get-Command Find-CommandFromCache -ea 0 | Should -Not -Be $Null
        Get-Command Find-ModuleFromCache -ea 0 | Should -Not -Be $Null
        Get-Command Find-ScriptFromCache -ea 0 | Should -Not -Be $Null
        Get-Command Update-ModuleFromCache -ea 0 | Should -Not -Be $Null
    }

}

Describe 'Creates new Repository Cache' -Tag 'LongRunning' {

    It 'Creates new Repository Cache successfully' {
        {New-PSRepositoryCache -SkipUpload} | Should -Not -Throw  # long running!
    }

}

Describe 'Proper Functionality' {
    # TODO: Split this to individual files, add more tests

    It 'Runs cache management commands successfully' {
        # cache operations
        {Update-PSRepositoryCache} | Should -Not -Throw
        (Measure-Command {Update-PSRepositoryCache}).TotalSeconds -lt 10 | Should -Be $true
    }

    It 'Runs search commands successfully' {

        {Find-CommandFromCache 'Read-Credential'} | Should -Not -Throw
        Find-CommandFromCache 'Read-Credential' | Should -Not -Be $null
        
        {Find-ModuleFromCache 'FIFA2018'} | Should -Not -Throw
        Find-ModuleFromCache 'FIFA2018' | Should -Not -Be $null

        {Find-ScriptFromCache 'Get-FolderAge'} | Should -Not -Throw
        Find-ScriptFromCache 'Get-FolderAge' | Should -Not -Be $null

        {Update-ModuleFromCache 'Pester'} | Should -Not -Throw

    }

    It 'Runs commands fast' {

        $Time = Measure-Command {1..10 | % {Find-CommandFromCache 'Read-Credential'}} | Select -Expand TotalSeconds
        $Time -lt 2 | Should -Be $true -Because "$Time is too slow for command search"

        $Time = Measure-Command {1..10 | % {Find-ModuleFromCache 'FIFA2018'}} | Select -Expand TotalSeconds
        $Time -lt 10 | Should -Be $true -Because "$Time is too slow for module search"

        $Time = Measure-Command {1..10 | % {Find-ScriptFromCache 'Get-FolderAge'}} | Select -Expand TotalSeconds
        $Time -lt 1 | Should -Be $true -Because "$Time is too slow for script search"

    }
}

Describe 'Update all modules' -Tag 'LongRunning' {
    It 'Updates all modules successfully' {
        {Update-ModuleFromCache} | Should -Not -Throw # long running!
    }

}
#
# Check if documentation is proper
#

# TBD
