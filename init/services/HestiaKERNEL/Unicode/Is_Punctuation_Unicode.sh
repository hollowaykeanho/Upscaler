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




HestiaKERNEL_Is_Punctuation_Unicode() {
        #___unicode="$1"


        # validate input
        if [ "$(HestiaKERNEL_Is_Number "$1")" -ne $HestiaKERNEL_ERROR_OK ]; then
                printf -- "%d" $HestiaKERNEL_ERROR_DATA_INVALID
                return $HestiaKERNEL_ERROR_DATA_INVALID
        fi


        # execute
        if ([ $1 -ge 33 ] && [ $1 -le 47 ]) ||
                ([ $1 -ge 58 ] && [ $1 -le 64 ]) ||
                ([ $1 -ge 123 ] && [ $1 -le 126 ]) ||
                ([ $1 -ge 161 ] && [ $1 -le 191 ]) ||
                ([ $1 -ge 8192 ] && [ $1 -le 8303 ]) ||
                ([ $1 -ge 11776 ] && [ $1 -le 11903 ]) ||
                ([ $1 -ge 12288 ] && [ $1 -le 12351 ]) ||
                ([ $1 -ge 74752 ] && [ $1 -le 74879 ]) ||
                ([ $1 -ge 94176 ] && [ $1 -le 94207 ]); then
                # Latin-1 Script (0x0021-0x002F; 0x003A-0x0040)
                # Latin-1 Suppliment Script (0x00A0-0x00BF)
                # General Punctuation Script (0x2000-0x206F)
                # Supplemental Punctuation Script (0x2E00-0x2E7F)
                # CJK Symbols and Punctuation Script (0x3000-0x303F)
                # Cuneiform Number and Punctuation Script (0x12400-0x1247F)
                # Ideographic Symbols and Punctuation Script (0x16FE0-0x16FFF)
                printf -- "%d" $HestiaKERNEL_ERROR_OK
                return $HestiaKERNEL_ERROR_OK
        fi


        # report status
        printf -- "%d" $HestiaKERNEL_ERROR_DATA_INVALID
        return $HestiaKERNEL_ERROR_DATA_INVALID
}
