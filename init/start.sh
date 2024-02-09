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
if [ "$UPSCALER_PATH_ROOT" == "" ]; then
        1>&2 printf "[ ERROR ] - Please run from start.sh.ps1 instead!\n"
        exit 1
fi




# determine UPSCALER_PATH_PWD
export UPSCALER_PATH_PWD="$PWD"
export UPSCALER_PATH_SCRIPTS="init"


# determine UPSCALER_PATH_ROOT
if [ -f "./start.sh" ]; then
        # user is inside the init directory.
        UPSCALER_PATH_ROOT="${PWD%/*}/"
elif [ -f "./${UPSCALER_PATH_SCRIPTS}/start.sh" ]; then
        # current directory is the root directory.
        UPSCALER_PATH_ROOT="$PWD"
else
        # scan from root directory until the first hit.
        __pathing="$UPSCALER_PATH_PWD"
        __previous=""
        while [ "$__pathing" != "" ]; do
                UPSCALER_PATH_ROOT="${UPSCALER_PATH_ROOT}${__pathing%%/*}/"
                __pathing="${__pathing#*/}"
                if [ -f "${UPSCALER_PATH_ROOT}${UPSCALER_PATH_SCRIPTS}/start.sh" ]; then
                        break
                fi

                # stop the scan if the previous pathing is the same as current
                if [ "$__previous" = "$__pathing" ]; then
                        1>&2 printf "[ ERROR ] Missing root directory.\n"
                        exit 1
                fi
                __previous="$__pathing"
        done
        unset __pathing __previous
        export UPSCALER_PATH_ROOT="${UPSCALER_PATH_ROOT%/*}"

        if [ ! -f "${UPSCALER_PATH_ROOT}/${UPSCALER_PATH_SCRIPTS}/start.sh" ]; then
                1>&2 printf "[ ERROR ] Missing root directory.\n"
                return 1
        fi
fi

export LIBS_UPSCALER="${UPSCALER_PATH_ROOT}/${UPSCALER_PATH_SCRIPTS}"




# import fundamental libraries
. "${LIBS_UPSCALER}/services/io/strings.sh"
. "${LIBS_UPSCALER}/services/compilers/upscaler.sh"
. "${LIBS_UPSCALER}/services/i18n/error-unsupported.sh"
. "${LIBS_UPSCALER}/services/i18n/error-model-unknown.sh"
. "${LIBS_UPSCALER}/services/i18n/error-scale-unknown.sh"
. "${LIBS_UPSCALER}/services/i18n/help.sh"




# execute command
__help="false"
__model=""
__scale=""
__format=""
__parallel=""
__video="false"
__input=""
__output=""
__gpu=""

while [ -n "$1" ]; do
        case "$1" in
        -h|--help|help)
                __help="true"
                ;;
        --model)
                if [ ! -z "$2" ] && [ "$(printf "%.1s" "$2")" != "-" ]; then
                        __model="$2"
                        shift 1
                fi
                ;;
        --scale)
                if [ ! -z "$2" ] && [ "$(printf "%.1s" "$2")" != "-" ]; then
                        __scale="$2"
                        shift 1
                fi
                ;;
        --format)
                if [ ! -z "$2" ] && [ "$(printf "%.1s" "$2")" != "-" ]; then
                        __format="$2"
                        shift 1
                fi
                ;;
        --parallel)
                if [ ! -z "$2" ] && [ "$(printf "%.1s" "$2")" != "-" ]; then
                        __parallel="$2"
                        shift 1
                fi
                ;;
        --video)
                __video="true"
                ;;
        --input)
                if [ ! -z "$2" ] && [ "$(printf "%.1s" "$2")" != "-" ]; then
                        __input="$2"
                        shift 1
                fi
                ;;
        --output)
                if [ ! -z "$2" ] && [ "$(printf "%.1s" "$2")" != "-" ]; then
                        __output="$2"
                        shift 1
                fi
                ;;
        --gpu)
                if [ ! -z "$2" ] && [ "$(printf "%.1s" "$2")" != "-" ]; then
                        __gpu="$2"
                        shift 1
                fi
                ;;
        esac
        shift 1
done




# serve help printout and then bail out
if [ "$__help" == "true" ]; then
        I18N_Status_Print_Help
        return 0
fi




# verify host system is supported
UPSCALER_Is_Available
if [ $? -ne 0 ]; then
        I18N_Status_Error_Unsupported
        return 1
fi




# process model requirements
___process="$(UPSCALER_Model_Get "$__model")"
if [ -z "$___process" ]; then
        I18N_Status_Error_Model_Unknown
        return 1
fi
__model="${___process%%│*}"
__model_name="${___process##*│}"
___process="${___process#*│}"


__scale="$(UPSCALER_Scale_Get "${___process%%│*}" "$__scale")"
if [ -z "$__scale" ]; then
        I18N_Status_Error_Scale_Unknown
        return 1
fi



# placeholder
printf "DEBUG model='%s' scale='%s' format='%s' parallel='%s' video='%s' input='%s' output='%s' gpu='%s' \n" \
        "$__model" \
        "$__scale" \
        "$__format" \
        "$__parallel" \
        "$__video" \
        "$__input" \
        "$__output" \
        "$__gpu"

