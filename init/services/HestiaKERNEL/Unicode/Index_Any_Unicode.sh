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
. "${LIBS_HESTIA}/HestiaKERNEL/Unicode/Index_Any_Left_Unicode.sh"
. "${LIBS_HESTIA}/HestiaKERNEL/Unicode/Index_Any_Right_Unicode.sh"




HestiaKERNEL_Index_Any_Unicode() {
        #___content_unicode="$1"
        #___target_unicode="$2"
        #___from_right="$3"


        # execute
        if [ ! "$3" = "" ]; then
                printf -- "%d" "$(HestiaKERNEL_Index_Any_Right_Unicode "$1" "$2")"
        else
                printf -- "%d" "$(HestiaKERNEL_Index_Any_Left_Unicode "$1" "$2")"
        fi


        # report status
        return $?
}
