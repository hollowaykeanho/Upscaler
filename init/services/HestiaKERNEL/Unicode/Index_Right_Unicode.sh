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
. "${LIBS_HESTIA}/HestiaKERNEL/Unicode/Is_Unicode.sh"




HestiaKERNEL_Index_Right_Unicode() {
        #___content_unicode="$1"
        #___target_unicode="$2"
        ___scan_index=-1


        # validate input
        if [ "$(HestiaKERNEL_Is_Unicode "$1")" -ne $HestiaKERNEL_ERROR_OK ]; then
                printf -- "%s" "$___scan_index"
                return $HestiaKERNEL_ERROR_ENTITY_EMPTY
        fi

        if [ "$(HestiaKERNEL_Is_Unicode "$2")" -ne $HestiaKERNEL_ERROR_OK ]; then
                printf -- "%s" "$___scan_index"
                return $HestiaKERNEL_ERROR_DATA_EMPTY
        fi


        # execute
        ___content_unicode="$1"
        ___target_unicode="$2"
        ___index=0
        ___is_scanning=0
        ___target_length=0
        while [ ! "$___content_unicode" = "" ]; do
                # get current character
                ___current="${___content_unicode##*, }"
                ___content_unicode="${___content_unicode%"$___current"}"
                if [ "${___content_unicode#"${___content_unicode%?}"}" = " " ]; then
                        ___content_unicode="${___content_unicode%, }"
                fi


                # continue counting content length if scan is completed
                if [ $___is_scanning -ne 0 ]; then
                        ___index=$(($___index + 1))
                        continue
                fi


                # get target character
                ___target="${___target_unicode##*, }"
                ___target_unicode="${___target_unicode%"$___target"}"
                if [ "${___target_unicode#"${___target_unicode%?}"}" = " " ]; then
                        ___target_unicode="${___target_unicode%, }"
                fi


                # bail if mismatched
                if [ ! "$___current" = "$___target" ]; then
                        ___scan_index=-1
                        ___target_unicode="$2"
                        ___target_length=0
                        ___index=$(($___index + 1))
                        continue
                fi
                ___target_length=$(($___target_length + 1))


                # it's a match - set $___scan_index if available
                if [ $___scan_index -lt 0 ]; then
                        ___scan_index=$___index
                fi


                # stop the scan if target is fully scanned
                if [ "$___target_unicode" = "" ]; then
                        ___is_scanning=1
                fi


                # more characters - increase index and continue
                ___index=$(($___index + 1))
        done


        # report early if the scan is negative
        if [ $___scan_index -lt 0 ] || [ ! "$___target_unicode" = "" ]; then
                printf -- "%d" "-1"
                return $HestiaKERNEL_ERROR_OK
        fi


        # convert right-to-left index back to left-to-right index for
        # programming language's consistency
        ___scan_index="$(($___index - $___scan_index - $___target_length))"


        # report status
        printf -- "%d" "$___scan_index"
        return $HestiaKERNEL_ERROR_OK
}
