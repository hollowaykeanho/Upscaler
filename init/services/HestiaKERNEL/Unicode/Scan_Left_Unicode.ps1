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
. "${env:LIBS_HESTIA}\HestiaKERNEL\Number\Is_Number.ps1"




function HestiaKERNEL-Scan-Left-Unicode {
        param (
                [uint32[]]$___content_unicode,
                [uint32[]]$___target_unicode,
                [int32]$___count,
                [int32]$___ignore
        )
        $___scan_index = -1


        # validate input
        if (
                ($(HestiaKERNEL-Is-Unicode $___content_unicode) -ne ${env:HestiaKERNEL_ERROR_OK}) -or
                ($(HestiaKERNEL-Is-Unicode $___target_unicode) -ne ${env:HestiaKERNEL_ERROR_OK})
        ) {
                return [uint32[]]@()
        }

        if (
                ("${___count}" -eq "") -or
                ($___count -le 0)
        ) {
                $___count = -1
        }

        if (
                ("${___ignore}" -eq "") -or
                ($___ignore -le 0)
        ) {
                $___ignore = -1
        }

        if ($___target_unicode.Length -gt $___content_unicode.Length) {
                return [uint32[]]@()
        }


        # execute
        [System.Collections.Generic.List[uint32]]$___list_index = @()
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


                # reset if target is fully scanned
                if ($___target_index -gt $___target_length) {
                        if ($___ignore -le 0) {
                                $___list_index.Add($___scan_index)
                                if ($___count -gt 0) {
                                        $___count -= 1
                                        if ($___count -le 0) {
                                                break
                                        }
                                }
                        } else {
                                $___ignore -= 1
                        }

                        $___scan_index = -1
                        $___target_index = 0
                }
        }


        # report status
        return [uint32[]]$___list_index
}
