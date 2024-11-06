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
. "${LIBS_HESTIA}/HestiaKERNEL/Number/Is_Number.sh"




HestiaKERNEL_Is_Whitespace_Unicode() {
        #___unicode="$1"


        # validate input
        if [ "$(HestiaKERNEL_Is_Number "$1")" -ne $HestiaKERNEL_ERROR_OK ]; then
                printf -- "%d" $HestiaKERNEL_ERROR_DATA_INVALID
                return $HestiaKERNEL_ERROR_DATA_INVALID
        fi


        # execute
        case "$1" in
        9|10|11|12|13|32|133|160)
                #  9    | 10   | 11   | 12   | 13   | 32   | 133  | 160
                # 0x0009|0x000A|0x000B|0x000C|0x000D|0x0020|0x0085|0x00A0
                # '\t'  , '\n' , '\v' , '\f' , '\r' , ' '  , NEL  , NBSP
                printf -- "%d" $HestiaKERNEL_ERROR_OK
                return $HestiaKERNEL_ERROR_OK
                ;;
        *)
                printf -- "%d" $HestiaKERNEL_ERROR_DATA_INVALID
                return $HestiaKERNEL_ERROR_DATA_INVALID
                ;;
        esac
}
