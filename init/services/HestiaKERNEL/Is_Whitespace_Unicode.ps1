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
. "${env:LIBS_HESTIA}\HestiaKERNEL\Error_Codes.ps1"
. "${env:LIBS_HESTIA}\HestiaKERNEL\Is_Unicode.ps1"




function HestiaKERNEL-Is-Whitespace-Unicode {
        param (
                [uint32]$___unicode
        )


        # validate input
        if ($(HestiaKERNEL-Is-Unicode $___unicode) -ne ${env:HestiaKERNEL_ERROR_OK}) {
                return ${env:HestiaKERNEL_ERROR_DATA_EMPTY}
        }


        # execute
        switch ($___unicode) {
        { $_ -in 9, 10, 11, 12, 13, 32, 133, 160 } {
                #  9    | 10   | 11   | 12   | 13   | 32   | 133  | 160
                # 0x0009|0x000A|0x000B|0x000C|0x000D|0x0020|0x0085|0x00A0
                # '\t'  , '\n' , '\v' , '\f' , '\r' , ' '  , NEL  , NBSP
                return ${env:HestiaKERNEL_ERROR_OK}
        } default {
                return ${env:HestiaKERNEL_ERROR_DATA_INVALID}
        }}
}