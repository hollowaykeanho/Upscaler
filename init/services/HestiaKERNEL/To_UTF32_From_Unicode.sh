#!/bin/sh
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
. "${LIBS_HESTIA}/HestiaKERNEL/Error_Codes.sh"




HestiaKERNEL_To_UTF32_From_Unicode() {
        #___content="$1"
        #___bom="$2"
        #___endian="$3"


        # validate input
        if [ "$1" = "" ]; then
                printf -- ""
                return $HestiaKERNEL_ERROR_DATA_EMPTY
        fi

        case "$1" in
        *[!0123456789\ \,]*)
                printf -- ""
                return $HestiaKERNEL_ERROR_DATA_INVALID
                ;;
        esac


        # execute
        ___converted=""
        if [ ! "$2" = "" ]; then
                case "$3" in
                "le"|"LE"|"little"|"Little"|"LITTLE")
                        # UTF32LE BOM - 0xFF, 0xFE, 0x00, 0x00
                        ___converted="255, 254, 0, 0"
                        ;;
                *)
                        # UTF32BE BOM (default) - 0x00, 0x00, 0xFE, 0xFF
                        ___converted="0, 0, 254, 255"
                        ;;
                esac
        fi

        ___content="$1"
        while [ ! "$___content" = "" ]; do
                # get current character decimal
                ___char="${___content%%, *}"
                ___content="${___content#"$___char"}"
                if [ "${___content%"${___content#?}"}" = "," ]; then
                        ___content="${___content#, }"
                fi


                # convert to UTF-32 bytes list
                # IMPORTANT NOTICE
                #   (1) using single code-point algorithm (not the 2 16-bits).
                case "$3" in
                "le"|"LE"|"little"|"Little"|"LITTLE")
                        ___register=$(($___char & 0xFF))
                        ___converted="${___converted}$(printf -- "%d" "$___register"), "

                        ___register=$(($___char & 0xFF00))
                        ___register=$(($___char >> 8))
                        ___converted="${___converted}$(printf -- "%d" "$___register"), "

                        ___register=$(($___char & 0xFF0000))
                        ___register=$(($___char >> 16))
                        ___converted="${___converted}$(printf -- "%d" "$___register"), "

                        ___register=$(($___char & 0xFF000000))
                        ___register=$(($___char >> 24))
                        ___converted="${___converted}$(printf -- "%d" "$___register"), "
                        ;;
                *)
                        ___register=$(($___char & 0xFF000000))
                        ___register=$(($___char >> 24))
                        ___converted="${___converted}$(printf -- "%d" "$___register"), "

                        ___register=$(($___char & 0xFF0000))
                        ___register=$(($___char >> 16))
                        ___converted="${___converted}$(printf -- "%d" "$___register"), "

                        ___register=$(($___char & 0xFF00))
                        ___register=$(($___char >> 8))
                        ___converted="${___converted}$(printf -- "%d" "$___register"), "

                        ___register=$(($___char & 0xFF))
                        ___converted="${___converted}$(printf -- "%d" "$___register"), "
                        ;;
                esac
        done


        # report status
        printf -- "%s" "${___converted%, }"
}
