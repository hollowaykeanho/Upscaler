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
. "${env:LIBS_HESTIA}\HestiaKERNEL\Get_String_Encoder.ps1"
. "${env:LIBS_HESTIA}\HestiaKERNEL\To_UTF8_From_Unicode.ps1"
. "${env:LIBS_HESTIA}\HestiaKERNEL\To_UTF16_From_Unicode.ps1"
. "${env:LIBS_HESTIA}\HestiaKERNEL\To_UTF32_From_Unicode.ps1"
. "${env:LIBS_HESTIA}\HestiaKERNEL\Unicode.ps1"




function HestiaKERNEL-To-String-From-Unicode {
        param (
                [uint32[]]$___unicode
        )


        # validate input
        if ($___unicode.Length -eq 0) {
                return ""
        }


        # execute
        # process HestiaKERNEL.Unicode data type as the last resort
        switch (HestiaKERNEL-Get-String-Encoder) {
        ${env:HestiaKERNEL_UTF8} {
                $___utf = HestiaKERNEL-To-UTF8-From-Unicode $___unicode
        } ${env:HestiaKERNEL_UTF16BE} {
                $___utf = HestiaKERNEL-To-UTF16-From-Unicode $___unicode
        } ${env:HestiaKERNEL_UTF32BE} {
                $___utf = HestiaKERNEL-To-UTF32-From-Unicode $___unicode
        } default {
                return ""
        }

        $___converted = ""
        foreach ($___byte in $___utf) {
                $___converted = "${___converted}$([string][char]$___byte)"
        }


        # report status
        return $___converted
}
