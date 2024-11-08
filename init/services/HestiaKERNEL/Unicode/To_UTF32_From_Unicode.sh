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
. "${LIBS_HESTIA}/HestiaKERNEL/OS/Endian.sh"
. "${LIBS_HESTIA}/HestiaKERNEL/Unicode/Is_Unicode.sh"
. "${LIBS_HESTIA}/HestiaKERNEL/Unicode/Unicode.sh"




HestiaKERNEL_To_UTF32_From_Unicode() {
        #___content="$1"
        #___bom="$2"
        #___endian="$3"


        # validate input
        if [ "$(HestiaKERNEL_Is_Unicode "$1")" -ne $HestiaKERNEL_ERROR_OK ]; then
                printf -- ""
                return $HestiaKERNEL_ERROR_DATA_INVALID
        fi


        # execute
        ___converted=""


        # prefix BOM if requested
        if [ "$2" = "$HestiaKERNEL_UTF_BOM" ]; then
                case "$3" in
                "$HestiaKERNEL_ENDIAN_LITTLE")
                        # UTF32LE_BOM - 0xFF, 0xFE, 0x00, 0x00
                        ___converted="255, 254, 0, 0, "
                        ;;
                *)
                        # UTF32BE_BOM (default) - 0x00, 0x00, 0xFE, 0xFF
                        ___converted="0, 0, 254, 255, "
                        ;;
                esac
        fi


        # convert to UTF-32 bytes list
        ___content="$1"
        while [ ! "$___content" = "" ]; do
                # get current character decimal
                ___char="${___content%%, *}"
                ___content="${___content#"$___char"}"
                if [ "${___content%"${___content#?}"}" = "," ]; then
                        ___content="${___content#, }"
                fi

                case "$3" in
                "$HestiaKERNEL_ENDIAN_LITTLE")
                        ___register=$(($___char & 0xFF))
                        ___converted="${___converted}$(printf -- "%d" "$___register"), "

                        ___register=$(($___char & 0xFF00))
                        ___register=$(($___char >> 8))
                        ___converted="${___converted}$(printf -- "%d" "$___register"), "

                        ___register=$(($___char & 0xFF0000))
                        ___register=$(($___char >> 16))
                        ___converted="${___converted}$(printf -- "%d" "$___register"), "

                        ___register=$(($___char & 0xFF000000))
                        ___register=$(($___char >> 24))
                        ___converted="${___converted}$(printf -- "%d" "$___register"), "
                        ;;
                *)
                        ___register=$(($___char & 0xFF000000))
                        ___register=$(($___char >> 24))
                        ___converted="${___converted}$(printf -- "%d" "$___register"), "

                        ___register=$(($___char & 0xFF0000))
                        ___register=$(($___char >> 16))
                        ___converted="${___converted}$(printf -- "%d" "$___register"), "

                        ___register=$(($___char & 0xFF00))
                        ___register=$(($___char >> 8))
                        ___converted="${___converted}$(printf -- "%d" "$___register"), "

                        ___register=$(($___char & 0xFF))
                        ___converted="${___converted}$(printf -- "%d" "$___register"), "
                        ;;
                esac
        done


        # report status
        printf -- "%s" "${___converted%, }"
}
