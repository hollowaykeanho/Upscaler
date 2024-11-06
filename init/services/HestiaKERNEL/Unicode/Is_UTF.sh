#!/bin/sh
# Copyright 2024 (Holloway) Chew, Kean Ho <hello@hollowaykeanho.com>
#
#
# Licensed under (Holloway) Chew, Kean Ho’s Liberal License (the "License").
# You must comply with the license to use the content. Get the License at:
#
#                 https://doi.org/10.5281/zenodo.13770769
#
# You MUST ensure any interaction with the content STRICTLY COMPLIES with
# the permissions and limitations set forth in the license.
. "${LIBS_HESTIA}/HestiaKERNEL/Errors/Error_Codes.sh"
. "${LIBS_HESTIA}/HestiaKERNEL/Unicode/Unicode.sh"




HestiaKERNEL_Is_UTF() {
        #___byte_array="$1"


        # validate input
        if [ "$1" = "" ]; then
                printf -- ""
                return $HestiaKERNEL_ERROR_DATA_EMPTY
        fi


        # extract BOM markers
        ___content="$1"
        ___count=8
        ___utf8_expect=0
        ___utf32_expect=0
        ___byte_0=""
        ___byte_1=""
        ___byte_2=""
        ___byte_3=""
        while [ $___count -gt 0 ]; do
                if [ "$___content" = "" ]; then
                        break
                fi


                # get current byte ($___content[0])
                ___byte="${___content%%, *}"
                ___content="${___content#${___byte}}"
                if [ "${___content%"${___content#?}"}" = "," ]; then
                        ___content="${___content#, }"
                fi


                # save to sample positions for BOM analysis
                case "$___count" in
                8)
                        ___byte_0="$___byte"
                        ;;
                7)
                        ___byte_1="$___byte"
                        ;;
                6)
                        ___byte_2="$___byte"
                        ;;
                5)
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


                # detect UTF-32 for later guessing
                if [ $___count -le 4 ]; then
                        ___utf32_expect=1
                fi


                # prepare for next scan
                ___count=$(($___count - 1))
        done


        # scan for BOM
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
        elif [ $___byte_0 -eq 239 ] &&
                [ $___byte_1 = 187 ] &&
                [ $___byte_2 = 191 ]; then
                # it's UTF8_BOM
                printf -- "%b" "$HestiaKERNEL_UTF8_BOM"
                return $HestiaKERNEL_ERROR_OK
        elif [ $___byte_0 -eq 255 ] && [ $___byte_1 -eq 254 ]; then
                # it's UTF16LE_BOM
                printf -- "%b" "$HestiaKERNEL_UTF16LE_BOM"
                return $HestiaKERNEL_ERROR_OK
        elif [ $___byte_0 -eq 254 ] && [ $___byte_1 -eq 255 ]; then
                # it's UTF16BE_BOM
                printf -- "%b" "$HestiaKERNEL_UTF16BE_BOM"
                return $HestiaKERNEL_ERROR_OK
        fi


        # no BOM markers - arrange for possible permutations
        ___output="\
${HestiaKERNEL_UTF16LE}
${HestiaKERNEL_UTF16BE}
"
        if [ $___utf8_expect -ge 0 ]; then
                # IMPORTANT NOTICE
                # there is a chance of 6 Latin-1 characters in a straight chain
                # that makes the scanner produce false positive. Hence, let's
                # not assume the scanner is guarenteed correct.
                #
                # Moreover, engineering specification specified that user is
                # the one providing the type, not auto-detection without
                # BOM marker.
                ___output="\
${HestiaKERNEL_UTF8}
${___output}"
        fi

        if [ $___utf32_expect -gt 0 ]; then
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
