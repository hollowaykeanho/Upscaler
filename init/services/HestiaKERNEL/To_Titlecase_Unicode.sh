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
. "${LIBS_HESTIA}/HestiaKERNEL/rune_to_title.sh"

. "${LIBS_HESTIA}/HestiaKERNEL/Error_Codes.sh"
. "${LIBS_HESTIA}/HestiaKERNEL/Is_Unicode.sh"
. "${LIBS_HESTIA}/HestiaKERNEL/Is_Whitespace_Unicode.sh"




HestiaKERNEL_To_Titlecase_Unicode() {
        #___unicode="$1"
        #___locale="$2"


        # execute
        if [ $(HestiaKERNEL_Is_Unicode "$1") -ne $HestiaKERNEL_ERROR_OK ]; then
                printf -- "%s" "$1"
                return $HestiaKERNEL_ERROR_DATA_INVALID
        fi

        ___content="$1"
        ___converted=""
        ___to_title="true"
        while [ ! "$___content" = "" ]; do
                # get current character
                ___current="${___content%%, *}"
                ___content="${___content#"$___current"}"
                if [ "${___content%"${___content#?}"}" = "," ]; then
                        ___content="${___content#, }"
                fi


                # filter whitespace for titlecasing trigger
                if [ $(HestiaKERNEL_Is_Whitespace_Unicode "$___current") -eq $HestiaKERNEL_ERROR_OK ] &&
                        [ ! "$___converted" = "" ]; then
                        ___to_title="true"
                        ___converted="${___converted}${___current}, "
                        continue
                fi


                # get next character (look forward by 1)
                ___next=0
                if [ ! "$___content" = "" ]; then
                        ___next="${___content%%, *}"
                fi


                # get third character (look forward by 2)
                ___third="${___content#${___next}}"
                if [ ! "$___third" = "" ]; then
                        if [ "${___third%"${___third#?}"}" = "," ]; then
                                ___third="${___third#, }"
                        fi

                        ___third="${___third#, }"
                        if [ "$___third" = "" ]; then
                                ___third=0
                        fi
                else
                        ___third=0
                fi


                # proceed to default conversion
                ___ret="$(hestiakernel_rune_to_title \
                        "$___current" \
                        "$___next" \
                        "$___third" \
                        "$___to_title" \
                        "$2" \
                )"
                ___scanned="${___ret%%]*}"
                ___converted="${___converted}${___ret#*]}, "


                # prepare for next scan
                ___to_title=""
                ___scanned="${___scanned#[}"
                while [ $___scanned -gt 1 ]; do
                        if [ "$___content" = "" ]; then
                                break
                        fi

                        ___current="${___content%%, *}"
                        ___content="${___content#"$___current"}"
                        if [ "${___content%"${___content#?}"}" = "," ]; then
                                ___content="${___content#, }"
                        fi

                        ___scanned=$(($___scanned - 1))
                done
        done


        # report status
        printf -- "%s" "${___converted%, }"
        return $HestiaKERNEL_ERROR_OK
}
