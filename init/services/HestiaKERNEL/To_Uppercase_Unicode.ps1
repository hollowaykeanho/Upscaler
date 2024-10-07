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
. "${env:LIBS_HESTIA}\HestiaKERNEL\rune_to_upper.ps1"

. "${env:LIBS_HESTIA}\HestiaKERNEL\Is_Unicode.ps1"




function HestiaKERNEL-To-Uppercase-Unicode {
        param (
                [uint32[]]$___unicode,
                [string]$___locale
        )


        # execute
        if ($(HestiaKERNEL-Is-Unicode $___unicode) -ne ${env:HestiaKERNEL_ERROR_OK}) {
                return $___unicode
        }


        # IMPORTANT NOTICE
        # It's tempting to use the for(...arithmetic...) loop -> DON'T. The
        # scanner do perform multiple index increment depending on the scanned
        # contents at the end of an iteration.
        [System.Collections.Generic.List[uint32]]$___converted = @()
        $___index = 0
        $___length = $___unicode.Length - 1
        while ($___index -le $___length) {
                # get current character
                $___current = $___unicode[$___index]


                # get next character (look forward by 1)
                $___next = 0
                if (($___length - $___index) -ge 1) {
                        $___next = $___unicode[$___index + 1]
                }


                # get third character (look forward by 2)
                $___third = 0
                if (($___length - $___index) -ge 2) {
                        $___third = $___unicode[$___index + 2]
                }


                # process conversion
                $___ret = hestiakernel-rune-to-upper $___current $___next $___third "" $___locale
                $___scanned = $___ret -replace "].*$", ''
                $___ret = $___ret -replace "^\[\d*\]", ''
                while ($___ret -ne "") {
                        $___byte = $___ret -replace ",\s.*$", ''
                        $___ret = $___ret -replace "^\d*,\s", ''
                        $null = $___converted.Add([uint32]$___byte)
                }


                # prepare for next scan
                $___index += [uint32]$___scanned.Substring(1)
        }


        # report status
        return [uint32[]]$___converted
}
