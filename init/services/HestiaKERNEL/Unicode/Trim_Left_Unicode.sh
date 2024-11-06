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




HestiaKERNEL_Trim_Left_Unicode() {
        #___content_unicode="$1"
        #___charset_unicode="$2"


        # validate input
        if [ $(HestiaKERNEL_Is_Unicode "$1") -ne $HestiaKERNEL_ERROR_OK ]; then
                printf -- "%s" "$1"
                return $HestiaKERNEL_ERROR_ENTITY_EMPTY
        fi

        if [ $(HestiaKERNEL_Is_Unicode "$2") -ne $HestiaKERNEL_ERROR_OK ]; then
                printf -- "%s" "$1"
                return $HestiaKERNEL_ERROR_DATA_EMPTY
        fi


        # execute
        ## IMPORTANT NOTICE
        ## POSIX Shell's UNIX regex cannot recognize anything outside Latin-1
        ## script. Therefore, manual algorithmic handling is required.
        ___content_unicode="$1"
        ___charset_unicode="$2"
        ___converted=""
        while [ ! "$___content_unicode" = "" ]; do
                # get current character
                ___current="${___content_unicode%%, *}"
                ___content_unicode="${___content_unicode#"$___current"}"
                if [ "${___content_unicode%"${___content_unicode#?}"}" = "," ]; then
                        ___content_unicode="${___content_unicode#, }"
                fi


                # get char from charset character
                ___charset_list="$___charset_unicode"
                ___mismatched=0
                while [ ! "$___charset_list" = "" ]; do
                        ___char="${___charset_list%%, *}"
                        ___charset_list="${___charset_list#"$___char"}"
                        if [ "${___charset_list%"${___charset_list#?}"}" = "," ]; then
                                ___charset_list="${___charset_list#, }"
                        fi

                        if [ "$___current" = "$___char" ]; then
                                ___charset_list=""
                                ___mismatched=1
                                break # exit early from O(m^2) timing ASAP
                        fi
                done


                # It's a mismatch - append the rest and bail out
                if [ $___mismatched -eq 0 ]; then
                        ___converted="${___current}, ${___content_unicode}"
                        break
                fi
        done


        # report status
        printf -- "%s" "${___converted%, }"
        return $HestiaKERNEL_ERROR_OK
}
