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




function HestiaKERNEL-Trim-Whitespace-Unicode {
        param (
                [uint32[]]$___content_unicode
        )


        # validate input
        if ($(HestiaKERNEL-Is-Unicode $___content_unicode) -ne ${env:HestiaKERNEL_ERROR_OK}) {
                return $___content_unicode
        }


        # execute
        $___scan_left = 0
        $___scan_right = 0
        $___index_left = 0
        $___index_right = $___content_unicode.Length - 1
        for ($i = 0; $i -le $___content_unicode.Length - 1; $i++) {
                if ($___scan_left -eq 0) {
                        # get current character
                        $___current = $___content_unicode[$___index_left]


                        # stop the scan if mismatched
                        if ($(HestiaKERNEL-Is-Whitespace-Unicode $___current) -ne ${env:HestiaKERNEL_ERROR_OK}) {
                                $___scan_left = 1
                        } else {
                                $___index_left += 1
                        }
                }

                if ($___scan_right -eq 0) {
                        # get current character
                        $___current = $___content_unicode[$___index_right]


                        # stop the scan if mismatched
                        if ($(HestiaKERNEL-Is-Whitespace-Unicode $___current) -ne ${env:HestiaKERNEL_ERROR_OK}) {
                                $___scan_right = 1
                        } else {
                                $___index_right -= 1
                        }
                }

                if (
                        (
                                ($___scan_left -ne 0) -and
                                ($___scan_right -ne 0)
                        ) -or
                        ($___index_left -ge $___index_right)
                ) {
                        break
                }
        }

        if (
                ($___index_left -ge $___index_right) -or
                ($___index_left -ge $___content_unicode.Length - 1) -or
                ($___index_right -le 0)
        ) {
                # the resultant is an empty array
                return [uint32[]]@()
        }


        # report status
        return [uint32[]]$___content_unicode[$___index_left..$___index_right]
}
