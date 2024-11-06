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
. "${LIBS_HESTIA}/HestiaKERNEL/Unicode/rune_to_upper.sh"

. "${LIBS_HESTIA}/HestiaKERNEL/Errors/Error_Codes.sh"
. "${LIBS_HESTIA}/HestiaKERNEL/Unicode/Is_Unicode.sh"




HestiaKERNEL_To_Uppercase_Unicode() {
        #___unicode="$1"
        #___locale="$2"


        # validate input
        if [ $(HestiaKERNEL_Is_Unicode "$1") -ne $HestiaKERNEL_ERROR_OK ]; then
                printf -- "%s" "$1"
                return $HestiaKERNEL_ERROR_DATA_INVALID
        fi


        # execute
        ___content="$1"
        ___converted=""
        while [ ! "$___content" = "" ]; do
                # get current character
                ___current="${___content%%, *}"
                ___content="${___content#"$___current"}"
                if [ "${___content%"${___content#?}"}" = "," ]; then
                        ___content="${___content#, }"
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

                        ___third="${___third%%, *}"
                        if [ "$___third" = "" ]; then
                                ___third=0
                        fi
                else
                        ___third=0
                fi


                # proceed to default conversion
                ___ret="$(hestiakernel_rune_to_upper "$___current" "$___next" "$___third" "" "$2")"
                ___scanned="${___ret%%]*}"
                ___converted="${___converted}${___ret#*]}, "


                # prepare for next scan
                ___scanned="${___scanned#[}"
                while [ $___scanned -gt 1 ]; do
                        if [ "$___content" = "" ]; then
                                break
                        fi

                        ___current="${___content%%, *}"
                        ___content="${___content#"$___char"}"
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
