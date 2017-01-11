
function Get-EncryptionStatus ($InputFile)
#Returns the Encryption Status of the computers listed in the input file
#Input file is a list of hostnames, one per line
#Usage Example
# Get-EncryptionStatus("C:\users\me\desktop\HostnameList.txt")
{
    #Read in the contents of the file
    $hostnames=get-content $InputFile
    #Loop through the list of hostnames one at a time
    ForEach ($hostname in $hostnames)
    {
        #Check the Encryption Status of the C: drive, filter to the Conversion Status line
        $EncryptionStatus=(manage-bde -status -computername "$hostname" C: | where {$_ -match 'Conversion Status'})
        #Check a status was returned. 
        if ($EncryptionStatus)
        {
            #Status was returned, tidy up the formatting
            $EncryptionStatus=$EncryptionStatus.Split(":")[1].trim()
        }
        else
        {
            #Status was not returned. Explain why in the output
            $EncryptionStatus="Not Found On Network (or access denied)"
        }
        #Format the output object. 2 fields "Hostname" and "Status"
        [pscustomobject][ordered]@{
                    'Hostname'=$Hostname;
                    'Status'=$EncryptionStatus;
        }
    }#End of Loop through Hostnames
}#End of Function
