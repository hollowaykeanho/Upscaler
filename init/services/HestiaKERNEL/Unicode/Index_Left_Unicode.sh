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
. "${LIBS_HESTIA}/HestiaKERNEL/Unicode/Is_Unicode.sh"




HestiaKERNEL_Index_Left_Unicode() {
        #___content_unicode="$1"
        #___target_unicode="$2"
        ___scan_index=-1


        # validate input
        if [ $(HestiaKERNEL_Is_Unicode "$1") -ne $HestiaKERNEL_ERROR_OK ]; then
                printf -- "%d" "$___scan_index"
                return $HestiaKERNEL_ERROR_ENTITY_EMPTY
        fi

        if [ $(HestiaKERNEL_Is_Unicode "$2") -ne $HestiaKERNEL_ERROR_OK ]; then
                printf -- "%d" "$___scan_index"
                return $HestiaKERNEL_ERROR_DATA_EMPTY
        fi


        # execute
        ___content_unicode="$1"
        ___target_unicode="$2"
        ___index=0
        while [ ! "$___content_unicode" = "" ]; do
                # get current character
                ___current="${___content_unicode%%, *}"
                ___content_unicode="${___content_unicode#"$___current"}"
                if [ "${___content_unicode%"${___content_unicode#?}"}" = "," ]; then
                        ___content_unicode="${___content_unicode#, }"
                fi


                # get target character
                ___target="${___target_unicode%%, *}"
                ___target_unicode="${___target_unicode#"$___target"}"
                if [ "${___target_unicode%"${___target_unicode#?}"}" = "," ]; then
                        ___target_unicode="${___target_unicode#, }"
                fi


                # bail if mismatched
                if [ ! "$___current" = "$___target" ]; then
                        ___scan_index=-1
                        ___target_unicode="$2"
                        ___index=$(($___index + 1))
                        continue
                fi


                # it's a match - set $___scan_index if available
                if [ $___scan_index -lt 0 ]; then
                        ___scan_index=$___index
                fi


                # break scan if target is fully scanned
                if [ "$___target_unicode" = "" ]; then
                        printf -- "%d" "$___scan_index"
                        return $HestiaKERNEL_ERROR_OK
                fi


                # more characters - increase index and continue
                ___index=$(($___index + 1))
        done


        # report status
        printf -- "%d" "-1"
        return $HestiaKERNEL_ERROR_OK
}
