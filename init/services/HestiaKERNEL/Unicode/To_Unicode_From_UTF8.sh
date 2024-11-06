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
. "${LIBS_HESTIA}/HestiaKERNEL/List/Is_Array_Byte.sh"
. "${LIBS_HESTIA}/HestiaKERNEL/OS/Endian.sh"
. "${LIBS_HESTIA}/HestiaKERNEL/Unicode/Is_UTF.sh"
. "${LIBS_HESTIA}/HestiaKERNEL/Unicode/Unicode.sh"




HestiaKERNEL_To_Unicode_From_UTF8() {
        #___input_content="$1"


        # validate input
        if [ "$1" = "" ]; then
                printf -- ""
                return $HestiaKERNEL_ERROR_DATA_EMPTY
        fi

        if [ "$(HestiaKERNEL_Is_Array_Byte "$1")" -ne $HestiaKERNEL_ERROR_OK ]; then
                printf -- ""
                return $HestiaKERNEL_ERROR_DATA_INVALID
        fi


        # execute
        ## IMPORTANT NOTICE
        ## POSIX Shell does not handle UTF-8 byte stream in an isolated manner
        ## without messing up the current terminal's $LANG settings. To avoid
        ## it, manual implementations are required.
        ##
        ## From the Unicode engineering specification, the default endian is
        ## big-endian.


        # check for data encoder
        ___endian=$HestiaKERNEL_ENDIAN_BIG
        ___ignore=0
        ___output="$(HestiaKERNEL_Is_UTF "$1")"
        if [ ! "${___output#*"$HestiaKERNEL_UTF8_BOM"}" = "$___output" ]; then
                # it's UTF8 with BOM marker
                ___ignore=3
        elif [ ! "${___output#*"$HestiaKERNEL_UTF8"}" = "$___output" ]; then
                : # UTF8 is a candidate
        else
                # not a UTF byte array
                printf -- ""
                return $HestiaKERNEL_ERROR_DATA_INVALID
        fi

        ___content="$1"
        ___converted=""
        ___char=0
        ___state=0
        while [ ! "$___content" = "" ]; do
                # get current byte
                ___byte="${___content%%, *}"
                ___content="${___content#"$___byte"}"
                if [ "${___content%"${___content#?}"}" = "," ]; then
                        ___content="${___content#, }"
                fi


                # ignore BOM markers
                if [ $___ignore -gt 0 ]; then
                        ___ignore=$(($___ignore - 1))
                        continue
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
