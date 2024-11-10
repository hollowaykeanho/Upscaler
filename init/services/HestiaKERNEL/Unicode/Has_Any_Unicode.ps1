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
. "${env:LIBS_HESTIA}\HestiaKERNEL\Unicode\Is_Unicode.ps1"




function HestiaKERNEL-Has-Any-Unicode {
        param (
                [uint32[]]$___content_unicode,
                [uint32[]]$___charset_unicode
        )


        # validate input
        if ($(HestiaKERNEL-Is-Unicode $___content_unicode) -ne ${env:HestiaKERNEL_ERROR_OK}) {
                return ${env:HestiaKERNEL_ERROR_ENTITY_EMPTY}
        }

        if ($(HestiaKERNEL-Is-Unicode $___charset_unicode) -ne ${env:HestiaKERNEL_ERROR_OK}) {
                return ${env:HestiaKERNEL_ERROR_DATA_EMPTY}
        }


        # execute
        for ($___index = 0; $___index -le $___content_unicode.Length - 1; $___index++) {
                # get current character
                $___current = $___content_unicode[$___index]


                # scan character from given charset
                foreach ($___char in $___charset_unicode) {
                        if ($___current -eq $___char) {
                                # It's a match
                                return ${env:HestiaKERNEL_ERROR_OK} # exit early from O(m^2) timing ASAP
                        }
                }
        }


        # report status
        return ${env:HestiaKERNEL_ERROR_DATA_MISMATCHED}
}
