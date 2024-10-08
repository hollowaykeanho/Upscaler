# Copyright 2024 (Holloway) Chew, Kean Ho <hello@hollowaykeanho.com>
#
#
# BSD 3-Clause License
#
# Redistribution and use in source and binary forms, with or without
# modification, are permitted provided that the following conditions are met:
#
# 1. Redistributions of source code must retain the above copyright notice, this
#    list of conditions and the following disclaimer.
#
# 2. Redistributions in binary form must reproduce the above copyright notice,
#    this list of conditions and the following disclaimer in the documentation
#    and/or other materials provided with the distribution.
#
# 3. Neither the name of the copyright holder nor the names of its
#    contributors may be used to endorse or promote products derived from
#    this software without specific prior written permission.
#
# THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
# AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
# IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
# DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE
# FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
# DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
# SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
# CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
# OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
# OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
. "${env:LIBS_HESTIA}\HestiaKERNEL\Unicode.ps1"




function HestiaKERNEL-Is-UTF {
        param (
                [byte[]]$___byte_array
        )



        # validate input
        if ($___byte_array.Length -eq 0) {
                return ""
        }


        # execute - based on https://www.unicode.org/versions/Unicode15.1.0/ch03.pdf
        # check for BOM markers and UTF8
        $___count = 8
        $___utf8_expect = 0
        $___utf32_expect = $___byte_array.Length % 4
        $___already_null = $false
        $___byte_0 = $null
        $___byte_1 = $null
        $___byte_2 = $null
        $___byte_3 = $null
        while ($___count -gt 0) {
                if ($___byte_array -eq "") {
                        break
                }


                # get current byte ($___content[0])
                $___byte = $___byte_array[0]
                $___content = $___byte_array.Substring(1)
                $___byte = [byte]$___byte[0]


                # save to sample positions for BOM analysis
                switch ($___count) {
                6 {
                        $___byte_0 = $___byte
                } 5 {
                        $___byte_1 = $___byte
                } 4 {
                        $___byte_2 = $___byte
                } 3 {
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


                # prepare for next scan
                $___count -= 1
        }


        # scan for BOM
        if (
                ($___byte_0 -ne $null) -and
                ($___byte_1 -ne $null) -and
                ($___byte_2 -ne $null) -and
                ($___byte_3 -ne $null)
        ) {
                if (
                        ($___byte_0 -eq 255) -and
                        ($___byte_1 -eq 254) -and
                        ($___byte_2 -eq 0) -and
                        ($___byte_3 -eq 0)
                ) {
                        # it's UTF32LE_BOM
                        return ${env:HestiaKERNEL_UTF32LE_BOM}
                } elseif (
                        ($___byte_0 -eq 0) -and
                        ($___byte_1 -eq 0) -and
                        ($___byte_2 -eq 254) -and
                        ($___byte_3 -eq 255)
                ) {
                        # it's UTF32BE_BOM
                        return ${env:HestiaKERNEL_UTF32BE_BOM}
                }
        } elseif (
                ($___byte_0 -ne $null) -and
                ($___byte_1 -ne $null) -and
                ($___byte_2 -ne $null)
        ) {
                if (
                        ($___byte_0 -eq 239) -and
                        ($___byte_1 -eq 187) -and
                        ($___byte_2 -eq 191)
                ) {
                        # it's UTF8_BOM
                        return ${env:HestiaKERNEL_UTF8_BOM}
                }
        } elseif (
                ($___byte_0 -ne $null) -and
                ($___byte_1 -ne $null)
        ) {
                if (
                        ($___byte_0 -eq 255) -and
                        ($___byte_1 -eq 254)
                ) {
                        # it's UTF16LE_BOM
                        return ${env:HestiaKERNEL_UTF16LE_BOM}
                } elseif (
                        ($___byte_0 -eq 254) -and
                        ($___byte_1 -eq 255)
                ) {
                        # it's UTF16BE_BOM
                        return ${env:HestiaKERNEL_UTF16BE_BOM}
                }
        }


        # arrange all possible candidates
        $___output = @"
${env:HestiaKERNEL_UTF16BE}
${env:HestiaKERNEL_UTF16LE}

"@
        if ($___utf8_expect -ge 0) {
                # NOTICE
                # there is a chance of 6 Latin-1 characters in a chain which
                # will make the scanner producing false positive. Hence, let's
                # not assume the scanner is guarenteed correct.
                #
                # Engineering specification specified that user is the one that
                # provides the type, not auto-detect without BOM marker.
                $___output = @"
${env:HestiaKERNEL_UTF8}
${___output}
"@
        }

        if ($___utf32_expect -eq 0) {
                $___output = @"
${___output}
${env:HestiaKERNEL_UTF32BE}
${env:HestiaKERNEL_UTF32LE}

"@
        }


        # report status
        return $___output
}
