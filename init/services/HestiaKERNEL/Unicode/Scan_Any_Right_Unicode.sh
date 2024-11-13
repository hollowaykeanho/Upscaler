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




HestiaKERNEL_Scan_Any_Right_Unicode() {
        #___content_unicode="$1"
        #___target_unicode="$2"
        #___count="$3"
        #___ignore="$4"
        ___scan_index=-1


        # validate input
        if [ "$(HestiaKERNEL_Is_Unicode "$1")" -ne $HestiaKERNEL_ERROR_OK ]; then
                printf -- ""
                return $HestiaKERNEL_ERROR_ENTITY_EMPTY
        fi

        if [ "$(HestiaKERNEL_Is_Unicode "$2")" -ne $HestiaKERNEL_ERROR_OK ]; then
                printf -- ""
                return $HestiaKERNEL_ERROR_DATA_EMPTY
        fi

        ___count=-1
        if [ "$(HestiaKERNEL_Is_Number "$3")" -eq $HestiaKERNEL_ERROR_OK ]; then
                ___count="$3"
        fi

        ___ignore=-1
        if [ "$(HestiaKERNEL_Is_Number "$4")" -eq $HestiaKERNEL_ERROR_OK ]; then
                ___ignore="$4"
        fi


        # execute
        ___list_index=""
        ___content_unicode="$1"
        ___index=0
        ___is_scanning=0
        while [ ! "$___content_unicode" = "" ]; do
                # get current character
                ___current="${___content_unicode##*, }"
                ___content_unicode="${___content_unicode%"$___current"}"
                if [ "${___content_unicode#"${___content_unicode%?}"}" = " " ]; then
                        ___content_unicode="${___content_unicode%, }"
                fi


                # continue the count
                if [ $___is_scanning -ne 0 ]; then
                        ___index=$(($___index + 1))
                        continue
                fi


                # get char from target character
                ___target_unicode="$2"
                ___scan_index=-1
                while [ ! "$___target_unicode" = "" ]; do
                        ___target="${___target_unicode##*, }"
                        ___target_unicode="${___target_unicode%"$___target"}"
                        if [ "${___target_unicode#"${___target_unicode%?}"}" = " " ]; then
                                ___target_unicode="${___target_unicode%, }"
                        fi

                        if [ "$___current" = "$___target" ]; then
                                ___target_unicode=""
                                ___scan_index=$___index
                                break # exit early from O(m^2) timing ASAP
                        fi
                done


                # handle matches when available
                if [ $___scan_index -ge 0 ]; then
                        if [ $___ignore -le 0 ]; then
                                ___list_index="${___scan_index}, ${___list_index}"
                                if [ $___count -gt 0 ]; then
                                        ___count=$(($___count - 1))
                                        if [ $___count -le 0 ]; then
                                                ___is_scanning=1
                                                ___index=$(($___index + 1))
                                                continue
                                        fi
                                fi
                        else
                                ___ignore=$(($___ignore - 1))
                        fi

                        ___scan_index=-1
                fi


                # more characters - increase index and continue
                ___index=$(($___index + 1))
        done


        # report early if the scan is negative
        if [ "$___list_index" = "" ]; then
                printf -- ""
                return $HestiaKERNEL_ERROR_OK
        fi


        # convert right-to-left index back to left-to-right index for
        # programming language's consistency
        ___list_output=""
        ___list_index="${___list_index%, }"
        while [ ! "$___list_index" = "" ]; do
                ___current="${___list_index##*, }"
                ___list_index="${___list_index%"$___current"}"
                if [ "${___list_index#"${___list_index%?}"}" = " " ]; then
                        ___list_index="${___list_index%, }"
                fi

                ___current="$(($___index - $___current - 1))"
                ___list_output="${___list_output}${___current}\n"
        done


        # report status
        printf -- "%b" "${___list_output%"\n"}"
        return $HestiaKERNEL_ERROR_OK
}
