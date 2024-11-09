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




function HestiaKERNEL-Has-Unicode {
        param (
                [uint32[]]$___content_unicode,
                [uint32[]]$___target_unicode
        )


        # validate input
        if ($(HestiaKERNEL-Is-Unicode $___content_unicode) -ne ${env:HestiaKERNEL_ERROR_OK}) {
                return ${env:HestiaKERNEL_ERROR_ENTITY_EMPTY}
        }

        if ($(HestiaKERNEL-Is-Unicode $___target_unicode) -ne ${env:HestiaKERNEL_ERROR_OK}) {
                return ${env:HestiaKERNEL_ERROR_DATA_EMPTY}
        }

        if ($___target_unicode.Length -gt $___content_unicode.Length) {
                return ${env:HestiaKERNEL_ERROR_DATA_MISMATCHED} # guarenteed mismatched by length
        }


        # execute
        $___target_index = 0
        $___target_length = $___target_unicode.Length - 1
        for ($___index = 0; $___index -le $___content_unicode.Length - 1; $___index++) {
                if ($___content_unicode[$___index] -eq $___target_unicode[$___target_index]) {
                        # PASS - char matched
                        if ($___target_index -ge $___target_length) {
                                # PASS - complete match
                                return ${env:HestiaKERNEL_ERROR_OK}
                        }

                        $___target_index += 1
                        continue
                } else {
                        # FAIL - char mismatched
                        $___target_index = 0
                }
        }


        # report status
        return ${env:HestiaKERNEL_ERROR_DATA_MISMATCHED}
}
