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
. "${LIBS_HESTIA}/HestiaKERNEL/Unicode/Unicode.sh"




HestiaKERNEL_To_Unicode_From_String() {
        #___string="$1"


        # validate input
        if [ "$1" = "" ]; then
                printf -- ""
                return $HestiaKERNEL_ERROR_DATA_EMPTY
        fi


        # execute
        ## POSIX Shell does not handle any character beyond Latin-1 script.
        ## Hence, most of its string operation only works for ASCII character
        ## (<127). While it's not a problem for BASH; it is for
        ## non-BASH environment. Hence, manual implementations are required.
        ___converted=""
        ___content="$1"
        while [ ! "$___content" = "" ]; do
                ___codepoint="${___content%"${___content#?}"}"
                ___content="${___content#${___codepoint}}"
                ___codepoint="$(printf -- "%d" "'${___codepoint}")"

                if [ $___codepoint -lt 0 ]; then
                        ___codepoint=63 # encoder error - change to '?'
                fi

                ___converted="${___converted}${___codepoint}, "
        done
        printf -- "%s" "${___converted%, }"


        # report status
        return $HestiaKERNEL_ERROR_OK
}
