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
. "${env:LIBS_HESTIA}\HestiaKERNEL\Unicode\Get_Length_Unicode.ps1"
. "${env:LIBS_HESTIA}\HestiaKERNEL\Unicode\To_Unicode_From_String.ps1"




function HestiaKERNEL-Get-Length-String {
        param (
                [string]$___input_string
        )


        # validate input
        if ($___input_string -eq "") {
                return 0
        }


        # execute
        $___unicodes = HestiaKERNEL-To-Unicode-From-String $___input_string
        if ($___unicodes.Length -le 0) {
                return 0
        }

        return HestiaKERNEL-Get-Length-Unicode $___unicodes
}
