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
. "${LIBS_HESTIA}/HestiaKERNEL/Is_Unicode.sh"
. "${LIBS_HESTIA}/HestiaKERNEL/Unicode.sh"




HestiaKERNEL_To_Unicode_From_String() {
        #___content="$1"


        # validate input
        if [ "$1" = "" ]; then
                printf -- ""
                return $HestiaKERNEL_ERROR_DATA_EMPTY
        fi


        # execute
        # POSIX Shell does not handle any character beyond Latin-1 script.
        # Hence, most of its string operation only works for ASCII character
        # (<127). While it's not a problem for BASH; it is for
        # non-BASH environment.
        #
        # Therefore, manual implementations are required.


        # check for data encoder
        ___output="$(HestiaKERNEL_Is_Unicode "$1")"
        if [ ! "${___output#*"$HestiaKERNEL_UTF8"}" = "$___output" ] ||
                [ ! "${___output#*"$HestiaKERNEL_UTF8_BOM"}" = "$___output" ] ||
                [ ! "${___output#*"$HestiaKERNEL_UTF16BE"}" = "$___output" ] ||
                [ ! "${___output#*"$HestiaKERNEL_UTF16BE_BOM"}" = "$___output" ] ||
                [ ! "${___output#*"$HestiaKERNEL_UTF16LE"}" = "$___output" ] ||
                [ ! "${___output#*"$HestiaKERNEL_UTF16LE_BOM"}" = "$___output" ] ||
                [ ! "${___output#*"$HestiaKERNEL_UTF32BE"}" = "$___output" ] ||
                [ ! "${___output#*"$HestiaKERNEL_UTF32BE_BOM"}" = "$___output" ] ||
                [ ! "${___output#*"$HestiaKERNEL_UTF32LE"}" = "$___output" ] ||
                [ ! "${___output#*"$HestiaKERNEL_UTF32LE_BOM"}" = "$___output" ]; then
                : # UTF8, UTF16, and UTF32 are the candidates - try to parse
        else
                # unsupported decoders
                printf -- ""
                return $HestiaKERNEL_ERROR_DATA_INVALID
        fi


        # begin parsing data
        ___output=""
        ___content="$1"
        while [ ! "$___content" = "" ]; do
                # get byte value
                ___byte="${___content%"${___content#?}"}"
                ___content="${___content#${___byte}}"

                ## NOTICE
                ## POSIX Shell splits control characters as 2 characters
                ## instead of 1 (e.g. '\n' -> '\', 'n'). Hence, let's handle it
                ## explictly. More info:
                ##      https://pubs.opengroup.org/onlinepubs/9699919799/basedefs/V1_chap06.html
                if [ "$___byte" = '\' ]; then
                        # extract 1 more to get a full character
                        ___byte="${___content%"${___content#?}"}"
                        ___content="${___content#"$___byte"}"
                        case "${___byte:-\\}" in
                        "0")
                                # '\0' null <NUL>
                                ___byte=0
                                ;;
                        "a")
                                # '\a' alert <BEL>
                                ___byte=7
                                ;;
                        "b")
                                # '\b' backspace <BS>
                                ___byte=8
                                ;;
                        "t")
                                # '\t' tab <HT>
                                ___byte=9
                                ;;
                        "n")
                                # '\n' newline <LF>
                                ___byte=10
                                ;;
                        "v")
                                # '\v' vertical-tab <VT>
                                ___byte=11
                                ;;
                        "f")
                                # '\f' form-feed <FF>
                                ___byte=12
                                ;;
                        "r")
                                # '\r' carriage-return <CR>
                                ___byte=13
                                ;;
                        "e"|"E")
                                # '\e' or '\E' escape <ESC>
                                ___byte=27
                                ;;
                        *)
                                # cancelled character - go for the next instead
                                ___byte="$(printf -- "%d" "'${___byte}")"
                                ;;
                        esac
                else
                        ___byte="$(printf -- "%d" "'${___byte}")"
                fi


                # save to output
                ___output="${___output}${___byte}, "
        done
        printf -- "%s" "${___output%, }"


        # report status
        return $HestiaKERNEL_ERROR_OK
}
