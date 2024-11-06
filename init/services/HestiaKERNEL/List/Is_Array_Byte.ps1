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
. "${env:LIBS_HESTIA}\HestiaKERNEL\List\Is_Array_Number.ps1"




function HestiaKERNEL-Is-Array-Byte {
        param (
                [byte[]]$___content
        )


        # validate input
        if ($___content.Length -eq 0) {
                return ${env:HestiaKERNEL_ERROR_DATA_EMPTY}
        }

        if ($(HestiaKERNEL-Is-Array-Number $___content) -ne ${env:HestiaKERNEL_ERROR_OK}) {
                return ${env:HestiaKERNEL_ERROR_DATA_INVALID}
        }


        # execute
        ## IMPORTANT NOTICE: Powershell's uint8 (byte type) parameter check is
        ## suffice.


        # report status
        return ${env:HestiaKERNEL_ERROR_OK}
}
