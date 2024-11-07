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
. "${env:LIBS_HESTIA}\HestiaKERNEL\Unicode\Is_Whitespace_Unicode.ps1"




function HestiaKERNEL-Trim-Whitespace-Right-Unicode {
        param (
                [uint32[]]$___content_unicode
        )


        # validate input
        if ($(HestiaKERNEL-Is-Unicode $___content_unicode) -ne ${env:HestiaKERNEL_ERROR_OK}) {
                return $___content_unicode
        }


        # execute
        $___index = $___content_unicode.Length - 1
        for (; $___index -ge 0; $___index--) {
                # get current character
                $___current = $___content_unicode[$___index]


                # skip if matched
                if ($(HestiaKERNEL-Is-Whitespace-Unicode $___current) -eq ${env:HestiaKERNEL_ERROR_OK}) {
                        continue
                }


                # mismatched so stop the scan
                break
        }

        if ($___index -le 0) {
                return [uint32[]]@()
        }


        # report status
        return [uint32[]]$___content_unicode[0..$___index]
}
