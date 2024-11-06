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
. "${LIBS_HESTIA}/HestiaKERNEL/OS/Get_String_Encoder.sh"
. "${LIBS_HESTIA}/HestiaKERNEL/Unicode/Is_Unicode.sh"
. "${LIBS_HESTIA}/HestiaKERNEL/Unicode/To_UTF8_From_Unicode.sh"
. "${LIBS_HESTIA}/HestiaKERNEL/Unicode/To_UTF16_From_Unicode.sh"
. "${LIBS_HESTIA}/HestiaKERNEL/Unicode/To_UTF32_From_Unicode.sh"
. "${LIBS_HESTIA}/HestiaKERNEL/Unicode/Unicode.sh"




HestiaKERNEL_To_String_From_Unicode() {
        #___unicode="$1"


        # validate input
        if [ $(HestiaKERNEL_Is_Unicode "$1") -ne "$HestiaKERNEL_ERROR_OK" ]; then
                printf -- ""
                return $HestiaKERNEL_ERROR_DATA_INVALID
        fi


        # execute
        ## ensure all unicode are valid --> replace unsupported to '?'
        ___content="$1"
        ___converted=""
        while [ ! "$___content" = "" ]; do
                # get character
                ___codepoint="${___content%%, *}"
                ___content="${___content#"$___codepoint"}"
                if [ "${___content%"${___content#?}"}" = "," ]; then
                        ___content="${___content#, }"
                fi

                # check for valid codepoint
                if [ $___codepoint -lt 0 ]; then
                        ___codepoint=63 # change to '?'
                fi

                ___converted="${___converted}${___codepoint}, "
        done


        # process HestiaKERNEL.Unicode data type
        ___content="${___converted%, }"
        case "$(HestiaKERNEL_Get_String_Encoder)" in
        $HestiaKERNEL_UTF8)
                ___content="$(HestiaKERNEL_To_UTF8_From_Unicode "$___content")"
                ;;
        $HestiaKERNEL_UTF16BE)
                ___content="$(HestiaKERNEL_To_UTF16_From_Unicode "$___content")"
                ;;
        $HestiaKERNEL_UTF32BE)
                ___content="$(HestiaKERNEL_To_UTF32_From_Unicode "$___content")"
                ;;
        *)
                printf -- ""
                return $HestiaKERNEL_ERROR_NOT_POSSIBLE
                ;;
        esac

        ___converted=""
        while [ ! "$___content" = "" ]; do
                # get character
                ___byte="${___content%%, *}"
                ___content="${___content#"$___byte"}"
                if [ "${___content%"${___content#?}"}" = "," ]; then
                        ___content="${___content#, }"
                fi

                ___converted="${___converted}$(printf -- '\%o' "$___byte")"
        done


        # report status
        printf -- "%b" "$___converted"
        return $HestiaKERNEL_ERROR_OK
}
