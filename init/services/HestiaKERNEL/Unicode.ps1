# Copyright (c) 2024, (Holloway) Chew, Kean Ho <hello@hollowaykeanho.com>
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




# Data type
class String {
        [uint32[]] $Runes
}




# UTF encoding type
${env:HestiaKERNEL_UTF8} = 0
${env:HestiaKERNEL_UTF8_BOM} = 1
${env:HestiaKERNEL_UTF16BE} = 2
${env:HestiaKERNEL_UTF16BE_BOM} = 3
${env:HestiaKERNEL_UTF16LE} = 4
${env:HestiaKERNEL_UTF16LE_BOM} = 5
${env:HestiaKERNEL_UTF32BE} = 6
${env:HestiaKERNEL_UTF32BE_BOM} = 7
${env:HestiaKERNEL_UTF32LE} = 8
${env:HestiaKERNEL_UTF32LE_BOM} = 9
