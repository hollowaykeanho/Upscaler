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
. "${LIBS_HESTIA}/HestiaKERNEL/Unicode/Scan_Left_Unicode.sh"
. "${LIBS_HESTIA}/HestiaKERNEL/Unicode/To_Unicode_From_String.sh"




HestiaKERNEL_Scan_Left_String() {
        #___input="$1"
        #___target="$2"
        #___count="$3"
        #___ignore="$4"


        # execute
        ___content="$(HestiaKERNEL_To_Unicode_From_String "$1")"
        ___chars="$(HestiaKERNEL_To_Unicode_From_String "$2")"
        printf -- "%b" "$(HestiaKERNEL_Scan_Left_Unicode "$___content" "$___chars" "$3" "$4")"


        # report status
        return $?
}
