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
. "${env:LIBS_HESTIA}\HestiaKERNEL\Unicode\Is_Unicode.ps1"




function HestiaKERNEL-Index-Left-Unicode {
        param (
                [uint32[]]$___content_unicode,
                [uint32[]]$___target_unicode
        )
        $___scan_index = -1


        # validate input
        if (
                ($(HestiaKERNEL-Is-Unicode $___content_unicode) -ne ${env:HestiaKERNEL_ERROR_OK}) -or
                ($(HestiaKERNEL-Is-Unicode $___target_unicode) -ne ${env:HestiaKERNEL_ERROR_OK})
        ) {
                return $___scan_index
        }

        if ($___target_unicode.Length -gt $___content_unicode.Length) {
                return $___scan_index
        }


        # execute
        $___target_index = 0
        $___target_length = $___target_unicode.Length - 1
        for ($___index = 0; $___index -le $___content_unicode.Length - 1; $___index++) {
                # get current character
                $___current = $___content_unicode[$___index]


                # get target character
                $___target = $___target_unicode[$___target_index]


                # bail if mismatched
                if ($___current -ne $___target) {
                        $___scan_index = -1
                        $___target_index = 0
                        continue
                }
                $___target_index += 1


                # it's a match - set $___scan_index if available
                if ($___scan_index -lt 0) {
                        $___scan_index = $___index
                }


                # break scan if target is fully scanned
                if ($___target_index -gt $___target_length) {
                        return $___scan_index
                }
        }


        # report status
        return -1
}
