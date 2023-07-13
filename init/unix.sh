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
parallel=1
source_file=""
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
phase=0




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
        --parallel TOTAL_WORKING_THREADS  # only for video upscaling \\
        --video                           # only for video upscaling \\
        --input PATH_TO_FILE \\
        --output PATH_TO_FILE_OR_DIR      # optional

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
        --parallel 1 \\
        --video \\
        --input my-video.mp4 \\
        --output my-video-upscaled.mp4

$ ./start.cmd \\
        --model ultrasharp \\
        --scale 4 \\
        --format png \\
        --parallel 1 \\
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
                        format="${source_file##*/}"
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
        if [ "$source_file" = "" ]; then
                _print_status error "missing input.\n"
                return 1
        fi

        if [ ! -e "$source_file" ]; then
                _print_status error "input does not exist: '${source_file}'.\n"
                return 1
        fi

        subject_name="${source_file##*/}"
        subject_dir="${source_file%/*}"
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

                if [ ! $parallel -eq $parallel 2> /dev/null ]; then
                        _print_status error "unknown parallel value: ${parallel}.\n"
                        return 1
                fi

                if [ $parallel -lt 1 ]; then
                        _print_status error "parallel must be 1 and above: ${parallel}.\n"
                        return 1
                fi
        fi

        return 0
}

____save_workspace_controller() {
        # ARG1 = Phase ID
        printf """\
#!/bin/bash
phase=${1}
source_file="${source_file}"
total_frames=${total_frames}
frame_rate="${frame_rate}"
video_codec="${video_codec}"
audio_codec="${audio_codec}"
input_frame_size="${input_frame_size}"
""" > "$control"
        if [ $? -ne 0 ]; then
                 _print_status error
                return 1
        fi


        return 0
}

____exec_upscale_program() {
        $program -i "$1" \
                -o "$2" \
                -s "$scale" \
                -m "${repo}/models" \
                -n "$model" \
                -f "$format"


        return $?
}

___generate_frame_input_name() {
        printf "${workspace}/frames/input_0${1}.${format}"
}

___generate_frame_output_name() {
        printf "${workspace}/frames/output_0${1}.${format}"
}

___generate_frame_output_naming_pattern() {
        printf "${workspace}/frames/output_0%%d.${format}"
}

___generate_frame_working_name() {
        printf "${workspace}/frames/working-0${1}"
}

___generate_frame_done_name() {
        printf "${workspace}/frames/done-0${1}"
}

___generate_frame_error_name() {
        printf "${workspace}/frames/error-0${1}"
}

___upscale_a_frame_in_parallel() {
        # ARG1: input path
        # ARG2: output path
        # ARG3: working flag path
        # ARG4: done flag path
        # ARG5: error flag path


        # denote working status
        mkdir -p "$3"


        # perform upscale
        ____exec_upscale_program "$1" "$2"
        if [ $? -ne 0 ]; then
                mkdir -p "$5"
                rm -rf "$3"
                return 1
        fi


        # remove working status
        rm -rf "$3"


        # denote done status
        mkdir -p "$4"


        # end process
        return 0
}

__print_job_info() {
        __output_format="$format"
        ___video_mode="No"
        if [ $video_mode -gt 0 ]; then
                __output_format="$subject_ext"
                ___video_mode="Yes"
        fi


        ___model_max_scale='unspecified'
        if [ $model_max_scale -gt 0 ]; then
                ___model_max_scale="$model_max_scale"
        fi


        _print_status info """
Upscale Model    : $model
Upscale Scale    : $scale
Model Max Scale  : $___model_max_scale
Upscale Format   : $format
Input File       : $source_file
Is Video Input   : $___video_mode

Output Directory : $subject_dir
Output Filename  : $subject_name
Output Suffix    : $subject_suffix
Output Extension : $__output_format


"""
        unset __output_format ___video_mode ___model_max_scale
}

__upscale_if_image() {
        if [ $video_mode -eq 0 ]; then
                output="${subject_dir}/${subject_name}-${subject_suffix}.${format}"
                ____exec_upscale_program "$source_file" "$output"
                if [ $? -eq 0 ]; then
                        _print_status success "\n"
                        return 0
                fi


                _print_status error
                return 1
        fi
}

__setup_video_workspace() {
        # setup variables
        workspace="${subject_dir}/${subject_name}-${subject_suffix}_workspace"
        control="${workspace}/control.sh"


        # analyze input video and initialize sentinel variables
        video_codec="$(ffprobe -v error \
                        -select_streams v:0 \
                        -show_entries stream=codec_name \
                        -of default=noprint_wrappers=1:nokey=1 \
                        "$source_file"
        )"
        audio_codec="$(
                ffprobe -v error \
                        -select_streams a:0 \
                        -show_entries stream=codec_name \
                        -of default=noprint_wrappers=1:nokey=1 \
                        "$source_file"
        )"
        frame_rate="$(
                ffprobe -v error \
                        -select_streams v \
                        -of default=noprint_wrappers=1:nokey=1 \
                        -show_entries stream=r_frame_rate \
                        "$source_file"
        )"
        total_frames="$(($(
                ffprobe -v error \
                        -select_streams v:0 \
                        -count_frames \
                        -show_entries stream=nb_read_frames \
                        -of default=nokey=1:noprint_wrappers=1 \
                        "$source_file"
        ) - 1))" # NOTE: system uses 0 as a starting point so we -1 out
        input_frame_size="$(
                ffprobe \
                        -v error \
                        -select_streams v:0 \
                        -show_entries stream=width,height \
                        -of csv=s=x:p=0 \
                        "$source_file"
        )"
        current_frame=0
        phase=0


        # recover from last status for job continuation if available
        if [ -f "$control" ]; then
                _print_status info "\nFound control file ($control).\nRestoring...\n"
                . "$control"
                _print_status info "COMPLETED\n\n\n"
        else
                _print_status info "\nCreating workspace...\n"
                rm -rf "${workspace}" &> /dev/null
                mkdir -p "${workspace}/frames"

                # save settings to control file in not available
                ____save_workspace_controller 0
                if [ $? -ne 0 ]; then
                         _print_status error "\n"
                        return 1
                fi

                _print_status info "COMPLETED\n\n\n"
        fi


        _print_status info """
Video Name     : ${subject_name}.${subject_ext}
Video Codec    : ${video_codec}
Audio Codec    : ${audio_codec}
Input Frame    : ${input_frame_size}

Frame Rate     : ${frame_rate}
Total Frames   : $((total_frames + 1))
Work Phase     : ${phase}

Total Threads  : ${parallel}


"""


        return 0
}

__generate_frames() {
        _print_status info "PHASE 1 - FRAME EXTRACTION\n"


        # skip if it was marked completed.
        if [ $phase -ge 1 ]; then
                _print_status info "COMPLETED\n\n"
                return 0
        fi


        # generate each frame selectively for highest quality extraction.
        while [ $current_frame -le $total_frames ]; do
                # prepare output
                output="$(___generate_frame_input_name "$current_frame")"
                _print_status info "Extracting frame ${current_frame}/$total_frames...\r"

                # extract frame
                ffmpeg -y \
                        -hide_banner \
                        -loglevel error \
                        -thread_queue_size 4096 \
                        -i "$source_file" \
                        -vf select="'eq(n\,${current_frame})'" \
                        -vframes 1 \
                        "$output" \
                &> /dev/null
                if [ $? -ne 0 ]; then
                        _print_status error
                        return 1
                fi

                # increase frame count
                current_frame=$(($current_frame + 1))
        done
        unset input output
        _print_status info "\n"


        # remove all done flags
        current_frame=0
        while [ $current_frame -lt $total_frames ]; do
                input="$(___generate_frame_done_name "$current_frame")"

                rm -rf "$input" &> /dev/null

                current_frame=$(($current_frame + 1))
        done
        unset input current_frame


        # save settings to control file in case of future continuation
        ____save_workspace_controller 2
        if [ $? -ne 0 ]; then
                 _print_status error "\n"
                return 1
        fi


        # report and return
        _print_status info "COMPLETED\n\n"
        return 0
}

__upscale_frames() {
        _print_status info "PHASE 2 - FRAMES UPSCALE\n"


        # skip if it was completed
        if [ $phase -ge 2 ]; then
                _print_status info "COMPLETED\n\n"
                return 0
        fi


        # remove all error and working flags
        current_frame=0
        while [ $current_frame -lt $total_frames ]; do
                working="$(___generate_frame_working_name "$current_frame")"
                error="$(___generate_frame_error_name "$current_frame")"

                rm -rf "$working" "$error" &> /dev/null

                current_frame=$(($current_frame + 1))
        done


        # scan for each input and manage upscaling task in parallel
        current_frame=0
        done_frame=0
        working_frame=0
        while [ $current_frame -le $total_frames ]; do
                input="$(___generate_frame_input_name "$current_frame")"
                output="$(___generate_frame_output_name "$current_frame")"
                working="$(___generate_frame_working_name "$current_frame")"
                completed="$(___generate_frame_done_name "$current_frame")"
                error="$(___generate_frame_error_name "$current_frame")"

                # break if error flag is found
                if [ -d "$error" ]; then
                        _print_status error "Frame $input has error!\n"
                        return 1
                fi

                # skip frame if working flag is found
                if [ -d "$working" ]; then
                        working_frame=$(($working_frame + 1))

                        # increase frame count
                        current_frame=$(($current_frame + 1))
                        if [ $current_frame -gt $total_frames ]; then
                                done_frame=0
                                current_frame=0
                                working_frame=0
                        fi

                        continue
                fi

                # skip frame if done flag is found or break loop if entirely completed
                if [ $done_frame -gt $total_frames ]; then
                        break
                elif [ -d "$completed" ]; then
                        done_frame=$(($done_frame + 1))

                        # increase frame count
                        current_frame=$(($current_frame + 1))

                        continue
                fi

                # So it's not done. Assign to parallel executor when available
                if [ $working_frame -lt $parallel ]; then
                        _print_status info "Starting frame ${current_frame}...\n"
                        { ___upscale_a_frame_in_parallel "$input" \
                                                        "$output" \
                                                        "$working" \
                                                        "$completed" \
                                                        "$error"
                        } &

                        working_frame=$(($working_frame + 1))
                fi

                # check if the entire upscaling process is done

                # increase frame count
                current_frame=$(($current_frame + 1))
                if [ $current_frame -gt $total_frames ]; then
                        done_frame=0
                        current_frame=0
                        working_frame=0
                fi
        done
        unset done_frame current_frame working_frame input output working completed error


        # save settings to control file in case of future continuation
        ____save_workspace_controller 2
        if [ $? -ne 0 ]; then
                 _print_status error "\n"
                return 1
        fi


        # report and return
        _print_status info "COMPLETED\n\n"
        return 0
}

__reassemble_video() {
        _print_status info "PHASE 3 - REASSEMBLE VIDEO\n"


        # skip if it was completed
        if [ $phase -ge 3 ]; then
                _print_status info "COMPLETED\n\n"
                return 0
        fi


        # determine pixel format and frame size from first frame
        output="$(___generate_frame_output_name "0")"
        pixel_format="$(ffprobe \
                -loglevel error \
                -show_entries \
                stream=pix_fmt \
                -of csv=p=0 \
                "${output}"
        )"
        output_frame_size="$(ffprobe \
                -v error \
                -select_streams v:0 \
                -show_entries stream=width,height \
                -of csv=s=x:p=0 \
                "${output}"
        )"


        # reassemble video with upscaled frames
        output="${subject_dir}/${subject_name}-${subject_suffix}.${subject_ext}"
        pattern="$(___generate_frame_output_naming_pattern)"
        ffmpeg -y \
                -thread_queue_size 4096 \
                -i "$source_file" \
                -r "$frame_rate" \
                -thread_queue_size 4096 \
                -i "$pattern" \
                -c:v "$video_codec" \
                -pix_fmt "$pixel_format" \
                -r "$frame_rate" \
                -filter_complex \
                        "[0:v:0]scale=${output_frame_size}[v0];[v0][1]overlay=eof_action=pass" \
                -c:a copy \
                "$output"
        if [ $? -ne 0 ]; then
                _print_status error "\n"
                return 1
        fi
        unset output pattern pixel_format output_frame_size


        # save settings to control file in case of future continuation
        ____save_workspace_controller 3
        if [ $? -ne 0 ]; then
                 _print_status error "\n"
                return 1
        fi


        # report and return
        _print_status info "COMPLETED\n\n"
        return 0
}

_exec_program() {
        __print_job_info
        if [ $? -ne 0 ]; then
                exit 1
        fi


        __upscale_if_image
        if [ $? -ne 0 ]; then
                exit 1
        fi


        __setup_video_workspace
        if [ $? -ne 0 ]; then
                exit 1
        fi


        __generate_frames
        if [ $? -ne 0 ]; then
                exit 1
        fi


        __upscale_frames
        if [ $? -ne 0 ]; then
                exit 1
        fi


        __reassemble_video
        if [ $? -ne 0 ]; then
                exit 1
        fi


        exit 0
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
                --parallel|-pa)
                        if [ "$2" != "" ] && [ "$(printf "%.1s" "$2")" != "-" ]; then
                                parallel="$2"
                                shift 1
                        fi
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
                                source_file="$2"
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
