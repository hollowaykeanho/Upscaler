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
. "${LIBS_HESTIA}/HestiaKERNEL/Unicode/Scan_Right_Unicode.sh"




HestiaKERNEL_Scan_Unicode() {
        #___content_unicode="$1"
        #___target_unicode="$2"
        #___count="$3"
        #___ignore="$4"
        #___from_right="$5"


        # execute
        if [ ! "$5" = "" ]; then
                printf -- "%b" "$(HestiaKERNEL_Scan_Right_Unicode "$1" "$2" "$3" "$4")"
        else
                printf -- "%b" "$(HestiaKERNEL_Scan_Left_Unicode "$1" "$2" "$3" "$4")"
        fi


        # report status
        return $?
}
