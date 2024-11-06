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




# IMPORTANT NOTICE
# This function is made available for backward compatibility and educational
# purposes (as a reminder on how to check without needing any other libraries)
# only. In practice, you should always use the "equal to empty string" tester
# directly such that:
#       (1) POSIX Compliant Shell       : if [ "$var" = "" ]; then
#       (2) PowerShell                  : if ($var -eq "") {
HestiaKERNEL_Is_Empty_Unicode() {
        #___target="$1"


        # execute
        if [ "$1" = "" ]; then
                printf -- "%d" $HestiaKERNEL_ERROR_OK
                return $HestiaKERNEL_ERROR_OK
        fi


        # report status
        printf -- "%d" $HestiaKERNEL_ERROR_DATA_EMPTY
        return $HestiaKERNEL_ERROR_DATA_EMPTY
}
