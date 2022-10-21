#requires -Module @{ModuleName="Pester"; ModuleVersion="5.3.0"}
#Requires -PSEdition Core


Describe 'function New-AzTagDataObject' -Tag Build {
    # contains some examples of concepts frequently used

    BeforeAll {
        # example task to do before the tests
        Copy-Item -Path "$PSScriptRoot\Data\*" -Destination 'TestDrive:' -Recurse
    }

    Context 'Functionality' {

        #TODO: Sample input and ouput data, ideal. Also inputs/outputs that fail.
        # params: Schema, [object[]]InputObject
        $tagdatain = [PSCustomObject]@{
            module            = 'appinsights'
            version           = '1.0.1'
            provisioningState = 'success'
        }

        it "matches schema" {
            # $schema = ['ModuleName','ProvisioningState']
        }

        it "creates a schema tag object called aztagdataschema" {

        }

        it "creates a schema tag object that follows the schema defined in aztagdataschema" {

        }

        # Microsoft.Azure.Management.ResourceManager.Models::Tags(new)
        # https://learn.microsoft.com/en-us/dotnet/api/microsoft.azure.management.resourcemanager.models.tags?view=azure-dotnet



        it "throws if it returns nothing" {

        }

        it "throws if key is longer than 512" {

        }

        it "throws if value is longer than 256" {

        }

        it "can be decoded to json in both key and value" {

        }

        # in ReadMeBicepDeploy.tests.ps1, inputObject comes from $deploymentOutputHash
        # which is the return obj from Azure after a bicep deployment from BicepFlex

        # which module changed, version, whether last deploy succeeded or failed

        @{
            module            = $modName
            version           = $version
            ProvisioningState = "succeeded|failed"
        }

        # scripts checks tags to determine whether to run the deployment test again
        # if the provisioningState for the version is succeeded, skip
        # otherwise, run


        # sample input

        # sample output
        @{
            ''
        }
    }
}

