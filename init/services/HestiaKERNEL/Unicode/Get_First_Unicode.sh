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




HestiaKERNEL_Get_First_Unicode() {
        #___content_unicode="$1"


        # validate input
        if [ "$1" = "" ]; then
                printf -- "%s" "$HestiaKERNEL_UNICODE_ERROR"
                return $HestiaKERNEL_ERROR_ENTITY_EMPTY
        fi

        if [ "$(HestiaKERNEL_Is_Unicode "$1")" -ne $HestiaKERNEL_ERROR_OK ]; then
                printf -- "%s" "$HestiaKERNEL_UNICODE_ERROR"
                return $HestiaKERNEL_ERROR_ENTITY_INVALID
        fi


        # execute
        printf -- "%d" "${1%%, *}"
        return $HestiaKERNEL_ERROR_OK
}
