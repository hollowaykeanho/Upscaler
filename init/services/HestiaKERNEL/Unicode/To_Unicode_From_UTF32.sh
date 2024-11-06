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




HestiaKERNEL_To_Unicode_From_UTF32() {
        #___input_content="$1"
        #___input_endian="$2"


        # validate input
        if [ "$1" = "" ]; then
                printf -- ""
                return $HestiaKERNEL_ERROR_DATA_EMPTY
        fi

        if [ $(HestiaKERNEL_Is_Array_Byte "$1") -ne $HestiaKERNEL_ERROR_OK ]; then
                printf -- ""
                return $HestiaKERNEL_ERROR_DATA_INVALID
        fi


        # execute
        ## IMPORTANT NOTICE
        ## POSIX Shell does not handle UTF-32 byte stream in an isolated manner
        ## without messing up the current terminal's $LANG settings. To avoid
        ## it, manual implementations are required.
        ##
        ## From the Unicode engineering specification, the default endian is
        ## big-endian.


        # check for data encoder
        ___endian=$HestiaKERNEL_ENDIAN_BIG
        ___ignore=0
        ___output="$(HestiaKERNEL_Is_UTF "$1")"
        if [ ! "${___output#*"$HestiaKERNEL_UTF32LE_BOM"}" = "$___output" ]; then
                # it's UTF32LE with BOM marker
                ___endian=$HestiaKERNEL_ENDIAN_LITTLE
                ___ignore=4
        elif [ ! "${___output#*"$HestiaKERNEL_UTF32BE_BOM"}" = "$___output" ]; then
                # it's UTF32BE with BOM marker
                ___endian=$HestiaKERNEL_ENDIAN_BIG
                ___ignore=4
        elif [ ! "${___output#*"$HestiaKERNEL_UTF32LE"}" = "$___output" ] &&
                [ ! "${___output#*"$HestiaKERNEL_UTF32BE"}" = "$___output" ]; then
                # both UTF32LE or UTF32BE can be a candidate
                if [ "$2" = "$HestiaKERNEL_ENDIAN_LITTLE" ] ||
                        [ "$2" = "$HestiaKERNEL_ENDIAN_BIG" ]; then
                        ___endian="$2" # If there is a valid hint, take the hint
                else
                        : # keep the default
                fi
        else
                # not a UTF byte array
                printf -- ""
                return $HestiaKERNEL_ERROR_DATA_INVALID
        fi


        # process to unicode
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


                # process byte data serially
                case "$___state" in
                3)
                        case "$___endian" in
                        $HestiaKERNEL_ENDIAN_LITTLE)
                                ___byte=$(($___byte << 24))
                                ___char=$(($___char | $___byte))
                                ;;
                        *)
                                ___char=$(($___char | $___byte))
                                ;;
                        esac
                        ___converted="${___converted}$(printf -- "%d" "$___char"), "

                        ___state=0
                        ;;
                2)
                        case "$___endian" in
                        $HestiaKERNEL_ENDIAN_LITTLE)
                                ___byte=$(($___byte << 16))
                                ___char=$(($___char | $___byte))
                                ;;
                        *)
                                ___byte=$(($___byte << 8))
                                ___char=$(($___char | $___byte))
                                ;;
                        esac

                        ___state=3
                        ;;
                1)
                        case "$___endian" in
                        $HestiaKERNEL_ENDIAN_LITTLE)
                                ___byte=$(($___byte << 8))
                                ___char=$(($___char | $___byte))
                                ;;
                        *)
                                ___byte=$(($___byte << 16))
                                ___char=$(($___char | $___byte))
                                ;;
                        esac

                        ___state=2
                        ;;
                *)
                        case "$___endian" in
                        $HestiaKERNEL_ENDIAN_LITTLE)
                                ___char=$___byte
                                ;;
                        *)
                                ___char=$(($___byte << 24))
                                ;;
                        esac

                        ___state=1
                        ;;
                esac
        done


        # report status
        printf -- "%s" "${___converted%, }"
        return $HestiaKERNEL_ERROR_OK
}
