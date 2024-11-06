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
. "${LIBS_HESTIA}/HestiaKERNEL/Unicode/Get_Length_Unicode.sh"
. "${LIBS_HESTIA}/HestiaKERNEL/Unicode/To_Unicode_From_String.sh"




HestiaKERNEL_Get_Length_String() {
        #___input_string="$1"


        # validate input
        if [ "$1" = "" ]; then
                printf -- "%d" "0"
                return $HestiaKERNEL_ERROR_DATA_EMPTY
        fi


        # execute
        ___unicodes="$(HestiaKERNEL_To_Unicode_From_String "$1")"
        if [ "$___unicodes" = "" ]; then
                printf -- "%d" "0"
                return $HestiaKERNEL_ERROR_DATA_INVALID
        fi

        printf -- "%d" "$(HestiaKERNEL_Get_Length_Unicode "$___unicodes")"


        # report status
        return $HestiaKERNEL_ERROR_OK
}
