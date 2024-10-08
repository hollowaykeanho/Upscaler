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
. "${LIBS_HESTIA}/HestiaKERNEL/Get_String_Encoder.sh"
. "${LIBS_HESTIA}/HestiaKERNEL/Is_Unicode.sh"
. "${LIBS_HESTIA}/HestiaKERNEL/To_UTF8_From_Unicode.sh"
. "${LIBS_HESTIA}/HestiaKERNEL/To_UTF16_From_Unicode.sh"
. "${LIBS_HESTIA}/HestiaKERNEL/To_UTF32_From_Unicode.sh"
. "${LIBS_HESTIA}/HestiaKERNEL/Unicode.sh"




HestiaKERNEL_To_String_From_Unicode() {
        #___unicode="$1"


        # validate input
        if [ $(HestiaKERNEL_Is_Unicode "$1") -ne "$HestiaKERNEL_ERROR_OK" ]; then
                printf -- ""
                return $HestiaKERNEL_ERROR_DATA_INVALID
        fi


        # execute
        # process HestiaKERNEL.Unicode data type
        ___utf=""
        case "$(HestiaKERNEL_Get_String_Encoder)" in
        "$HestiaKERNEL_UTF8")
                ___utf="$(HestiaKERNEL_To_UTF8_From_Unicode "$1")"
                ;;
        "$HestiaKERNEL_UTF16BE")
                ___utf="$(HestiaKERNEL_To_UTF16_From_Unicode "$1")"
                ;;
        "$HestiaKERNEL_UTF32BE")
                ___utf="$(HestiaKERNEL_To_UTF32_From_Unicode "$1")"
                ;;
        *)
                printf -- ""
                return $HestiaKERNEL_ERROR_NOT_POSSIBLE
                ;;
        esac

        if [ "$___utf" = "" ]; then
                printf -- ""
                return $HestiaKERNEL_ERROR_DATA_INVALID
        fi

        ___converted=""
        while [ ! "$___utf" = "" ]; do
                ___byte="${___utf%%, *}"
                ___converted="${___converted}$(printf -- '\%o' "$___byte")"
                ___utf="${___utf#"$___byte"}"
                if [ "${___utf%"${___utf#?}"}" = "," ]; then
                        ___utf="${___utf#, }"
                fi
        done


        # report status
        printf -- "%b" "$___converted"
        return $HestiaKERNEL_ERROR_OK
}
