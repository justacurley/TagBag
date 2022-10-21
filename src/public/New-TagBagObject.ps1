function New-TagBagObject {
    [CmdletBinding(SupportsShouldProcess)]
    param (
        # Parameter help description
        [Parameter(Mandatory)]
        [PSCustomObject]
        $TagData,

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
        $length = 0

        # Create aztagdataschema Tag from pscustomobject property names
        $schema = $TagData | Get-Member -MemberType NoteProperty | Select-Object -ExpandProperty Name
        $TagHashTable.Add('TagBagSchema', $($schema | Convertto-Json -Compress))
        $key512 = $true
    }

    process {
        Foreach ($Row in $TagData) {
            $tagLine = @()
            for ($i = 0; $i -lt $schema.length; $i++) {
                $label = $schema[$i]
                $value = $row.$label
                $tagLine += $value
            }  
            $compressedLine = $tagLine | Convertto-Json -Compress
            $length += $compressedLine.length
            $limit = ($compressedLine.length + $length + 4)
            
            if ($key512) { $maxLen = 512 }
            else {$maxLen = 256}
            
            if ($limit -le $maxLen) {
                $currentTagLine.Add($tagLine) | Out-Null
            }
            elseif ($limit -ge $maxLen) {
                $protoTags.Add($currentTagLine) | Out-Null
                $currentTagLine = [System.Collections.ArrayList]@()
                $currentTagLine.Add($tagLine) | Out-Null
                $length = $compressedLine.length
                if ($key512) {
                    $lastKey = $protoTags | ConvertTo-Json -Compress
                    $TagHashTable.Add($lastKey,$null)
                    $key512 = $false
                } else {
                    $newValue = $protoTags | ConvertTo-Json -Compress
                    $TagHashTable[$lastKey]=$newValue
                    $key512 = $true
                    Remove-Variable lastKey
                }
                $protoTags = [System.Collections.ArrayList]@()
            }
        }
    }

    end {
        # return tags hashtable        
        $TagHashTable
    }
}


# New-TagBagObject -TagData (gc C:\Users\acurley\source\TagBag\tests\data\New-TagBagDataObject\input.json | ConvertFrom-Json) -ov foo
# (gc C:\Users\acurley\source\TagBag\tests\data\New-TagBagDataObject\input.json | ConvertFrom-Json) | New-TagBagObject  
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

        New-AzTag -ResourceId $script:rgObj.ResourceId -Tag $tagHash #-Operation Merge
    
#>