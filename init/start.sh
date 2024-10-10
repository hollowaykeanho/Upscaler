#!/bin/sh
# Copyright 2024 (Holloway) Chew, Kean Ho <hello@hollowaykeanho.com>
# Copyright 2024 Joly0 [https://github.com/Joly0]
#
#
# BSD 3-Clause License
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
if [ "$UPSCALER_PATH_ROOT" = "" ]; then
        1>&2 printf "[ ERROR ] - Please run from start.sh.ps1 instead!\n"
        exit 1
fi




# determine UPSCALER_PATH_PWD
UPSCALER_PATH_PWD="$PWD"
UPSCALER_PATH_SCRIPTS="init"




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
        UPSCALER_PATH_ROOT="${UPSCALER_PATH_ROOT%/*}"

        if [ ! -f "${UPSCALER_PATH_ROOT}/${UPSCALER_PATH_SCRIPTS}/start.sh" ]; then
                1>&2 printf "[ ERROR ] Missing root directory.\n"
                return 1
        fi
fi

LIBS_UPSCALER="${UPSCALER_PATH_ROOT}/${UPSCALER_PATH_SCRIPTS}"
LIBS_HESTIA="${LIBS_UPSCALER}/services"


# import fundamental libraries
. "${LIBS_UPSCALER}/services/io/strings.sh"
. "${LIBS_UPSCALER}/services/compilers/ffmpeg.sh"
. "${LIBS_UPSCALER}/services/compilers/upscaler.sh"
. "${LIBS_UPSCALER}/services/i18n/error-ffmpeg-unavailable.sh"
. "${LIBS_UPSCALER}/services/i18n/error-format-unsupported.sh"
. "${LIBS_UPSCALER}/services/i18n/error-gpu-unsupported.sh"
. "${LIBS_UPSCALER}/services/i18n/error-input-unknown.sh"
. "${LIBS_UPSCALER}/services/i18n/error-input-unsupported.sh"
. "${LIBS_UPSCALER}/services/i18n/error-model-unknown.sh"
. "${LIBS_UPSCALER}/services/i18n/error-parallel-unsupported.sh"
. "${LIBS_UPSCALER}/services/i18n/error-scale-unknown.sh"
. "${LIBS_UPSCALER}/services/i18n/error-unsupported.sh"
. "${LIBS_UPSCALER}/services/i18n/error-video-setup.sh"
. "${LIBS_UPSCALER}/services/i18n/error-video-upscale.sh"
. "${LIBS_UPSCALER}/services/i18n/help.sh"
. "${LIBS_UPSCALER}/services/i18n/report-info.sh"
. "${LIBS_UPSCALER}/services/i18n/report-success.sh"

### TEST ZONE
. "${LIBS_HESTIA}/HestiaKERNEL/Trim_Left_String.sh"
1>&2 printf -- "%s\n" "$(HestiaKERNEL_Trim_Left_String "e你feeeff你你aerg aegE你F" "e你a")"

. "${LIBS_HESTIA}/HestiaKERNEL/To_Unicode_From_UTF8.sh"
1>&2 printf -- "%s\n" "$(HestiaKERNEL_To_Unicode_From_UTF8 "228, 189, 160, 97, 229, 165, 189, 98")"
### expect 20320, 97, 22909, 98


# execute command
__help="false"
__model=""
__scale=""
__format=""
__parallel=""
__video="0"
__batch="0"
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
                __video="1"
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




# process input
FS_Is_Target_Exist "$__input"
if [ $? -ne 0 ]; then
        I18N_Status_Error_Input_Unknown
        return 1
fi

__mime="$(FS_Get_MIME "$__input")"
case "$__mime" in
image/jpeg|image/png)
        __batch="0"
        __video="0"
        ;;
video/mp4)
        __batch="0"
        __video="1"
        ;;
inode/directory)
        __batch="1"
        ;;
*)
        I18N_Status_Error_Input_Unsupported "$__mime"
        return 1
        ;;
esac




# process gpu
__gpu="${__gpu:-0}"
if [ "$(STRINGS_Is_Empty "$UPSCALER_TEST_MODE")" = "0" ]; then
        UPSCALER_GPU_Verify "$__gpu"
        if [ $? -ne 0 ]; then
                I18N_Status_Error_GPU_Unsupported "$__gpu"
                return 1
        fi
fi




# process parallelism
__parallel="${__parallel:-1}"
if [ "$__parallel" -eq "$__parallel" ]  2>/dev/null; then
        :
else
        I18N_Status_Error_Parallel_Unsupported "$__parallel"
        return 1
fi




# process format
__format="$(UPSCALER_Format_Validate "${__format:-native}")"
if [ "$(STRINGS_Is_Empty "$__format")" = "0" ]; then
        I18N_Status_Error_Format_Unsupported
        return 1
fi




# execute
if [ "$__video" = "0" ] && [ "$__batch" = "0" ]; then
        __output="$(UPSCALER_Output_Filename_Image "$__output" "$__input" "$__format")"


        # report task info
        I18N_Report_Info \
                "${__batch}" \
                "${__video}" \
                "${__model}" \
                "${__scale}" \
                "${__format}" \
                "${__parallel}" \
                "${__gpu}" \
                "${__input}" \
                "${__output}"


        # begin processing
        UPSCALER_Run_Image \
                "${__model}" \
                "${__scale}" \
                "${__format}" \
                "${__gpu}" \
                "${__input}" \
                "${__output}"
        if [ $? -eq 0 ]; then
                I18N_Report_Success
                return 0
        fi
elif [ "$__video" = "1" ]; then
        FFMPEG_Is_Available
        if [ $? -ne 0 ]; then
                I18N_Error_FFMPEG_Unavailable
                return 1
        fi

        __output="$(UPSCALER_Output_Filename_Video "$__output" "$__input")"


        # attempt to parse workspace
        UPSCALER_Batch_Load "${__video}" \
                "${__model}" \
                "${__scale}" \
                "${__format}" \
                "${__parallel}" \
                "${__gpu}" \
                "${__input}" \
                "${__output}"
        if [ $? -ne 0 ]; then
                FFMPEG_Video_Dissect "${__input}" "${__output}"
                if [ $? -ne 0 ]; then
                        I18N_Error_FFMPEG_Dissect
                        return 1
                fi


                UPSCALER_Batch_Setup "${__video}" \
                        "${__model}" \
                        "${__scale}" \
                        "${__format}" \
                        "${__parallel}" \
                        "${__gpu}" \
                        "${__input}" \
                        "${__output}"
                if [ $? -ne 0 ]; then
                        I18N_Error_Video_Setup
                        return 1
                fi
        fi


        # report task info
        I18N_Report_Info \
                "${__batch}" \
                "${__video}" \
                "${__model}" \
                "${__scale}" \
                "${__format}" \
                "${__parallel}" \
                "${__gpu}" \
                "${__input}" \
                "${__output}"


        # execute
        UPSCALER_Batch_Run \
                "${__video}" \
                "${__model}" \
                "${__scale}" \
                "${__format}" \
                "${__parallel}" \
                "${__gpu}" \
                "${__input}" \
                "${__output}"
        if [ $? -ne 0 ]; then
                I18N_Error_Video_Upscale
                return 1
        fi


        # assemble back to video
        FFMPEG_Video_Reassemble "${__input}" "${__output}"
        if [ $? -eq 0 ]; then
                I18N_Report_Success
                return 0
        fi
elif [ "$__batch" = "1" ]; then
        :
fi

return 1
