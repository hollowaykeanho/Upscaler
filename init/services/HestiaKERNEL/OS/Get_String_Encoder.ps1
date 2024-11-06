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




function HestiaKERNEL-Get-String-Encoder {
        # execute
        switch ($OutputEncoding.BodyName.ToUpper()) {
        "UTF-8" {
                return ${env:HestiaKERNEL_UTF8}
        } "UTF-16" {
                return ${env:HestiaKERNEL_UTF16BE}
        } "UTF-32" {
                return ${env:HestiaKERNEL_UTF32BE}
        } "default" {
                return ${env:HestiaKERNEL_UTF_UNKNOWN}
        }}
}
