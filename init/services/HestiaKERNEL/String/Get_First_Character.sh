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
. "${LIBS_HESTIA}/HestiaKERNEL/String/To_String_From_Unicode.sh"
. "${LIBS_HESTIA}/HestiaKERNEL/Unicode/Get_First_Unicode.sh"
. "${LIBS_HESTIA}/HestiaKERNEL/Unicode/To_Unicode_From_String.sh"
. "${LIBS_HESTIA}/HestiaKERNEL/Unicode/Unicode.sh"




HestiaKERNEL_Get_First_Character() {
        #___input_string="$1"


        # validate input
        if [ "$1" = "" ]; then
                printf -- ""
                return $HestiaKERNEL_ERROR_DATA_EMPTY
        fi


        # execute
        ___unicodes="$(HestiaKERNEL_To_Unicode_From_String "$1")"
        if [ "$___unicodes" = "" ]; then
                printf -- ""
                return $HestiaKERNEL_ERROR_DATA_INVALID
        fi

        ___unicode="$(HestiaKERNEL_Get_First_Unicode "$___unicodes")"
        printf -- "%s" "$(HestiaKERNEL_To_String_From_Unicode "$___unicode")"
        if [ $? -ne $HestiaKERNEL_ERROR_OK ]; then
                return $HestiaKERNEL_ERROR_BAD_EXEC
        fi


        # report status
        return $HestiaKERNEL_ERROR_OK
}
