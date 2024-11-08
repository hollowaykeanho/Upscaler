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
. "${LIBS_HESTIA}/HestiaKERNEL/Unicode/Is_Whitespace_Unicode.sh"




HestiaKERNEL_Trim_Whitespace_Unicode() {
        #___content_unicode="$1"


        # validate input
        if [ $(HestiaKERNEL_Is_Unicode "$1") -ne $HestiaKERNEL_ERROR_OK ]; then
                printf -- "%s" "$1"
                return $HestiaKERNEL_ERROR_ENTITY_EMPTY
        fi


        # execute
        ___content_unicode="$1"
        ___scan_left=0
        ___scan_right=0
        while [ ! "$___content_unicode" = "" ]; do
                if [ "$___scan_left" -eq 0 ]; then
                        # get current character
                        ___current="${___content_unicode%%, *}"
                        ___content_unicode="${___content_unicode#"$___current"}"
                        if [ "${___content_unicode%"${___content_unicode#?}"}" = "," ]; then
                                ___content_unicode="${___content_unicode#, }"
                        fi


                        # stop the scan if mismatched
                        if [ $(HestiaKERNEL_Is_Whitespace_Unicode "$___current") -ne $HestiaKERNEL_ERROR_OK ]; then
                                ___content_unicode="${___current}, ${___content_unicode}"
                                ___scan_left=1
                        fi
                fi

                if [ "$___scan_right" -eq 0 ]; then
                        # get current character
                        ___current="${___content_unicode##*, }"
                        ___content_unicode="${___content_unicode%"$___current"}"
                        if [ "${___content_unicode#"${___content_unicode%?}"}" = " " ]; then
                                ___content_unicode="${___content_unicode%, }"
                        fi


                        # stop the scan if mismatched
                        if [ $(HestiaKERNEL_Is_Whitespace_Unicode "$___current") -ne $HestiaKERNEL_ERROR_OK ]; then
                                ___content_unicode="${___content_unicode}, ${___current}"
                                ___scan_right=1
                        fi
                fi

                if [ "$___scan_left" -ne 0 ] && [ "$___scan_right" -ne 0 ]; then
                        break
                fi
        done


        # report status
        printf -- "%s" "$___content_unicode"
        return $HestiaKERNEL_ERROR_OK
}
