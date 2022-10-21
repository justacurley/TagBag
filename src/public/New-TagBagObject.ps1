function New-TagBagObject {
    [CmdletBinding(SupportsShouldProcess)]
    param (
        # Parameter help description
        [Parameter(Mandatory,ValueFromPipeline)]
        [PSCustomObject]
        $InputObject,

        # Parameter help description
        [Parameter(ValueFromPipelineByPropertyName)]
        [Switch]
        $DevMode
    )

    begin {
        
        # Create arraylists to store data
        $TagHashTable = @{}
        $currentTagLine = [System.Collections.ArrayList]@()
        $protoTags = [System.Collections.ArrayList]@()


        # Create aztagdataschema Tag from pscustomobject property names
        $schema = $InputObject | Get-Member -MemberType NoteProperty | Select-Object -ExpandProperty Name
        $TagHashTable.Add('TagBagSchema',$($schema | Convertto-Json -Compress))
    }

    process {

    }

    end {
        # return tags hashtable
        $TagHashTable 
    }
}

<#
        $script:currentTagLine = [System.Collections.ArrayList]@()
        $script:protoTags = [System.Collections.ArrayList]@()

        $infoLen = ("[$ModuleName,$ProvisioningState]").Length + 1
        if (($script:currentTagLine | ConvertTo-Json -Compress).length -lt (256 + $infoLen)) {
            $script:currentTagLine.Add(@($ModuleName, $ProvisioningState)) | Out-Null
            $script:currentTagLine = $script:currentTagLine | ConvertFrom-Json -Depth 99
        }
        else {
            $script:protoTags.Add($script:currentTagLine)
            $script:currentTagLine = [System.Collections.ArrayList]@()
            $script:currentTagLine.Add(@($ModuleName, $ProvisioningState)) | Out-Null
            $script:currentTagLine | ConvertFrom-Json -Depth 99
        }
        $tagHash = @{}
        for ($i = 0; $i -lt $script:protoTags.Count - 3 ; $i = $i + 3) {
            $tagHash.Add($script:protoTags[$i..$i + 1], $script:protoTags[$i + 2])
        }
        New-AzTag -ResourceId $script:rgObj.ResourceId -Tag $tagHash #-Operation Merge
    
#>