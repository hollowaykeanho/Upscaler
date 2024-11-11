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




HestiaKERNEL_Index_Any_Left_Unicode() {
        #___content_unicode="$1"
        #___target_unicode="$2"


        # validate input
        if [ $(HestiaKERNEL_Is_Unicode "$1") -ne $HestiaKERNEL_ERROR_OK ]; then
                printf -- "%d" "-1"
                return $HestiaKERNEL_ERROR_ENTITY_EMPTY
        fi

        if [ $(HestiaKERNEL_Is_Unicode "$2") -ne $HestiaKERNEL_ERROR_OK ]; then
                printf -- "%d" "-1"
                return $HestiaKERNEL_ERROR_DATA_EMPTY
        fi


        # execute
        ___content_unicode="$1"
        ___index=0
        while [ ! "$___content_unicode" = "" ]; do
                # get current character
                ___current="${___content_unicode%%, *}"
                ___content_unicode="${___content_unicode#"$___current"}"
                if [ "${___content_unicode%"${___content_unicode#?}"}" = "," ]; then
                        ___content_unicode="${___content_unicode#, }"
                fi


                # get char from target character
                ___target_unicode="$2"
                while [ ! "$___target_unicode" = "" ]; do
                        ___char="${___target_unicode%%, *}"
                        ___target_unicode="${___target_unicode#"$___char"}"
                        if [ "${___target_unicode%"${___target_unicode#?}"}" = "," ]; then
                                ___target_unicode="${___target_unicode#, }"
                        fi

                        if [ "$___current" = "$___char" ]; then
                                printf -- "%d" "$___index"
                                return $HestiaKERNEL_ERROR_OK # exit early from O(m^2) timing ASAP
                        fi
                done


                # more characters - increase index and continue
                ___index=$(($___index + 1))
        done


        # report status
        printf -- "%d" "-1"
        return $HestiaKERNEL_ERROR_OK
}
