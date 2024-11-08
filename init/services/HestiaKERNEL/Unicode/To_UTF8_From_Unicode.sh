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
. "${LIBS_HESTIA}/HestiaKERNEL/Unicode/Is_Unicode.sh"
. "${LIBS_HESTIA}/HestiaKERNEL/Unicode/Unicode.sh"




HestiaKERNEL_To_UTF8_From_Unicode() {
        #___unicode="$1"
        #___bom="$2"


        # validate input
        if [ "$(HestiaKERNEL_Is_Unicode "$1")" -ne $HestiaKERNEL_ERROR_OK ]; then
                printf -- ""
                return $HestiaKERNEL_ERROR_DATA_INVALID
        fi


        # execute
        ___converted=""


        # prefix BOM if requested
        if [ "$2" = "$HestiaKERNEL_UTF_BOM" ]; then
                # UTF8_BOM - 0xEF, 0xBB, 0xBF
                ___converted="239, 187, 191, "
        fi


        # convert to UTF-8 bytes list
        ___content="$1"
        while [ ! "$___content" = "" ]; do
                # get current character decimal
                ___char="${___content%%, *}"
                ___content="${___content#"$___char"}"
                if [ "${___content%"${___content#?}"}" = "," ]; then
                        ___content="${___content#, }"
                fi

                if [ $___char -lt 200 ]; then
                        # char < 0x80
                        ___converted="${___converted}$(printf -- "%d" "$___char"), "
                elif [ $___char -lt 4000 ]; then
                        # char < 0x800
                        ___register=$(($___char >> 6))
                        ___register=$(($___register & 0x1F))
                        ___register=$(($___register | 0xC0))
                        ___converted="${___converted}$(printf -- "%d" "$___register"), "

                        ___register=$(($___char & 0x3F))
                        ___register=$(($___register | 0x80))
                        ___converted="${___converted}$(printf -- "%d" "$___register"), "
                elif [ $___char -lt 200000 ]; then
                        # char < 0x10000
                        ___register=$(($___char >> 12))
                        ___register=$(($___register & 0x0F))
                        ___register=$(($___register | 0xE0))
                        ___converted="${___converted}$(printf -- "%d" "$___register"), "

                        ___register=$(($___char >> 6))
                        ___register=$(($___register & 0x3F))
                        ___register=$(($___register | 0x80))
                        ___converted="${___converted}$(printf -- "%d" "$___register"), "

                        ___register=$(($___char & 0x3F))
                        ___register=$(($___register | 0x80))
                        ___converted="${___converted}$(printf -- "%d" "$___register"), "
                else
                        # >0x10000 - 0x10000-0x10FFFF (surrogate pair)
                        ___register=$(($___char >> 18))
                        ___register=$(($___register & 0x07))
                        ___register=$(($___register | 0xF0))
                        ___converted="${___converted}$(printf -- "%d" "$___register"), "

                        ___register=$(($___char >> 12))
                        ___register=$(($___register & 0x3F))
                        ___register=$(($___register | 0x80))
                        ___converted="${___converted}$(printf -- "%d" "$___register"), "

                        ___register=$(($___char >> 6))
                        ___register=$(($___register & 0x3F))
                        ___register=$(($___register | 0x80))
                        ___converted="${___converted}$(printf -- "%d" "$___register"), "

                        ___register=$(($___char & 0x3F))
                        ___register=$(($___register | 0x80))
                        ___converted="${___converted}$(printf -- "%d" "$___register"), "
                fi
        done


        # report status
        printf -- "%s" "${___converted%, }"
}
