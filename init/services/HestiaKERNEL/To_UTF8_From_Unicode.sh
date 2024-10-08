#!/bin/sh
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
. "${LIBS_HESTIA}/HestiaKERNEL/Error_Codes.sh"
. "${LIBS_HESTIA}/HestiaKERNEL/Is_Unicode.sh"
. "${LIBS_HESTIA}/HestiaKERNEL/Unicode.sh"




HestiaKERNEL_To_UTF8_From_Unicode() {
        #___unicode="$1"
        #___bom="$2"


        # validate input
        if [ "$(HestiaKERNEL_Is_Unicode "$1")" -ne $HestiaKERNEL_ERROR_OK ]; then
                printf -- ""
                return $HestiaKERNEL_ERROR_DATA_INVALID
        fi


        # execute
        ___converted=""
        if [ "$2" = "$HestiaKERNEL_UTF_BOM" ]; then
                # UTF-8 BOM - 0xEF, 0xBB, 0xBF
                ___converted="239, 187, 191"
        fi

        ___content="$1"
        while [ ! "$___content" = "" ]; do
                # get current character decimal
                ___char="${___content%%, *}"
                ___content="${___content#"$___char"}"
                if [ "${___content%"${___content#?}"}" = "," ]; then
                        ___content="${___content#, }"
                fi


                # convert to UTF-8 bytes list
                # IMPORTANT NOTICE
                #   (1) using single code-point algorithm (not the 2 16-bits).
                if [ $___char -lt 200 ]; then
                        # char < 0x80
                        ___converted="${___converted}$(printf -- "%d" "$___char"), "
                elif [ $___char -lt 4000 ]; then
                        # char < 0x800
                        ___register=$(($___char >> 6))
                        ___register=$(($___register & 0x1F))
                        ___register=$(($___register | 0xC0))
                        ___converted="${___converted}$(printf -- "%d" "$___register"), "

                        ___register=$(($___char & 0x3F))
                        ___register=$(($___register | 0x80))
                        ___converted="${___converted}$(printf -- "%d" "$___register"), "
                elif [ $___char -lt 200000 ]; then
                        # char < 0x10000
                        ___register=$(($___char >> 12))
                        ___register=$(($___register & 0x0F))
                        ___register=$(($___register | 0xE0))
                        ___converted="${___converted}$(printf -- "%d" "$___register"), "

                        ___register=$(($___char >> 6))
                        ___register=$(($___register & 0x3F))
                        ___register=$(($___register | 0x80))
                        ___converted="${___converted}$(printf -- "%d" "$___register"), "

                        ___register=$(($___char & 0x3F))
                        ___register=$(($___register | 0x80))
                        ___converted="${___converted}$(printf -- "%d" "$___register"), "
                else
                        # >0x10000 - 0x10000-0x10FFFF (surrogate pair)
                        ___register=$(($___char >> 18))
                        ___register=$(($___register & 0x07))
                        ___register=$(($___register | 0xF0))
                        ___converted="${___converted}$(printf -- "%d" "$___register"), "

                        ___register=$(($___char >> 12))
                        ___register=$(($___register & 0x3F))
                        ___register=$(($___register | 0x80))
                        ___converted="${___converted}$(printf -- "%d" "$___register"), "

                        ___register=$(($___char >> 6))
                        ___register=$(($___register & 0x3F))
                        ___register=$(($___register | 0x80))
                        ___converted="${___converted}$(printf -- "%d" "$___register"), "

                        ___register=$(($___char & 0x3F))
                        ___register=$(($___register | 0x80))
                        ___converted="${___converted}$(printf -- "%d" "$___register"), "
                fi
        done


        # report status
        printf -- "%s" "${___converted%, }"
}
