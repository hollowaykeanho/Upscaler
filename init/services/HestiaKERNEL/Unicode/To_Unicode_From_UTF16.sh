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




HestiaKERNEL_To_Unicode_From_UTF16() {
        #___input_content="$1"
        #___input_endian="$2"


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
        ## POSIX Shell does not handle UTF-16 byte stream in an isolated manner
        ## without messing up the current terminal's $LANG settings. To avoid
        ## it, manual implementations are required.
        ##
        ## From the Unicode engineering specification, the default endian is
        ## big-endian.


        # check for data encoder
        ___endian=$HestiaKERNEL_ENDIAN_BIG
        ___ignore=0
        ___output="$(HestiaKERNEL_Is_UTF "$1")"
        if [ ! "${___output#*"$HestiaKERNEL_UTF16LE_BOM"}" = "$___output" ]; then
                # it's UTF16LE with BOM marker
                ___endian=$HestiaKERNEL_ENDIAN_LITTLE
                ___ignore=2
        elif [ ! "${___output#*"$HestiaKERNEL_UTF16BE_BOM"}" = "$___output" ]; then
                # it's UTF16BE with BOM marker
                ___endian=$HestiaKERNEL_ENDIAN_BIG
                ___ignore=2
        elif [ ! "${___output#*"$HestiaKERNEL_UTF16LE"}" = "$___output" ] &&
                [ ! "${___output#*"$HestiaKERNEL_UTF16BE"}" = "$___output" ]; then
                # both UTF16LE or UTF16BE can be a candidate
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
        ___register16=0
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
                1)
                        case "$___endian" in
                        $HestiaKERNEL_ENDIAN_LITTLE)
                                ___byte=$(($___byte << 8))
                                ___char=$(($___char | $___byte))
                                ;;
                        *)
                                ___char=$(($___char | $___byte))
                                ;;
                        esac

                        if [ $___char -ge 56320 ]; then
                                # char > 0xDC00 - 0x10000-0x10FFFF (low surrogate)
                                ___char=$(($___char - 0xDC00))
                                ___char=$(($___char & 0x3FF))

                                # NOTICE
                                # Some encoders do not conform to HIGH-LOW surrogate pair format
                                # (e.g. LOW-HIGH, LOW-?, and ?-HIGH). Hence, to be adaptive, we cage
                                # it conditionally and only output once a pair is perfectly
                                # fulfilled.
                                if [ $___register16 -eq 0 ]; then
                                        ___register16=$(($___register16 + $___char))
                                else
                                        ___register16=$(($___register16 + $___char + 0x10000))
                                        ___converted="${___converted}$(printf -- "%d" "$___register16"), "
                                        ___register16=0
                                fi
                        elif [ $___char -ge 55296 ]; then
                                # char > 0xD800 - 0x10000-0x10FFFF (high surrogate)
                                ___char=$(($___char - 0xD800))
                                ___char=$(($___char & 0x3FF))
                                ___char=$(($___char << 10))

                                # NOTICE
                                # Some encoders do not conform to HIGH-LOW surrogate pair format
                                # (e.g. LOW-HIGH, LOW-?, and ?-HIGH). Hence, to be adaptive, we cage
                                # it conditionally and only output once a pair is perfectly
                                # fulfilled.
                                if [ $___register16 -eq 0 ]; then
                                        ___register16=$(($___register16 + $___char))
                                else
                                        ___register16=$(($___register16 + $___char + 0x10000))
                                        ___converted="${___converted}$(printf -- "%d" "$___register16"), "
                                        ___register16=0
                                fi
                        else
                                # char < 0x10000

                                # NOTICE
                                # Some encoders do not conform to HIGH-LOW surrogate pair format
                                # (e.g. LOW-HIGH, LOW-?, and ?-HIGH). Hence, to be adaptive, we cage
                                # it conditionally and only output once a pair is perfectly
                                # fulfilled.
                                if [ $___register16 -ne 0 ]; then
                                        # ERROR - expect surrogate pair; got char
                                        printf -- ""
                                        return $HestiaKERNEL_ERROR_DATA_BAD
                                fi

                                ___converted="${___converted}$(printf -- "%d" "$___char"), "
                        fi

                        ___state=0
                        ;;
                *)
                        case "$___endian" in
                        $HestiaKERNEL_ENDIAN_LITTLE)
                                ___char=$___byte
                                ;;
                        *)
                                ___char=$(($___byte << 8))
                                ;;
                        esac

                        ___state=1
                        ;;
                esac
        done


        # report status
        printf -- "%s" "${___converted%, }"
}
