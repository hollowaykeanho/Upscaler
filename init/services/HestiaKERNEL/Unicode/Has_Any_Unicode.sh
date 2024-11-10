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




HestiaKERNEL_Has_Any_Unicode() {
        #___content_unicode="$1"
        #___charset_unicode="$2"


        # validate input
        if [ $(HestiaKERNEL_Is_Unicode "$1") -ne $HestiaKERNEL_ERROR_OK ]; then
                printf -- "%s" "$HestiaKERNEL_ERROR_ENTITY_EMPTY"
                return $HestiaKERNEL_ERROR_ENTITY_EMPTY
        fi

        if [ $(HestiaKERNEL_Is_Unicode "$2") -ne $HestiaKERNEL_ERROR_OK ]; then
                printf -- "%s" "$HestiaKERNEL_ERROR_DATA_EMPTY"
                return $HestiaKERNEL_ERROR_DATA_EMPTY
        fi


        # execute
        ___content_unicode="$1"
        while [ ! "$___content_unicode" = "" ]; do
                # get current character
                ___current="${___content_unicode%%, *}"
                ___content_unicode="${___content_unicode#"$___current"}"
                if [ "${___content_unicode%"${___content_unicode#?}"}" = "," ]; then
                        ___content_unicode="${___content_unicode#, }"
                fi


                # get char from charset character
                ___charset_unicode="$2"
                ___mismatched=0 ## assume mismatched by default
                while [ ! "$___charset_unicode" = "" ]; do
                        # get target character
                        ___target="${___charset_unicode%%, *}"
                        ___charset_unicode="${___charset_unicode#"$___target"}"
                        if [ "${___charset_unicode%"${___charset_unicode#?}"}" = "," ]; then
                                ___charset_unicode="${___charset_unicode#, }"
                        fi

                        if [ "$___current" = "$___target" ]; then
                                ___charset_unicode=""
                                ___mismatched=1
                                break # exit early from O(m^2) timing ASAP
                        fi
                done

                if [ $___mismatched -ne 0 ]; then
                        # It's a match
                        printf -- "%d" "$HestiaKERNEL_ERROR_OK"
                        return $HestiaKERNEL_ERROR_OK
                fi
        done


        # report status
        printf -- "%d" "$HestiaKERNEL_ERROR_DATA_MISMATCHED"
        return $HestiaKERNEL_ERROR_DATA_MISMATCHED
}
