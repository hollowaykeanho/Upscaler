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
. "${env:LIBS_HESTIA}\HestiaKERNEL\Trim_Left_Unicode.ps1"
. "${env:LIBS_HESTIA}\HestiaKERNEL\To_Unicode_From_String.ps1"
. "${env:LIBS_HESTIA}\HestiaKERNEL\To_String_From_Unicode.ps1"




function HestiaKERNEL-Trim-Left-String {
        param (
                [string]$___input,
                [string]$___charset
        )


        # validate input
        if (
                ($___input -eq "") -or
                ($___charset -eq "")
        ) {
                return $___input
        }


        # execute
        $___content = HestiaKERNEL-To-Unicode-From-String $___input
        if ($___content.Length -eq 0) {
                return $___input
        }

        $___chars = HestiaKERNEL-To-Unicode-From-String $___charset
        if ($___chars.Length -eq 0) {
                return $___input
        }

        $___content = HestiaKERNEL-Trim-Left-Unicode $___content $___chars
        if ($___content.Length -eq 0) {
                return $___input
        }


        # report status
        return HestiaKERNEL-To-String-From-Unicode $___content
}
