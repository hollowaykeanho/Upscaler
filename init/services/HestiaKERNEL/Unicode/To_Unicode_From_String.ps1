# Copyright 2024 (Holloway) Chew, Kean Ho <hello@hollowaykeanho.com>
#
#
# Licensed under (Holloway) Chew, Kean Ho’s Liberal License (the "License").
# You must comply with the license to use the content. Get the License at:
#
#                 https://doi.org/10.5281/zenodo.13770769
#
# You MUST ensure any interaction with the content STRICTLY COMPLIES with
# the permissions and limitations set forth in the license.
. "${env:LIBS_HESTIA}\HestiaKERNEL\Unicode\Unicode.ps1"




function HestiaKERNEL-To-Unicode-From-String {
        param (
                [string]$___string
        )


        # validate input
        if ($___string -eq "") {
                return [uint32[]]@()
        }


        # execute
        # IMPORTANT NOTICE
        # PowerShell is operating on UTF16 and it has a good string library. All
        # it need is converting into Unicode data type and it should be
        # sufficient for other operations.
        [System.Collections.Generic.List[uint32]]$___converted = @()
        while ($___string -ne "") {
                # get byte value
                $___byte = $___string[0]
                $___string = $___string.Substring(1)
                $___byte = [uint32]$___byte[0]


                # save to output
                $null = $___converted.Add($___byte)
        }


        # report status
        return [uint32[]]$___converted
}
