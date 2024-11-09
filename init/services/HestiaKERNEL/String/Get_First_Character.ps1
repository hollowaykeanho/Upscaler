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
. "${env:LIBS_HESTIA}\HestiaKERNEL\String\To_String_From_Unicode.ps1"
. "${env:LIBS_HESTIA}\HestiaKERNEL\Unicode\Get_First_Unicode.ps1"
. "${env:LIBS_HESTIA}\HestiaKERNEL\Unicode\To_Unicode_From_String.ps1"
. "${env:LIBS_HESTIA}\HestiaKERNEL\Unicode\Unicode.ps1"




function HestiaKERNEL-Get-First-Character {
        param (
                [string]$___input_string
        )


        # validate input
        if ($___input_string -eq "") {
                return ""
        }


        # execute
        $___unicodes = HestiaKERNEL-To-Unicode-From-String $___input_string
        if ($___unicodes.Length -le 0) {
                return ""
        }

        $___unicode = HestiaKERNEL-Get-First-Unicode $___unicodes


        # execute
        return HestiaKERNEL-To-String-From-Unicode $___unicode
}
