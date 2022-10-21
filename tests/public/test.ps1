

gcm New-TagBagObject

break
function aliabonzai {
    $wd = $PSScriptRoot
    Push-Location $wd 
    Push-Location \..\..\src\public\
    . New-TagBagDataObject.ps1
    gcm New-TagBagDataObject
    Pop-Location
    Pop-Location
}
aliabonzai
break



