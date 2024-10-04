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
. "${env:LIBS_HESTIA}\HestiaKERNEL\Is_Unicode.ps1"
. "${env:LIBS_HESTIA}\HestiaKERNEL\Unicode.ps1"




function HestiaKERNEL-To-Unicode-From-String {
        param (
                [string]$___content
        )


        # validate input
        if ($___content -eq "") {
                return [uint32[]]@()
        }


        # execute
        # check for data encoder
        $___output = HestiaSTRING-Is-Unicode $___content
        if (
                ($($___output -replace ${env:HestiaKERNEL_UTF8}, '') -ne $___output) -or
                ($($___output -replace ${env:HestiaKERNEL_UTF8_BOM}, '') -ne $___output) -or
                ($($___output -replace ${env:HestiaKERNEL_UTF16BE}, '') -ne $___output) -or
                ($($___output -replace ${env:HestiaKERNEL_UTF16BE_BOM}, '') -ne $___output) -or
                ($($___output -replace ${env:HestiaKERNEL_UTF16LE}, '') -ne $___output) -or
                ($($___output -replace ${env:HestiaKERNEL_UTF16LE_BOM}, '') -ne $___output) -or
                ($($___output -replace ${env:HestiaKERNEL_UTF32BE}, '') -ne $___output) -or
                ($($___output -replace ${env:HestiaKERNEL_UTF32BE_BOM}, '') -ne $___output) -or
                ($($___output -replace ${env:HestiaKERNEL_UTF32LE}, '') -ne $___output) -or
                ($($___output -replace ${env:HestiaKERNEL_UTF32LE_BOM}, '') -ne $___output)
        ) {
                # UTF8, UTF16, and UTF32 are the candidates - try to parse
        } else {
                # unsupported decoders
                return [uint32[]]@()
        }


        # begin parsing data
        # PowerShell is operating on UTF16 and it has a good string library. All
        # it need is converting into Unicode data type and it should be
        # sufficient for other operations.
        [System.Collections.Generic.List[uint32]]$___converted = @()
        while ($___content -ne "") {
                # get byte value
                $___byte = $___content[0]
                $___content = $___content.Substring(1)
                $___byte = [uint32]$___byte[0]


                # save to output
                $null = $___converted.Add($___byte)
        }


        # report status
        return [uint32[]]$___converted
}
