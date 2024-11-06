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
. "${LIBS_HESTIA}/HestiaKERNEL/List/Is_Array_Number.sh"
. "${LIBS_HESTIA}/HestiaKERNEL/Number/Is_Number.sh"




HestiaKERNEL_Is_Array_Byte() {
        #___input="$1"


        # validate input
        if [ "$1" = "" ]; then
                printf -- "%d" $HestiaKERNEL_ERROR_DATA_EMPTY
                return $HestiaKERNEL_ERROR_DATA_EMPTY
        fi

        if [ "$(HestiaKERNEL_Is_Array_Number "$1")" -ne $HestiaKERNEL_ERROR_OK ]; then
                printf -- "%d" $HestiaKERNEL_ERROR_DATA_INVALID
                return $HestiaKERNEL_ERROR_DATA_INVALID
        fi


        # execute
        ___content="$1"
        while [ ! "$___content" = "" ]; do
                # get current byte
                ___byte="${___content%%, *}"
                ___content="${___content#"$___byte"}"
                if [ "${___content%"${___content#?}"}" = "," ]; then
                        ___content="${___content#, }"
                fi

                if [ "$(HestiaKERNEL_Is_Number "$___byte")" -ne $HestiaKERNEL_ERROR_OK ]; then
                        printf -- "%d" $HestiaKERNEL_ERROR_DATA_INVALID
                        return $HestiaKERNEL_ERROR_DATA_INVALID
                fi
        done


        # report status
        printf -- "%d" $HestiaKERNEL_ERROR_OK
        return $HestiaKERNEL_ERROR_OK
}
