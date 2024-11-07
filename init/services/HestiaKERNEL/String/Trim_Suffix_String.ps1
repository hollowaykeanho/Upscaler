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
. "${env:LIBS_HESTIA}\HestiaKERNEL\String\To_String_From_Unicode.ps1"
. "${env:LIBS_HESTIA}\HestiaKERNEL\Unicode\Trim_Suffix_Unicode.ps1"
. "${env:LIBS_HESTIA}\HestiaKERNEL\Unicode\To_Unicode_From_String.ps1"




function HestiaKERNEL-Trim-Suffix-String {
        param (
                [string]$___input,
                [string]$___suffix
        )


        # validate input
        if (
                ($___input -eq "") -or
                ($___suffix -eq "")
        ) {
                return $___input
        }


        # execute
        $___content = HestiaKERNEL-To-Unicode-From-String $___input
        if ($___content.Length -eq 0) {
                return $___input
        }

        $___chars = HestiaKERNEL-To-Unicode-From-String $___suffix
        if ($___chars.Length -eq 0) {
                return $___input
        }

        $___content = HestiaKERNEL-Trim-Suffix-Unicode $___content $___chars
        if ($___content.Length -eq 0) {
                return $___input
        }


        # report status
        return HestiaKERNEL-To-String-From-Unicode $___content
}
