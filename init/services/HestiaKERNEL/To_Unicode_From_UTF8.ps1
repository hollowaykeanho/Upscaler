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
. "${env:LIBS_HESTIA}\HestiaKERNEL\Is_UTF.ps1"
. "${env:LIBS_HESTIA}\HestiaKERNEL\Unicode.ps1"




function HestiaKERNEL-To-Unicode-From-UTF8 {
        param (
                [byte[]]$___bytes_array
        )


        # validate input
        if ($___bytes_array.Length -eq 0) {
                return [uint32[]]@()
        }


        # execute
        # IMPORTANT NOTICE
        # PowerShell does not handle UTF-8 byte stream in an isolated manner without messing up
        # the current terminals' environment variables (e.g. $OutputEncoding). To avoid it, manual
        # implementations are required.


        # check for data encoder
        $___ignore = 0
        $___output = HestiaKERNEL-Is-UTF $___bytes_array
        if ($($___output -replace "${env:HestiaKERNEL_UTF8_BOM}", '') -ne $___output) {
                # it's UTF8 with BOM marker
                $___ignore = 3
        } elseif ($($___output -replace "${env:HestiaKERNEL_UTF8}", '') -ne $___output) {
                # UTF8 is a candidate - try to convert
        } else {
                # unsupported decoders
                return @()
        }

        [System.Collections.Generic.List[uint32]]$___converted = @()
        $___char = [uint32]0
        $___state = 0
        foreach ($___datum in $___bytes_array) {
                # ignore BOM markers
                if ($___ignore -gt 0) {
                        $___ignore -= 1
                        continue
                }


                # get current character decimal
                $___byte = [uint32]$___datum


                # identify initial state
                if ($___state -ne 0) {
                        # it's a tailing operation - DO NOTHING
                } elseif ($___byte -lt 200) {
                        # x < 0x80 (char < 0x80)
                        $___state = 0
                } elseif (($___byte -gt 193) -and ($___byte -lt 200)) {
                        # 0xBF < x < 0xE0 (char < 0x800)
                        $___state = 1
                } elseif (($___byte -gt 223) -and ($___byte -lt 240)) {
                        # 0xDF < x < 0xF0 (char < 0x10000)
                        $___state = 3
                } else {
                        # 0x10000-0x10FFFF (surrogate pair)
                        $___state = 6
                }

                switch ($___state) {
                9 {
                        $___byte = $___byte -band 0x3F
                        $___char = $___char -bor $___byte
                        $null = $___converted.Add($___char)

                        $___state = 0
                } 8 {
                        $___byte = $___byte -band 0x3F
                        $___byte = $___byte -shl 6
                        $___char = $___char -bor $___byte

                        $___state = 9
                } 7 {
                        $___byte = $___byte -band 0x3F
                        $___byte = $___byte -shl 12
                        $___char = $___char -bor $___byte

                        $___state = 8
                } 6 {
                        # 0x10000-0x10FFFF (surrogate pair)
                        $___byte = $___byte -band 0x07
                        $___char = $___byte -shl 18

                        $___state = 7
                } 5 {
                        $___byte = $___byte -band 0x3F
                        $___char = $___char -bor $___byte
                        $null = $___converted.Add($___char)

                        $___state = 0
                } 4 {
                        $___byte = $___byte -band 0x3F
                        $___byte = $___byte -shl 6
                        $___char = $___char -bor $___byte

                        $___state = 5
                } 3 {
                        # 0xDF < x < 0xF0 (char < 0x10000)
                        $___byte = $___byte -band 0x0F
                        $___char = $___byte -shl 12

                        $___state = 4
                } 2 {
                        $___byte = $___byte -band 0x3F
                        $___char = $___char -bor $___byte
                        $null = $___converted.Add($___char)

                        $___state = 0
                } 1 {
                        # 0xBF < x < 0xE0 (char < 0x800)
                        $___byte = $___byte -band 0x1F
                        $___char = $___byte -shl 6

                        $___state = 2
                } default {
                        # x < 0x80 (char < 0x80)
                        $null = $___converted.Add($___byte)

                        $___state = 0
                }}
        }


        # report status
        return [uint32[]]$___converted
}
