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
. "${LIBS_HESTIA}/HestiaKERNEL/Trim_Left_Unicode.sh"
. "${LIBS_HESTIA}/HestiaKERNEL/To_Unicode_From_String.sh"
. "${LIBS_HESTIA}/HestiaKERNEL/To_String_From_Unicode.sh"




HestiaKERNEL_Trim_Left_String() {
        #___content="$1"
        #___charset="$2"


        # validate input
        if [ "$1" = "" ]; then
                printf -- "%s" "$1"
                return $HestiaKERNEL_ERROR_ENTITY_EMPTY
        fi

        if [ "$2" = "" ]; then
                printf -- "%s" "$1"
                return $HestiaKERNEL_ERROR_DATA_EMPTY
        fi


        # execute
        ___content="$(HestiaKERNEL_To_Unicode_From_String "$1")"
        if [ "$___content" = "" ]; then
                printf -- "%s" "$1"
                return $HestiaKERNEL_ERROR_DATA_INVALID
        fi

        ___chars="$(HestiaKERNEL_To_Unicode_From_String "$2")"
        if [ "$___chars" = "" ]; then
                printf -- "%s" "$1"
                return $HestiaKERNEL_ERROR_DATA_INVALID
        fi

        ___content="$(HestiaKERNEL_Trim_Left_Unicode "$___content" "$___chars")"
        if [ "$___content" = "" ]; then
                printf -- "%s" "$1"
                return $HestiaKERNEL_ERROR_BAD_EXEC
        fi

        ___content="$(HestiaKERNEL_To_String_From_Unicode "$___content")"
        if [ "$___content" = "" ]; then
                printf -- "%s" "$1"
                return $HestiaKERNEL_ERROR_BAD_EXEC
        fi
        printf -- "%s" "$___content"


        # report status
        return $HestiaKERNEL_ERROR_OK
}
