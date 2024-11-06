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




HestiaKERNEL_Is_Number() {
        #___input="$1"


        # validate input
        if [ "$1" = "" ]; then
                printf -- "%d" $HestiaKERNEL_ERROR_DATA_EMPTY
                return $HestiaKERNEL_ERROR_DATA_EMPTY
        fi


        # execute
        case "$1" in
        *[!0123456789_]*)
                printf -- "%d" $HestiaKERNEL_ERROR_DATA_INVALID
                return $HestiaKERNEL_ERROR_DATA_INVALID
                ;;
        esac


        # report status
        printf -- "%d" $HestiaKERNEL_ERROR_OK
        return $HestiaKERNEL_ERROR_OK
}
