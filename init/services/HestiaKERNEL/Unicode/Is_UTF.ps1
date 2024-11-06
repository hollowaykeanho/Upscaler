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
. "${env:LIBS_HESTIA}\HestiaKERNEL\Unicode\Unicode.ps1"




function HestiaKERNEL-Is-UTF {
        param (
                [byte[]]$___byte_array
        )



        # validate input
        if ($___byte_array.Length -eq 0) {
                return ""
        }


        # check for BOM markers and UTF8
        $___content = $___byte_array
        $___count = 8
        $___utf8_expect = 0
        $___utf32_expect = 0
        $___byte_0 = $null
        $___byte_1 = $null
        $___byte_2 = $null
        $___byte_3 = $null
        $___index = 0
        while ($___count -gt 0) {
                if ($___content.Length -eq 0) {
                        break
                }


                # get current byte ($___content[0])
                $___byte = $___content[$___index]
                $___index += 1


                # save to sample positions for BOM analysis
                switch ($___count) {
                8 {
                        $___byte_0 = $___byte
                } 7 {
                        $___byte_1 = $___byte
                } 6 {
                        $___byte_2 = $___byte
                } 5 {
                        $___byte_3 = $___byte
                } default {
                        # do nothing
                }}


                # scan UTF-8 header for its validity
                if ($___utf8_expect -le 0) {
                        # it is already identified invalid - do nothing
                } elseif (($___byte -band 0xF8) -eq 240) {
                        # 11110xxx header
                        if ($___utf8_expect -ne 0) {
                                $___utf8_expect = -1 # expect tailing byte; got new entry
                        } else {
                                $___utf8_expect = 3
                        }
                } elseif (($___byte -band 0xE0) -eq 224) {
                        # 1110xxxx header
                        if ($___utf8_expect -ne 0) {
                                $___utf8_expect = -1 # expect tailing byte; got new entry
                        } else {
                                $___utf8_expect = 2
                        }
                } elseif (($___byte -band 0xE0) -eq 192) {
                        # 110xxxxx header
                        if ($___utf8_expect -ne 0) {
                                $___utf8_expect = -1 # expect tailing byte; got new entry
                        } else {
                                $___utf8_expect = 1
                        }
                } elseif (($___byte -band 0xC0) -eq 128) {
                        # 10xxxxxx header
                        if ($___utf8_expect -le 0) {
                                $___utf8_expect = -1 # unexpected tailing byte
                        } else {
                                $___utf8_expect -= 1
                        }
                } elseif (($___byte -band 0x80) -eq 0) {
                        # 0xxxxxxx header
                        if ($___utf8_expect -gt 0) {
                                $___utf8_expect = -1 # expect tailing character byte; got Latin-1
                        } else {
                                $___utf8_expect = 0 # it's a Latin-1 character (<= 0x7F)
                        }
                } else {
                        # invalid UTF8 - all bytes **MUST** comply to the headers
                        $___utf8_expect = -1
                }


                # detect UTF-32 for later guessing
                if ($___count -le 4) {
                        $___utf32_expect = 1
                }


                # prepare for next scan
                $___count -= 1
        }


        # scan for BOM
        if (
                ($___byte_0 -eq 255) -and
                ($___byte_1 -eq 254) -and
                ($___byte_2 -eq 0) -and
                ($___byte_3 -eq 0)
        ) {
                # it's UTF32LE_BOM
                return "${env:HestiaKERNEL_UTF32LE_BOM}"
        } elseif (
                ($___byte_0 -eq 0) -and
                ($___byte_1 -eq 0) -and
                ($___byte_2 -eq 254) -and
                ($___byte_3 -eq 255)
        ) {
                # it's UTF32BE_BOM
                return "${env:HestiaKERNEL_UTF32BE_BOM}"
        } elseif (
                ($___byte_0 -eq 239) -and
                ($___byte_1 -eq 187) -and
                ($___byte_2 -eq 191)
        ) {
                # it's UTF8_BOM
                return "${env:HestiaKERNEL_UTF8_BOM}"
        } elseif (
                ($___byte_0 -eq 255) -and
                ($___byte_1 -eq 254)
        ) {
                # it's UTF16LE_BOM
                return "${env:HestiaKERNEL_UTF16LE_BOM}"
        } elseif (
                ($___byte_0 -eq 254) -and
                ($___byte_1 -eq 255)
        ) {
                # it's UTF16BE_BOM
                return "${env:HestiaKERNEL_UTF16BE_BOM}"
        }


        # no BOM markers - arrange for possible permutations
        $___output = @"
${env:HestiaKERNEL_UTF16BE}
${env:HestiaKERNEL_UTF16LE}

"@
        if ($___utf8_expect -ge 0) {
                # IMPORTANT NOTICE
                # there is a chance of 6 Latin-1 characters in a straight chain
                # that makes the scanner producing false positive. Hence, let's
                # not assume the scanner is guarenteed correct.
                #
                # Moreover, engineering specification specified that user is
                # the one providing the type, not auto-detection without
                # BOM marker.
                $___output = @"
${env:HestiaKERNEL_UTF8}
${___output}
"@
        }

        if ($___utf32_expect -gt 0) {
                $___output = @"
${___output}
${env:HestiaKERNEL_UTF32BE}
${env:HestiaKERNEL_UTF32LE}

"@
        }


        # report status
        return $___output
}
