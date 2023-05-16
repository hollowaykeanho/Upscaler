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
#
#############
# variables #
#############
repo="$(command -v $0)"
repo="${repo%%init/unix.sh}"

# arguments
action='run'
model="${UPSCALER_MODEL:-""}"
scale="${UPSCALER_SCALE:-0}"
input=""
output=""
format=""

# variables
video_mode=0
program=''
model_id=''
model_name=''
model_max_scale=''
subject_name=''
subject_ext=''
subject_dir=''
subject_suffix="${UPSCALER_SUFFIX:-"upscaled"}"
workspace=''




#############
# functions #
#############
_print_status() {
        __status_mode="$1" && shift 1
        __msg=""
        __stop_color="\033[0m"
        case "$__status_mode" in
        error)
                __msg="[ ERROR   ] ${@}"
                __start_color="\e[91m"
                ;;
        warning)
                __msg="[ WARNING ] ${@}"
                __start_color="\e[93m"
                ;;
        info)
                __msg="[ INFO    ] ${@}"
                __start_color="\e[96m"
                ;;
        success)
                __msg="[ SUCCESS ] ${@}"
                __start_color="\e[92m"
                ;;
        ok)
                __msg="[ INFO    ] == OK =="
                __start_color="\e[96m"
                ;;
        plain)
                __msg="$@"
                ;;
        *)
                return 0
                ;;
        esac

        if [ $(tput colors) -ge 8 ]; then
                __msg="${__start_color}${__msg}${__stop_color}"
        fi

        1>&2 printf "${__msg}"
        unset __status_mode __msg __start_color __stop_color

        return 0
}

_provide_help() {
        _print_status plain """
HOLLOWAY'S UPSCALER
-------------------
COMMAND:

$ ./start.cmd \\
        --model MODEL_NAME \\
        --scale SCALE_FACTOR \\
        --format FORMAT \\
        --video \\
        --input PATH_TO_FILE \\
        --output PATH_TO_FILE_OR_DIR    # optional

EXAMPLES

$ ./start.cmd \\
        --model ultrasharp \\
        --scale 4 \\
        --format webp \\
        --input my-image.jpg

$ ./start.cmd \\
        --model ultrasharp \\
        --scale 4 \\
        --format webp \\
        --input my-image.jpg \\
        --output my-image-upscaled.webp

$ ./start.cmd \\
        --model ultrasharp \\
        --scale 4 \\
        --format png \\
        --video \\
        --input my-video.mp4 \\
        --output my-video-upscaled.mp4

$ ./start.cmd \\
        --model ultrasharp \\
        --scale 4 \\
        --format png \\
        --input video/frames/input \\
        --output video/frames/output

AVAILABLE FORMATS:
(1) PNG
(2) JPG
(3) WEBP

AVAILABLE MODELS:
"""

        for model_type in "${repo}/models"/*.sh; do
                . "$model_type"

                model_id="${model_type##*/}"
                model_id="${model_id%%.*}"
                printf "ID        : ${model_id}\n"
                if [ $model_max_scale -gt 0 ]; then
                        printf "max scale : ${model_max_scale}\n"
                else
                        printf "max scale : any\n"
                fi
                printf "Purpose   : ${model_name}\n\n"
        done


        return 0
}

_check_os() {
        case "$(uname)" in
        Darwin)
                program="${repo}/bin/mac"
                ;;
        *)
                program="${repo}/bin/linux"
                ;;
        esac

        return 0
}

_check_arch() {
        program="${program}-amd64"

        return 0
}

_check_program_existence() {
        if [ ! -f "$program" ]; then
                _print_status error "missing AI executable: '${program}'.\n"
                return 1
        fi

        return 0
}

_check_model_and_scale() {
        if [ -z "$model" ]; then
                _print_status error "unspecified model.\n"
                return 1
        fi

        if [ -z $scale ]; then
                _print_status error "unspecified scaling factor.\n"
                return 1
        fi


        __supported=false
        for model_type in "${repo}/models"/*.sh; do
                model_id="${model_type##*/}"
                model_id="${model_id%%.*}"

                if [ "$model" = "$model_id" ]; then
                        __supported=true
                        . "$model_type"
                fi
        done

        if [ "$__supported" = "false" ]; then
                _print_status error "unsupported model: '${model}'.\n"
                return 1
        fi
        unset __supported


        if [ $model_max_scale -eq 0 ]; then
                if [ $scale -gt 1 ]; then
                        return 0
                else
                        _print_status error "bad scale: '${scale}'.\n"
                        return 1
                fi
        fi


        if [ $scale -gt $model_max_scale ]; then
                _print_status error "scale is too big: '${scale}/${model_max_scale}'.\n"
                return 1
        fi


        return 0
}

_check_format() {
        if [ -z "$format" ]; then
                if [ $video_mode -gt 0 ]; then
                        format='png'
                else
                        format="${input##*/}"
                        format="${format#*.}"
                fi
        fi

        case "$format" in
        jpg|JPG)
                format="jpg"
                return 0
                ;;
        png|PNG)
                format="png"
                return 0
                ;;
        webp|WEBP)
                format="webp"
                return 0
                ;;
        *)
                _print_status error "unsupported output format: '$format'.\n"
                return 1
                ;;
        esac
}

_check_io() {
        if [ "$input" = "" ]; then
                _print_status error "missing input.\n"
                return 1
        fi

        if [ ! -e "$input" ]; then
                _print_status error "input does not exist: '${input}'.\n"
                return 1
        fi

        subject_name="${input##*/}"
        subject_dir="${input%/*}"
        subject_ext="${subject_name#*.}"
        subject_name="${subject_name%%.*}"

        if [ $video_mode -gt 0 ]; then
                if [ "$(type -p ffmpeg)" = "" ]; then
                        _print_status error "missing required ffmpeg program for video.\n"
                        return 1
                fi

                if [ "$(type -p ffprobe)" = "" ]; then
                        _print_status error "missing required ffprobe program for video.\n"
                        return 1
                fi
        fi

        return 0
}

_exec_upscale_program() {
        $program -i "$1" \
                -o "$2" \
                -s "$scale" \
                -m "${repo}/models" \
                -n "$model" \
                -f "$format"
        return $?
}

_exec_program() {
        # (0) printout job info
        __output_format="$format"
        if [ $video_mode -gt 0 ]; then
                __output_format="$subject_ext"
        fi
        _print_status info """

Upscale Model    : $model
Upscale Scale    : $scale
Model Max Scale  : $model_max_scale (0=No Limit)
Upscale Format   : $format
Input File       : $input
Is Video Input   : $video_mode (0=No ; 1=Yes)

Output Directory : $subject_dir
Output Filename  : $subject_name
Output Suffix    : $subject_suffix
Output Extension : $__output_format


"""
        unset __output_format

        # (1) execute image upscale if it's not a video job.
        if [ $video_mode -eq 0 ]; then
                output="${subject_dir}/${subject_name}-${subject_suffix}.${format}"
                _exec_upscale_program "$input" "$output"

                output=$?
                if [ $output -eq 0 ]; then
                        _print_status success "\n"
                fi
                return $?
        fi

        # (2) setup video workspace
        workspace="${subject_dir}/${subject_name}-${subject_suffix}_workspace"
        control="${workspace}/control.sh"

        # (3) analyze input video and initialize sentinel variables
        video_codec="$(ffprobe -v error \
                        -select_streams v:0 \
                        -show_entries stream=codec_name \
                        -of default=noprint_wrappers=1:nokey=1 \
                        "$input"
        )"
        audio_codec="$(
                ffprobe -v error \
                        -select_streams a:0 \
                        -show_entries stream=codec_name \
                        -of default=noprint_wrappers=1:nokey=1 \
                        "$input"
        )"
        frame_rate="$(
                ffprobe -v error \
                        -select_streams v \
                        -of default=noprint_wrappers=1:nokey=1 \
                        -show_entries stream=r_frame_rate \
                        "$input"
        )"
        total_frames="$(
                ffprobe -v error \
                        -select_streams v:0 \
                        -count_frames \
                        -show_entries stream=nb_read_frames \
                        -of default=nokey=1:noprint_wrappers=1 \
                        "$input"
        )"
        input_frame_size="$(
                ffprobe \
                        -v error \
                        -select_streams v:0 \
                        -show_entries stream=width,height \
                        -of csv=s=x:p=0 \
                        "$input"
        )"
        pixel_format=""
        output_frame_size=""
        current_frame=0

        # (4) recover from last status for job continuation if available
        if [ -f "$control" ]; then
                _print_status info "Found control file ($control). Restoring...\n\n"
                . "$control"
        else
                _print_status info "Creating workspace...\n\n"
                rm -rf "${workspace}" &> /dev/null
                mkdir -p "${workspace}/frames"
        fi
        _print_status info """

Video Name     : ${subject_name}.${subject_ext}
Video Codec    : ${video_codec}
Audio Codec    : ${audio_codec}
Pixel Format   : ${pixel_format} (empty means yet to determine)
Input Frame    : ${input_frame_size}
Output Frame   : ${output_frame_size} (empty means yet to determine)

Frame Rate     : ${frame_rate}
Total Frames   : ${total_frames}
Current Frame  : ${current_frame}
"""
        # (5) loop through 1 frame at a time for large video upscaling
        while [ $current_frame -lt $total_frames ]; do
                # print status
                _print_status info "Upscaling frame ${current_frame}/${total_frames}...\n"

                # extract 1 frame
                img="${workspace}/sample.${format}"
                ffmpeg -y \
                        -thread_queue_size 4096 \
                        -i "$input" \
                        -vf select="'eq(n\,${current_frame})'" \
                        -vframes 1 \
                        "$img" \
                &> /dev/null
                if [ $? -ne 0 ]; then
                        _print_status error
                        exit 1
                fi

                # upscale the frame
                output="${workspace}/frames/0${current_frame}.${format}"
                _exec_upscale_program "$img" "$output"
                if [ $? -ne 0 ]; then
                        _print_status error
                        exit 1
                fi

                if [ "$pixel_format" = "" ]; then
                        pixel_format="$(ffprobe \
                                -loglevel error \
                                -show_entries \
                                stream=pix_fmt \
                                -of csv=p=0 \
                                "${output}"
                        )"
                fi

                if [ "$output_frame_size" = "" ]; then
                        output_frame_size="$(ffprobe \
                                -v error \
                                -select_streams v:0 \
                                -show_entries stream=width,height \
                                -of csv=s=x:p=0 \
                                "${output}"
                        )"
                fi

                rm "$img" &> /dev/null

                # save settings to control file for future continuation
                printf """\
#!/bin/bash
total_frames=${total_frames}
current_frame=$(($current_frame+1))
pixel_format="${pixel_format}"
frame_rate="${frame_rate}"
video_codec="${video_codec}"
audio_codec="${audio_codec}"
input_frame_size="${input_frame_size}"
output_frame_size="${output_frame_size}"
""" > "$control"
                if [ $? -ne 0 ]; then
                        _print_status error
                        exit 1
                fi
                _print_status success "frame ${current_frame}/${total_frames} upscaled.\n\n"

                # increase frame count
                current_frame=$(($current_frame + 1))
        done

        # (6) run ffmpeg to merge the frames to new video
        output="${subject_dir}/${subject_name}-${subject_suffix}.${subject_ext}"
        ffmpeg -y \
                -thread_queue_size 4096 \
                -i "$input" \
                -r "$frame_rate" \
                -thread_queue_size 4096 \
                -i "${workspace}/frames/0%d.${format}" \
                -c:v "$video_codec" \
                -pix_fmt "$pixel_format" \
                -r "$frame_rate" \
                -filter_complex "[0:v:0]scale=${output_frame_size}[v0];[v0][1]overlay=eof_action=pass" \
                -c:a copy \
                "$output"

        output=$?
        if [ $output -eq 0 ]; then
                _print_status success "\n"
        fi
        return $?
}

main() {
        if [ "$*" = "" ]; then
                _provide_help
                exit 0
        fi

        # parse argument
        while [ $# -ne 0 ]; do
        case "$1" in
                --help|-h|help)
                        _provide_help
                        exit 0
                        ;;
                --video|-vd)
                        video_mode=1
                        ;;
                --model|-m)
                        if [ "$2" != "" ] && [ "$(printf "%.1s" "$2")" != "-" ]; then
                                model="$2"
                                shift 1
                        fi
                        ;;
                --scale|-s)
                        if [ "$2" != "" ] && [ "$(printf "%.1s" "$2")" != "-" ]; then
                                scale="$2"
                                shift 1
                        fi
                        ;;
                --input|-i)
                        if [ "$2" != "" ] && [ "$(printf "%.1s" "$2")" != "-" ]; then
                                input="$2"
                                shift 1
                        fi
                        ;;
                --output|-o)
                        if [ "$2" != "" ] && [ "$(printf "%.1s" "$2")" != "-" ]; then
                                output="$2"
                                shift 1
                        fi
                        ;;
                --format|-f)
                        if [ "$2" != "" ] && [ "$(printf "%.1s" "$2")" != "-" ]; then
                                format="$2"
                                shift 1
                        fi
                        ;;
                *)
                        ;;
                esac
                shift 1
        done

        # run function
        _check_os
        if [ $? -ne 0 ]; then
                exit 1
        fi

        _check_arch
        if [ $? -ne 0 ]; then
                exit 1
        fi

        _check_program_existence
        if [ $? -ne 0 ]; then
                exit 1
        fi

        _check_model_and_scale
        if [ $? -ne 0 ]; then
                exit 1
        fi

        _check_format
        if [ $? -ne 0 ]; then
                exit 1
        fi

        _check_io
        if [ $? -ne 0 ]; then
                exit 1
        fi

        _exec_program
        if [ $? -ne 0 ]; then
                exit 1
        fi
}
main "$@"
