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
. "${LIBS_HESTIA}/HestiaKERNEL/Unicode.sh"




HestiaKERNEL_Is_Unicode() {
        #___content="$1"



        # validate input
        if [ "$1" = "" ]; then
                printf -- ""
                return $HestiaKERNEL_ERROR_DATA_EMPTY
        fi


        # execute - based on https://www.unicode.org/versions/Unicode15.1.0/ch03.pdf
        # check for BOM markers and UTF8
        ___content="$1"
        ___count=8
        ___utf8_expect=0
        ___utf32_expect=$((${#1} % 4))
        ___byte_0=""
        ___byte_1=""
        ___byte_2=""
        ___byte_3=""
        while [ $___count -gt 0 ]; do
                if [ "$___content" = "" ]; then
                        break
                fi


                # get current byte ($___content[0])
                ___byte="${___content%"${___content%?}"}"
                ___content="${___content#${___byte}}"

                ## NOTICE
                ## POSIX Shell splits control characters as 2 characters rather
                ## than 1 (e.g. '\n' -> '\', 'n'). Hence, let's handle it. More
                ## info:
                ## (1) https://pubs.opengroup.org/onlinepubs/9699919799/basedefs/V1_chap06.html
                if [ "$___byte" = '\' ]; then
                        # extract 1 more to get a full character
                        ___byte="${___content%"${___content%?}"}"
                        ___content="${___content#"$___byte"}"

                        case "$___byte" in
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


                # save to sample positions for BOM analysis
                case "$___count" in
                6)
                        ___byte_0="$___byte"
                        ;;
                5)
                        ___byte_1="$___byte"
                        ;;
                4)
                        ___byte_2="$___byte"
                        ;;
                3)
                        ___byte_3="$___byte"
                        ;;
                *)
                        ;;
                esac


                # scan UTF-8 header for its validity
                if [ $___utf8_expect -le 0 ]; then
                        : # it is already identified invalid - do nothing
                elif [ $(($___byte & 0xF8)) -eq 240 ]; then
                        # 11110xxx header
                        if [ $___utf8_expect -ne 0 ]; then
                                ___utf8_expect=-1 # expect tailing byte; got new entry
                        else
                                ___utf8_expect=3
                        fi
                elif [ $(($___byte & 0xE0)) -eq 224 ]; then
                        # 1110xxxx header
                        if [ $___utf8_expect -ne 0 ]; then
                                ___utf8_expect=-1 # expect tailing byte; got new entry
                        else
                                ___utf8_expect=2
                        fi
                elif [ $(($___byte & 0xE0)) -eq 192 ]; then
                        # 110xxxxx header
                        if [ $___utf8_expect -ne 0 ]; then
                                ___utf8_expect=-1 # expect tailing byte; got new entry
                        else
                                ___utf8_expect=1
                        fi
                elif [ $(($___byte & 0xC0)) -eq 128 ]; then
                        # 10xxxxxx header
                        if [ $___utf8_expect -le 0 ]; then
                                ___utf8_expect=-1  # unexpected tailing byte
                        else
                                ___utf8_expect=$(($___utf8_expect - 1))
                        fi
                elif [ $(($___byte & 0x80)) -eq 0 ]; then
                        # 0xxxxxxx header
                        if [ $___utf8_expect -gt 0 ]; then
                                ___utf8_expect=-1 # expecting tailing character byte; got Latin-1
                        else
                                ___utf8_expect=0 # it's a Latin-1 character (<= 0x7F)
                        fi
                else
                        # invalid UTF8 - all bytes **MUST** comply to the headers
                        ___utf8_expect=-1
                fi


                # prepare for next scan
                ___count=$(($___count - 1))
        done


        # scan for BOM
        if [ ! "$___byte_0" = "" ] &&
                [ ! "$___byte_1" = "" ] &&
                [ ! "$___byte_2" = "" ] &&
                [ ! "$___byte_3" = "" ]; then
                if [ $___byte_0 -eq 255 ] &&
                        [ $___byte_1 -eq 254 ] &&
                        [ $___byte_2 -eq 0 ] &&
                        [ $___byte_3 -eq 0 ]; then
                        # it's UTF32LE_BOM
                        printf -- "%b" "$HestiaKERNEL_UTF32LE_BOM"
                        return $HestiaKERNEL_ERROR_OK
                elif [ $___byte_0 -eq 0 ] &&
                        [ $___byte_1 -eq 0 ] &&
                        [ $___byte_2 -eq 254 ] &&
                        [ $___byte_3 -eq 255 ]; then
                        # it's UTF32BE_BOM
                        printf -- "%b" "$HestiaKERNEL_UTF32BE_BOM"
                        return $HestiaKERNEL_ERROR_OK
                fi
        elif [ ! "$___byte_0" = "" ] && [ ! "$___byte_1" = "" ] && [ ! "$___byte_2" = "" ]; then
                if [ $___byte_0 -eq 239 ] && [ $___byte_1 = 187 ] && [ $___byte_2 = 191 ]; then
                        # it's UTF8_BOM
                        printf -- "%b" "$HestiaKERNEL_UTF8_BOM"
                        return $HestiaKERNEL_ERROR_OK
                fi
        elif [ ! "$___byte_0" = "" ] && [ ! "$___byte_1" = "" ]; then
                if [ $___byte_0 -eq 255 ] && [ $___byte_1 -eq 254 ]; then
                        # it's UTF16LE_BOM
                        printf -- "%b" "$HestiaKERNEL_UTF16LE_BOM"
                        return $HestiaKERNEL_ERROR_OK
                elif [ $___byte_0 -eq 254 ] && [ $___byte_1 -eq 255 ]; then
                        # it's UTF16BE_BOM
                        printf -- "%b" "$HestiaKERNEL_UTF32BE_BOM"
                        return $HestiaKERNEL_ERROR_OK
                fi
        fi


        # arrange for possible permutations
        ___output="\
${HestiaKERNEL_UTF16LE}
${HestiaKERNEL_UTF16BE}
"
        if [ $___utf8_expect -ge 0 ]; then
                # NOTICE
                # there is a chance of 6 Latin-1 characters in a straight chain
                # which will make the scanner producing false positive. Hence,
                # let's not assume the scanner is guarenteed correct.
                #
                # Engineering specification specified that user is the one that
                # provides the type, not auto-detect without BOM marker.
                ___output="\
${HestiaKERNEL_UTF8}
${___output}"
        fi

        if [ $___utf32_expect -eq 0 ]; then
                ___output="\
${___output}
${HestiaKERNEL_UTF32BE}
${HestiaKERNEL_UTF32LE}
"
        fi


        # report status
        printf -- "%b" "$___output"
        return $HestiaKERNEL_ERROR_OK
}
