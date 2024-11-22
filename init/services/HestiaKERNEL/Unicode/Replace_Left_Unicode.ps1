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




function HestiaKERNEL-Replace-Left-Unicode {
        param (
                [uint32[]]$___content_unicode,
                [uint32[]]$___from_unicode,
                [uint32[]]$___to_unicode,
                [int32]$___count,
                [int32]$___ignore
        )


        # validate input
        if (
                ($(HestiaKERNEL-Is-Unicode $___content_unicode) -ne ${env:HestiaKERNEL_ERROR_OK}) -or
                ($(HestiaKERNEL-Is-Unicode $___from_unicode) -ne ${env:HestiaKERNEL_ERROR_OK})
        ) {
                return $___content_unicode
        }

        if ($___to_unicode.Length -gt 0) {
                if ($(HestiaKERNEL-Is-Unicode $___to_unicode) -ne ${env:HestiaKERNEL_ERROR_OK}) {
                        return [uint32[]]@()
                }
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
                return $___content_unicode
        }


        # execute
        [System.Collections.Generic.List[uint32]]$___converted = @()
        [System.Collections.Generic.List[uint32]]$___buffer = @()
        $___from_index = 0
        $___from_length = $___from_unicode.Length - 1
        $___is_replacing = 0
        for ($___index = 0; $___index -le $___content_unicode.Length - 1; $___index++) {
                # get current character
                $___current = $___content_unicode[$___index]


                # get target character
                $___from = $___from_unicode[$___from_index]
                $___from_index += 1


                # bail if mismatched
                if ($___current -ne $___from) {
                        $___from_index = 0

                        if ($___buffer.Length -gt 0) {
                                foreach ($___char in $___buffer) {
                                        $___converted.Add($___char)
                                }
                                [System.Collections.Generic.List[uint32]]$___buffer = @()
                        }

                        $___converted.Add($___current)
                        continue
                }


                # it's a match - save to buffer if the scan is still ongoing
                if ($___from_index -le $___from_length) {
                        $___buffer.Add($___current)
                        continue
                }


                # complete match - perform replacement
                if ($___ignore -le 0) {
                        foreach ($___char in $___to_unicode) {
                                $___converted.Add($___char)
                        }

                        if ($___count -gt 0) {
                                $___count -= 1
                                if ($___count -le 0) {
                                        $___is_replacing = 1

                                        if ($___buffer.Length -gt 0) {
                                                foreach ($___char in $___buffer) {
                                                        $___converted.Add($___char)
                                                }
                                                [System.Collections.Generic.List[uint32]]$___buffer = @()
                                        }

                                        continue
                                }
                        }
                } else {
                        if ($___buffer.Length -gt 0) {
                                foreach ($___char in $___buffer) {
                                        $___converted.Add($___char)
                                }
                        }

                        $___converted.Add($___current)
                        $___ignore -= 1
                }

                [System.Collections.Generic.List[uint32]]$___buffer = @()
                $___from_index = 0
        }

        if ($___buffer.Length -gt 0) {
                foreach ($___char in $___buffer) {
                        $___converted.Add($___char)
                }
                [System.Collections.Generic.List[uint32]]$___buffer = @()
        }


        # report status
        return [uint32[]]$___converted
}
