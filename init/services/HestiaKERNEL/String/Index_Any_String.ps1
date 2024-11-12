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
. "${env:LIBS_HESTIA}\HestiaKERNEL\Unicode\Index_Any_Unicode.ps1"
. "${env:LIBS_HESTIA}\HestiaKERNEL\Unicode\To_Unicode_From_String.ps1"




function HestiaKERNEL-Index-Any-String {
        param (
                [string]$___input,
                [string]$___target,
                [string]$___from_right
        )


        # execute
        $___content = HestiaKERNEL-To-Unicode-From-String $___input
        $___chars = HestiaKERNEL-To-Unicode-From-String $___target


        # report status
        return HestiaKERNEL-Index-Any-Unicode $___content $___chars $___from_right
}
