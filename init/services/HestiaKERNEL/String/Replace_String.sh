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
. "${LIBS_HESTIA}/HestiaKERNEL/Unicode/Replace_Unicode.sh"
. "${LIBS_HESTIA}/HestiaKERNEL/Unicode/To_Unicode_From_String.sh"




HestiaKERNEL_Replace_String() {
        #___input="$1"
        #___from="$2"
        #___to="$3"
        #___count="$4"
        #___ignore="$5"
        #___direction="$6"


        # execute
        ___content="$(HestiaKERNEL_To_Unicode_From_String "$1")"
        ___chars_from="$(HestiaKERNEL_To_Unicode_From_String "$2")"
        ___chars_to="$(HestiaKERNEL_To_Unicode_From_String "$3")"
        ___content="$(HestiaKERNEL_Replace_Unicode "$___content" \
                                                        "$___chars_from" \
                                                        "$___chars_to" \
                                                        "$4" \
                                                        "$5" \
                                                        "$6"
        )"


        # report status
        printf -- "%b" "$(HestiaKERNEL_To_String_From_Unicode "$___content")"
        return $?
}
