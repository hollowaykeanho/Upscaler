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
. "${env:LIBS_HESTIA}\HestiaKERNEL\Number\Is_Number.ps1"




function HestiaKERNEL-Is-Whitespace-Unicode {
        param (
                [uint32]$___unicode
        )


        # validate input
        if ($(HestiaKERNEL-Is-Number $___unicode) -ne ${env:HestiaKERNEL_ERROR_OK}) {
                return ${env:HestiaKERNEL_ERROR_DATA_INVALID}
        }


        # execute
        switch ($___unicode) {
        { $_ -in 9, 10, 11, 12, 13, 32, 133, 160 } {
                #  9    | 10   | 11   | 12   | 13   | 32   | 133  | 160
                # 0x0009|0x000A|0x000B|0x000C|0x000D|0x0020|0x0085|0x00A0
                # '\t'  , '\n' , '\v' , '\f' , '\r' , ' '  , NEL  , NBSP
                return ${env:HestiaKERNEL_ERROR_OK}
        } default {
                return ${env:HestiaKERNEL_ERROR_DATA_INVALID}
        }}
}
