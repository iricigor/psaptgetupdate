# Script should be executed manually by developer
$ModuleName = 'psaptgetupdate'

# check running folder
if (!(Test-Path "..\$ModuleName\$ModuleName.psd1")) {
    throw "We are not in correct folder"
} else {
    "Checking module $(Resolve-Path "..\$ModuleName\$ModuleName.psd1")"
}

# test manifest
try {
    $Module = Test-ModuleManifest "$ModuleName.psd1" -ea Stop
    "Module $ModuleName.psd1 is OK"
} catch {
    throw 'Module manifest not in proper format'
}

# test if remote is not the same
if (Find-Module -Name $ModuleName -RequiredVersion ($Module.Version) -Repository PSGallery -ea 0) {
    throw 'Module with same version already exists'
} else {
    "No module with version $($Module.Version) found online"
}

# get nuget key from somewhere?
if ($NugetKey) {
    "NugetKey found"
} else {
    throw 'Please define $NugetKey variable'
}
    
# copy entire folder to temp location
$Destination = $Env:TEMP
$Destination2 = Join-Path $Destination $ModuleName
Remove-Item $Destination2 -Recurse -Force
Copy-Item -Path . -Destination $Destination -Recurse # it creates folder $ModuleName
"Copied to $Destination2"

# remove not needed files (starting with dot and from .gitignore)
$Exclude = ,(Get-Content '.gitignore')
Get-ChildItem -Path $Destination2 -Include '.git*' -Recurse | Remove-Item -Recurse -Force
Get-ChildItem -Path $Destination2 -Include $Exclude -Recurse | Remove-Item -Recurse -Force

# publish
Publish-Module -Path $Destination2 -Repository PSGallery -NuGetApiKey $NugetKey -Verbose

"Module $ModuleName published to PowerShell Gallery"