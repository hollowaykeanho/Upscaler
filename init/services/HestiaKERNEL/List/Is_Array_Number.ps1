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
# Copyright 2024 (Holloway) Chew, Kean Ho <hello@hollowaykeanho.com>
. "${env:LIBS_HESTIA}\HestiaKERNEL\Errors\Error_Codes.ps1"




function HestiaKERNEL-Is-Array-Number {
        param (
                [object]$___content
        )


        # validate input
        if ("${___content}" -eq "") {
                return ${env:HestiaKERNEL_ERROR_DATA_EMPTY}
        }


        # execute
        if (
                ([bool]($___content -as [byte[]])) -or
                ([bool]($___content -as [int[]])) -or
                ([bool]($___content -as [long[]]))
        ) {
                return ${env:HestiaKERNEL_ERROR_OK}
        }


        # report status
        return ${env:HestiaKERNEL_ERROR_DATA_INVALID}
}
