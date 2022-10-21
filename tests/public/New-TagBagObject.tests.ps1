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
        # $tagdatain = [PSCustomObject]@{
        #     module            = 'appinsights'
        #     version           = '1.0.1'
        #     provisioningState = 'success'
        # }


        it "creates a schema tag object called aztagdataschema" {
          $result = New-TagBagObject $TestInputObject
          $result.Keys | Should -Contain 'TagBagSchema'
        }

        it "creates a schema tag object that follows the schema defined in aztagdataschema" -skip {

        }

        # Microsoft.Azure.Management.ResourceManager.Models::Tags(new)
        # https://learn.microsoft.com/en-us/dotnet/api/microsoft.azure.management.resourcemanager.models.tags?view=azure-dotnet



        it "throws if it returns nothing" -skip {

        }

        it "throws if key is longer than 512" -skip {

        }

        it "throws if value is longer than 256" -skip {

        }

        it "can be decoded to json in both key and value" -skip {

        }

        it "returns a hashtable" -skip {}

        # in ReadMeBicepDeploy.tests.ps1, inputObject comes from $deploymentOutputHash
        # which is the return obj from Azure after a bicep deployment from BicepFlex

        # which module changed, version, whether last deploy succeeded or failed

        # @{
        #     module            = $modName
        #     version           = $version
        #     ProvisioningState = "succeeded|failed"
        # }

        # scripts checks tags to determine whether to run the deployment test again
        # if the provisioningState for the version is succeeded, skip
        # otherwise, run


        # sample input

        # sample output

    }
}

