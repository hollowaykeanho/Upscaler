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
. "${LIBS_HESTIA}/HestiaKERNEL/Number/Is_Number.sh"




HestiaKERNEL_Replace_Any_Left_Unicode() {
        #___content_unicode="$1"
        #___from_unicode="$2"
        #___to_unicode="$3"
        #___count="$4"
        #___ignore="$5"


        # validate input
        if [ $(HestiaKERNEL_Is_Unicode "$1") -ne $HestiaKERNEL_ERROR_OK ]; then
                printf -- "%s" "$1"
                return $HestiaKERNEL_ERROR_ENTITY_EMPTY
        fi

        if [ $(HestiaKERNEL_Is_Unicode "$2") -ne $HestiaKERNEL_ERROR_OK ]; then
                printf -- "%s" "$1"
                return $HestiaKERNEL_ERROR_DATA_EMPTY
        fi

        if [ ! "$3" = "" ]; then
                if [ $(HestiaKERNEL_Is_Unicode "$3") -ne $HestiaKERNEL_ERROR_OK ]; then
                        printf -- "" ""
                        return $HestiaKERNEL_ERROR_DATA_INVALID
                fi
        fi

        ___count=-1
        if [ $(HestiaKERNEL_Is_Number "$4") -eq $HestiaKERNEL_ERROR_OK ]; then
                ___count="$4"
        fi

        ___ignore=-1
        if [ $(HestiaKERNEL_Is_Number "$5") -eq $HestiaKERNEL_ERROR_OK ]; then
                ___ignore="$5"
        fi


        # execute
        ___converted=""
        ___content_unicode="$1"
        ___to_unicode="$3"
        ___is_replacing=0
        while [ ! "$___content_unicode" = "" ]; do
                # get current character
                ___current="${___content_unicode%%, *}"
                ___content_unicode="${___content_unicode#"$___current"}"
                if [ "${___content_unicode%"${___content_unicode#?}"}" = "," ]; then
                        ___content_unicode="${___content_unicode#, }"
                fi

                if [ $___is_replacing -ne 0 ]; then
                        ___converted="${___converted}${___current}, "
                        continue
                fi


                # get target character
                ___from_unicode="$2"
                ___mismatched=0 # default to mismatched
                while [ ! "$___from_unicode" = "" ]; do
                        ___from="${___from_unicode%%, *}"
                        ___from_unicode="${___from_unicode#"$___from"}"
                        if [ "${___from_unicode%"${___from_unicode#?}"}" = "," ]; then
                                ___from_unicode="${___from_unicode#, }"
                        fi

                        if [ "$___current" = "$___from" ]; then
                                ___from_unicode=""
                                ___mismatched=1
                                break # exit early from O(m^2) timing ASAP
                        fi
                done


                # bail if mismatched
                if [ $___mismatched -eq 0 ]; then
                        ___converted="${___converted}${___current}, "
                        continue
                fi


                # complete match - perform replacement
                if [ $___ignore -le 0 ]; then
                        if [ ! "$___to_unicode" = "" ]; then
                                ___converted="${___converted}${___to_unicode}, "
                        fi

                        if [ $___count -gt 0 ]; then
                                ___count=$(($___count - 1))
                                if [ $___count -le 0 ]; then
                                        ___is_replacing=1

                                        continue
                                fi
                        fi
                else
                        ___converted="${___converted}${___current}, "
                        ___ignore=$(($___ignore - 1))
                fi
        done


        # report status
        printf -- "%b" "${___converted%, }"
        return $HestiaKERNEL_ERROR_OK
}
