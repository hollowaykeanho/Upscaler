# Copyright (c) 2024 (Holloway) Chew, Kean Ho <hello@hollowaykeanho.com>
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




function HestiaKERNEL-To-UTF8-From-Unicode {
        param (
                [uint32[]]$___content,
                [string]$___bom
        )


        # validate input
        if ($___content.Length -eq 0) {
                return [uint8[]]@()
        }


        # execute
        [System.Collections.Generic.List[uint8]]$___converted = @()
        if ($___bom -eq ${env:HestiaKERNEL_UTF_BOM}) {
                # UTF-8 BOM - 0xEF, 0xBB, 0xBF
                $null = $___converted.Add(0xEF)
                $null = $___converted.Add(0xBB)
                $null = $___converted.Add(0xBF)
        }

        foreach ($___char in $___content) {
                # convert to UTF-8 bytes list
                # IMPORTANT NOTICE
                #   (1) using single code-point algorithm (not the 2 16-bits).
                if ($___char -lt 0x80) {
                        $null = $___converted.Add($___char)
                } elseif ($___char -lt 0x800) {
                        $___register = $___char -shr 6
                        $___register = $___register -band 0x1F
                        $___register = $___register -bor 0xC0
                        $null = $___converted.Add($___register)

                        $___register = $___char -band 0x3F
                        $___register = $___register -bor 0x80
                        $null = $___converted.Add($___register)
                } elseif ($___char -lt 0x10000) {
                        $___register = $___char -shr 12
                        $___register = $___register -band 0x0F
                        $___register = $___register -bor 0xE0
                        $null = $___converted.Add($___register)

                        $___register = $___char -shr 6
                        $___register = $___register -band 0x3F
                        $___register = $___register -bor 0x80
                        $null = $___converted.Add($___register)

                        $___register = $___char -band 0x3F
                        $___register = $___register -bor 0x80
                        $null = $___converted.Add($___register)
                } else {
                        # >0x10000 - 0x10000-0x10FFFF (surrogate pair)
                        $___register = $___char -shr 18
                        $___register = $___register -band 0x07
                        $___register = $___register -bor 0xF0
                        $null = $___converted.Add($___register)

                        $___register = $___char -shr 12
                        $___register = $___register -band 0x3F
                        $___register = $___register -bor 0x80
                        $null = $___converted.Add($___register)

                        $___register = $___char -shr 6
                        $___register = $___register -band 0x3F
                        $___register = $___register -bor 0x80
                        $null = $___converted.Add($___register)

                        $___register = $___char -band 0x3F
                        $___register = $___register -bor 0x80
                        $null = $___converted.Add($___register)
                }
        }


        # report status
        return [uint8[]]$___converted
}
