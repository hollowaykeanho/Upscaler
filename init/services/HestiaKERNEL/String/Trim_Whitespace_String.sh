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
. "${LIBS_HESTIA}/HestiaKERNEL/String/To_String_From_Unicode.sh"
. "${LIBS_HESTIA}/HestiaKERNEL/Unicode/Trim_Whitespace_Unicode.sh"
. "${LIBS_HESTIA}/HestiaKERNEL/Unicode/To_Unicode_From_String.sh"




HestiaKERNEL_Trim_Whitespace_String() {
        #___input="$1"


        # execute
        ___content="$(HestiaKERNEL_To_Unicode_From_String "$1")"
        ___content="$(HestiaKERNEL_Trim_Whitespace_Unicode "$___content")"
        printf -- "%s" "$(HestiaKERNEL_To_String_From_Unicode "$___content")"


        # report status
        return $?
}
