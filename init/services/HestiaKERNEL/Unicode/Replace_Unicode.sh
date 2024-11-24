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
. "${LIBS_HESTIA}/HestiaKERNEL/Unicode/Replace_Left_Unicode.sh"
. "${LIBS_HESTIA}/HestiaKERNEL/Unicode/Replace_Right_Unicode.sh"




HestiaKERNEL_Replace_Unicode() {
        #___content_unicode="$1"
        #___from_unicode="$2"
        #___to_unicode="$3"
        #___count="$4"
        #___ignore="$5"
        #___from_right="$6"


        # execute
        if [ ! "$6" = "" ]; then
                printf -- "%b" "$(HestiaKERNEL_Replace_Right_Unicode "$1" "$2" "$3" "$4" "$5")"
        else
                printf -- "%b" "$(HestiaKERNEL_Replace_Left_Unicode "$1" "$2" "$3" "$4" "$5")"
        fi


        # report status
        return $?
}
