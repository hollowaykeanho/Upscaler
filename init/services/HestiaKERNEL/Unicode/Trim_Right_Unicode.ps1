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




function HestiaKERNEL-Trim-Right-Unicode {
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


        # execute
        [System.Collections.Generic.List[uint32]]$___converted = @()
        $___is_scanning = 0
        :scan_unicode for ($i = $___content_unicode.Length - 1; $i -ge 0; $i--) {
                # get current character
                $___current = $___content_unicode[$i]


                # it's already mismatched so prefix the remaining values
                if ($___is_scanning -ne 0) {
                        $null = $___converted.Insert(0, $___current)
                        continue scan_unicode
                }


                # scan character from given target
                foreach ($___char in $___target_unicode) {
                        if ($___current -eq $___char) {
                                continue scan_unicode # exit early from O(m^2) timing ASAP
                        }
                }


                # It's an mismatched
                $___is_scanning = 1
                $null = $___converted.Insert(0, $___current)
        }


        # report status
        return [uint32[]]$___converted
}
