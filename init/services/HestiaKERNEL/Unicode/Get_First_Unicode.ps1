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
. "${env:LIBS_HESTIA}\HestiaKERNEL\Unicode\Unicode.ps1"




function HestiaKERNEL-Get-First-Unicode {
        param (
                [uint32[]]$___content_unicode
        )


        # validate input
        if ($___content_unicode.Length -le 0) {
                return ${env:HestiaKERNEL_UNICODE_ERROR}
        }


        # execute
        return $___content_unicode[0]
}
