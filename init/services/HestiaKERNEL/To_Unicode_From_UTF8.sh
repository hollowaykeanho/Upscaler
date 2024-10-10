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
. "${LIBS_HESTIA}/HestiaKERNEL/Is_UTF.sh"
. "${LIBS_HESTIA}/HestiaKERNEL/Unicode.sh"




HestiaKERNEL_To_Unicode_From_UTF8() {
        #___bytes_array="$1"


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
        ## IMPORTANT NOTICE
        ## POSIX Shell does not handle UTF-8 byte stream in an isolated manner
        ## without messing up the current terminal's $LANG settings. To avoid
        ## it, manual implementations are required.


        # check for data encoder
        ___ignore=0
        ___output="$(HestiaKERNEL_Is_UTF "$1")"
        if [ ! "${___output#*"$HestiaKERNEL_UTF8_BOM"}" = "$___output" ]; then
                # it's UTF8 with BOM marker
                ___ignore=3
        elif [ ! "${___output#*"$HestiaKERNEL_UTF8"}" = "$___output" ]; then
                : # UTF8 is a candidate - try to convert
        else
                # unsupported decoders
                printf -- ""
                return $HestiaKERNEL_ERROR_DATA_INVALID
        fi

        ___content="$1"
        ___converted=""
        ___char=0
        ___state=0
        while [ ! "$___content" = "" ]; do
                # ignore BOM markers
                if [ $___ignore -gt 0 ]; then
                        ___ignore=$(($___ignore - 1))
                        continue
                fi


                # get current character decimal
                ___byte="${___content%%, *}"
                ___content="${___content#"$___byte"}"
                if [ "${___content%"${___content#?}"}" = "," ]; then
                        ___content="${___content#, }"
                fi


                # identify initial state
                if [ $___state -ne 0 ]; then
                        : # it's a tailing operation - DO NOTHING
                elif [ $___byte -lt 200 ]; then
                        # x < 0x80 (char < 0x80)
                        ___state=0
                elif [ $___byte -gt 193 ] && [ $___byte -lt 200 ]; then
                        # 0xBF < x < 0xE0 (char < 0x800)
                        ___state=1
                elif [ $___byte -gt 223 ] && [ $___byte -lt 240 ]; then
                        # 0xDF < x < 0xF0 (char < 0x10000)
                        ___state=3
                else
                        # 0x10000-0x10FFFF (surrogate pair)
                        ___state=6
                fi

                case "$___state" in
                9)
                        ___byte=$(($___byte & 0x3F))
                        ___char=$(($___char | $___byte))
                        ___converted="${___converted}$(printf -- "%d" "$___char"), "

                        ___state=0
                        ;;
                8)
                        ___byte=$(($___byte & 0x3F))
                        ___byte=$(($___byte << 6))
                        ___char=$(($___char | $___byte))

                        ___state=9
                        ;;
                7)
                        ___byte=$(($___byte & 0x3F))
                        ___byte=$(($___byte << 12))
                        ___char=$(($___char | $___byte))

                        ___state=8
                        ;;
                6)
                        # 0x10000-0x10FFFF (surrogate pair)
                        ___byte=$(($___byte & 0x07))
                        ___char=$(($___byte << 18))

                        ___state=7
                        ;;
                5)
                        ___byte=$(($___byte & 0x3F))
                        ___char=$(($___char | $___byte))
                        ___converted="${___converted}$(printf -- "%d" "$___char"), "

                        ___state=0
                        ;;
                4)
                        ___byte=$(($___byte & 0x3F))
                        ___byte=$(($___byte << 6))
                        ___char=$(($___char | $___byte))

                        ___state=5
                        ;;
                3)
                        # 0xDF < x < 0xF0 (char < 0x10000)
                        ___byte=$(($___byte & 0x0F))
                        ___char=$(($___byte << 12))

                        ___state=4
                        ;;
                2)
                        ___byte=$(($___byte & 0x3F))
                        ___char=$(($___char | $___byte))
                        ___converted="${___converted}$(printf -- "%d" "$___char"), "

                        ___state=0
                        ;;
                1)
                        # 0xBF < x < 0xE0 (char < 0x800)
                        ___byte=$(($___byte & 0x1F))
                        ___char=$(($___byte << 6))

                        ___state=2
                        ;;
                *)
                        # x < 0x80 (char < 0x80)
                        ___converted="${___converted}$(printf -- "%d" "$___byte"), "

                        ___state=0
                        ;;
                esac
        done


        # report status
        printf -- "%s" "${___converted%, }"
}
