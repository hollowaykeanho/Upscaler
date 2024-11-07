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




function HestiaKERNEL-Trim-Prefix-Unicode {
        param (
                [uint32[]]$___content_unicode,
                [uint32[]]$___prefix_unicode
        )


        # validate input
        if (
                ($(HestiaKERNEL-Is-Unicode $___content_unicode) -ne ${env:HestiaKERNEL_ERROR_OK}) -or
                ($(HestiaKERNEL-Is-Unicode $___prefix_unicode) -ne ${env:HestiaKERNEL_ERROR_OK})
        ) {
                return $___content_unicode
        }

        if ($___prefix_unicode.Length -gt $___content_unicode.Length) {
                return $___content_unicode
        }


        # execute
        for ($i = 0; $i -le $___prefix_unicode.Length - 1; $i++) {
                # get current character
                $___current = ""
                $___current = $___content_unicode[$i]


                # get target character
                $___target = $___prefix_unicode[$i]


                # bail if mismatched
                if ($___current -ne $___target) {
                        return $___content_unicode
                }
        }


        # report status
        return [uint32[]]$___content_unicode[$i..($___content_unicode.Length - 1)]
}
