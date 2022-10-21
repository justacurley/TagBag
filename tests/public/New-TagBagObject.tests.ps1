#requires -Module @{ModuleName="Pester"; ModuleVersion="5.3.0"}
#Requires -PSEdition Core
# $bicepPaths = Get-ChildItem -Path $ldx\sharedinfrastructuremodules\modules\*.bicep -Recurse | Where-Object { $_.basename -eq ($_.directory.name.split('\')[-1]) }
# [pscustomobject]$TagDataIn = $bicepPaths | % {
#   $type = ($_.directory | split-path | split-path -leaf).ToLower()
#   $moduleName = $_.directory.name.ToLower()
#   $wild = "*$($type+'-'+$moduleName)*"
#   [PSCustomObject]@{
#     moduleType = $type
#     moduleName        = $moduleName
#     version           = (git tag -l $wild -n 1 | select -first 1 | select-string -Pattern "(\d+\.){2}\d+").matches.value.trim()
#     provisioningState = @('Succeeded', 'Failed') | Get-Random
#   }
# }



Describe 'function New-TagBagObject' -Tag Build {
    # contains some examples of concepts frequently used

    BeforeAll {
        # example task to do before the tests
        # Copy-Item -Path "$PSScriptRoot\Data\*" -Destination 'TestDrive:' -Recurse
        . (join-path ($PSScriptRoot | split-path | split-path) \src\public\New-TagBagObject.ps1)
        $TestInputObject = (Get-Content "$PSScriptRoot/../Data/New-TagBagDataObject/input.json" | ConvertFrom-Json)
    }

    Context 'Functionality' {
        #TODO: Sample input and ouput data, ideal. Also inputs/outputs that fail.
        # params: Schema, [object[]]InputObject
        BeforeAll {
            # TODO More input tests
            # $tagdatain = @([PSCustomObject]@{
            #     module            = 'appinsights'
            #     version           = '1.0.1'
            #     provisioningState = 'success'
            # }
            # [PSCustomObject]@{
            #     module            = 'appinsights'
            #     version           = '1.0.1'
            #     provisioningState = 'success'
            # }
            # [PSCustomObject]@{
            #     module            = 'appinsights'
            #     version           = '1.0.1'
            #     provisioningState = 'success'
            #     asdf               = 'fuck'
            # })
            # $result = New-TagBagObject $tagdatain
            $result = New-TagBagObject $TestInputObject
        }

        it "returns something" {
            $result | Should -Not -BeNullOrEmpty
        }

        it "returns a hashtable" {
            $result | Should -BeOfType [hashtable]
        }

        it "creates a schema tag object called TagBagSchema" {
            $result.Keys | Should -Contain 'TagBagSchema'
        }

        it "creates a schema tag object with a json string value" {
            $result.TagBagSchema | Should -Not -BeNullOrEmpty
            { $script:convertedTagBagSchema = $result.TagBagSchema | ConvertFrom-Json } | Should -Not -Throw
            $script:convertedTagBagSchema.Count | Should -BeGreaterThan 0
        }
        
        it "all keys are less than 512" {
            $result.keys | Foreach-Object {
                $_.Length | Should -BeLessOrEqual 512
            }
        }
        
        it "all values are less than 256" {
            $result.values | Foreach-Object {
                $_.Length | Should -BeLessOrEqual 256
            }
        }
        
        it "all keys can be decoded to json" {
            $result.keys | Foreach-Object {
                { $_ | ConvertTo-Json } | Should -Not -Throw
            }
        }

        it "all values can be decoded to json" {
            $result.values | Foreach-Object {
                { $_ | ConvertTo-Json } | Should -Not -Throw
            }
        }
    }
}

