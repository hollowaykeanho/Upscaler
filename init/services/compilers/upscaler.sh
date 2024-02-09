#!/bin/sh
#
# BSD 3-Clause License
#
# Copyright (c) 2023, (Holloway) Chew, Kean Ho
# All rights reserved.
#
# Redistribution and use in source and binary forms, with or without
# modification, are permitted provided that the following conditions are met:
#
# 1. Redistributions of source code must retain the above copyright notice, this
#    list of conditions and the following disclaimer.
#
# 2. Redistributions in binary form must reproduce the above copyright notice,
#    this list of conditions and the following disclaimer in the documentation
#    and/or other materials provided with the distribution.
#
# 3. Neither the name of the copyright holder nor the names of its
#    contributors may be used to endorse or promote products derived from
#    this software without specific prior written permission.
#
# THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
# AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
# IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
# DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE
# FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
# DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
# SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
# CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
# OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
# OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
. "${LIBS_UPSCALER}/services/io/os.sh"
. "${LIBS_UPSCALER}/services/io/fs.sh"




UPSCALER_Is_Available() {
        case "$(OS_Host_System)" in
        linux)
                ___program="${UPSCALER_PATH_ROOT}/bin/linux"
                ;;
        darwin)
                ___program="${UPSCALER_PATH_ROOT}/bin/mac"
                ;;
        *)
                return 1
                ;;
        esac


        case "$(OS_Host_Arch)" in
        amd64)
                ___program="${___program}-amd64"
                ;;
        *)
                return 1
                ;;
        esac


        FS_Is_Target_Exist "$___program"
        if [ $? -ne 0 ]; then
                return 1
        fi


        # report status
        return 0
}




UPSCALER_Model_Get() {
        #___id="$1"


        # validate input
        if [ -z "$1" ]; then
                printf -- ""
                return 1
        fi


        # execute
        for ___model in "${UPSCALER_PATH_ROOT}/models"/*.sh; do
                ___model_ID="${___model##*/}"
                ___model_ID="${___model_ID%%.*}"

                if [ ! "$1" = "$___model_ID" ]; then
                        continue
                fi

                # given ID is a valid model
                . "$___model"
                ___model_NAME="${model_name}"
                ___model_SCALE_MAX="any"
                if [ "$model_max_scale" -gt 0 ]; then
                         ___model_SCALE_MAX="${model_max_scale}"
                fi

                printf "%b│%b│%b" "$___model_ID" "$___model_SCALE_MAX" "$___model_NAME"
                return 0
        done


        # report status
        printf -- ""
        return 1
}




UPSCALER_Scale_Get() {
        #___limit="$1"
        #___input="$2"


        # validate input
        if [ -z "$1" ]; then
                printf -- ""
                return 1
        fi


        # execute
        case "$1" in
        any)
                case "$2" in
                1|2|3|4)
                        printf -- "%b" "$2"
                        return 0
                        ;;
                *)
                        ;;
                esac
                ;;
        1)
                case "$2" in
                1)
                        printf -- "1"
                        return 0
                        ;;
                *)
                        ;;
                esac
                ;;
        2)
                case "$2" in
                2)
                        printf -- "2"
                        return 0
                        ;;
                *)
                        ;;
                esac
                ;;
        3)
                case "$2" in
                3)
                        printf -- "3"
                        return 0
                        ;;
                *)
                        ;;
                esac
                ;;
        4)
                case "$2" in
                4)
                        printf -- "4"
                        return 0
                        ;;
                *)
                        ;;
                esac
                ;;
        *)
                ;;
        esac


        # report status
        printf -- ""
        return 1
}
