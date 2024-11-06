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
. "${env:LIBS_HESTIA}\HestiaKERNEL\Errors\Error_Codes.ps1"




# IMPORTANT NOTICE
# This function is made available for backward compatibility and educational
# purposes (as a reminder on how to check without needing any other libraries)
# only. In practice, you should always use the "equal to empty array" tester
# directly such that:
#       (1) POSIX Compliant Shell       : if [ "$var" = "" ]; then
#       (2) PowerShell                  : if ($var.Length -le 0) {
function HestiaKERNEL-Is-Empty-Unicode {
        param (
                [uint32[]]$___target
        )


        # execute
        if ($___target.Length -le 0) {
                return ${env:HestiaKERNEL_ERROR_OK}
        }


        # report status
        return ${env:HestiaKERNEL_ERROR_DATA_EMPTY}
}
