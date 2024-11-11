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




function HestiaKERNEL-Trim-Suffix-Unicode {
        param (
                [uint32[]]$___content_unicode,
                [uint32[]]$___target_unicode
        )


        # validate input
        if (
                ($(HestiaKERNEL-Is-Unicode $___content_unicode) -ne ${env:HestiaKERNEL_ERROR_OK}) -or
                ($(HestiaKERNEL-Is-Unicode $___target_unicode) -ne ${env:HestiaKERNEL_ERROR_OK})
        ) {
                return $___content_unicode
        }

        if ($___target_unicode.Length -gt $___content_unicode.Length) {
                return $___content_unicode
        }


        # execute
        $___index = $___content_unicode.Length - 1
        for ($i = $___target_unicode.Length - 1; $i -ge 0; $i--) {
                # bail if mismatched
                if ($___content_unicode[$___index] -ne $___target_unicode[$i]) {
                        return $___content_unicode
                }

                $___index -= 1
        }

        if ($___index -le 0) {
                return [uint32[]]@()
        }


        # report status
        return [uint32[]]$___content_unicode[0..$___index]
}
