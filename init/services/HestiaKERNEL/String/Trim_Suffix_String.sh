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
. "${LIBS_HESTIA}/HestiaKERNEL/Unicode/Trim_Suffix_Unicode.sh"
. "${LIBS_HESTIA}/HestiaKERNEL/Unicode/To_Unicode_From_String.sh"




HestiaKERNEL_Trim_Suffix_String() {
        #___input="$1"
        #___suffix="$2"


        # validate input
        if [ "$1" = "" ]; then
                printf -- "%s" "$1"
                return $HestiaKERNEL_ERROR_ENTITY_EMPTY
        fi

        if [ "$2" = "" ]; then
                printf -- "%s" "$1"
                return $HestiaKERNEL_ERROR_DATA_EMPTY
        fi


        # execute
        ___content="$(HestiaKERNEL_To_Unicode_From_String "$1")"
        if [ "$___content" = "" ]; then
                printf -- "%s" "$1"
                return $HestiaKERNEL_ERROR_DATA_INVALID
        fi

        ___chars="$(HestiaKERNEL_To_Unicode_From_String "$2")"
        if [ "$___chars" = "" ]; then
                printf -- "%s" "$1"
                return $HestiaKERNEL_ERROR_DATA_INVALID
        fi

        ___content="$(HestiaKERNEL_Trim_Suffix_Unicode "$___content" "$___chars")"
        ___content="$(HestiaKERNEL_To_String_From_Unicode "$___content")"
        printf -- "%s" "$___content"


        # report status
        return $HestiaKERNEL_ERROR_OK
}
