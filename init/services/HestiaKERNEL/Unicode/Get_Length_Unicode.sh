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




HestiaKERNEL_Get_Length_Unicode() {
        #___input_unicode="$1"


        # validate input
        if [ $(HestiaKERNEL_Is_Unicode "$1") -ne $HestiaKERNEL_ERROR_OK ]; then
                printf -- "%s" "-1"
                return $HestiaKERNEL_ERROR_ENTITY_EMPTY
        fi

        if [ "$1" = "" ]; then
                printf -- "%d" "0"
                return $HestiaKERNEL_ERROR_OK
        fi


        # execute
        ___count=0
        ___content_unicode="$1"
        while [ ! "$___content_unicode" = "" ]; do
                # get current character
                ___current="${___content_unicode%%, *}"
                ___content_unicode="${___content_unicode#"$___current"}"
                if [ "${___content_unicode%"${___content_unicode#?}"}" = "," ]; then
                        ___content_unicode="${___content_unicode#, }"
                fi

                ___count=$(($___count + 1))
        done


        # report status
        printf -- "%d" "$___count"
        return $HestiaKERNEL_ERROR_OK
}
