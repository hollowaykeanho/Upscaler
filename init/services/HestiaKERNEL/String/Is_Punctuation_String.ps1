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
. "${env:LIBS_HESTIA}\HestiaKERNEL\Errors\Error_Codes.ps1"
. "${env:LIBS_HESTIA}\HestiaKERNEL\Unicode\Is_Punctuation_Unicode.ps1"
. "${env:LIBS_HESTIA}\HestiaKERNEL\Unicode\To_Unicode_From_String.ps1"




function HestiaKERNEL-Is-Punctuation-String {
        param (
                [string]$___rune
        )


        # validate input
        $___unicode = HestiaKERNEL-To-Unicode-From-String $___rune
        if ($___unicode.Length -le 0) {
                return ${env:HestiaKERNEL_ERROR_DATA_INVALID}
        }


        # execute
        return HestiaKERNEL-Is-Punctuation-Unicode $___unicode[0]
}
