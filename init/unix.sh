#!/bin/bash
#############
# variables #
#############
repo="${BASH_SOURCE[0]%%init/unix.sh}"

# arguments
action='run'
model="${UPSCALER_MODEL:-""}"
scale="${UPSCALER_SCALE:-0}"
input=""
output=""
format=""

# variables
program=''
model_id=''
model_name=''
model_max_scale=''




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

function _provide_help() {
        _print_status plain """
HOLLOWAY'S UPSCALER
-------------------
COMMAND:

$ ./start.cmd \\
        --model MODEL_NAME \\
        --scale SCALE_FACTOR \\
        --format FORMAT \\
        --input PATH_TO_FILE \\
        --output PATH_TO_FILE_OR_DIR

EXAMPLES

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
        --input video/frames/input \\
        --output video/frames/output

AVAILABLE FORMATS:
(1) PNG
(2) JPG
(3) WEBP

AVAILABLE MODELS:
"""

        for model_type in "${repo}/models"/*.sh; do
                source "$model_type"

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

function _check_os() {
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

function _check_arch() {
        program="${program}-amd64"
        return 0
}

function _check_program_existence() {
        if [ ! -f "$program" ]; then
                _print_status error "missing AI executable: '${program}'.\n"
                return 1
        fi

        return 0
}

function _check_model_and_scale() {
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

                if [ "$model" == "$model_id" ]; then
                        __supported=true
                        source "$model_type"
                fi
        done

        if [ "$__supported" == "false" ]; then
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

function _check_io() {
        if [ "$input" == "" ]; then
                _print_status error "missing input.\n"
                return 1
        fi


        if [ "$output" == "" ]; then
                _print_status error "missing output.\n"
                return 1
        fi

        if [ ! -e "$input" ]; then
                _print_status error "input does not exist: '${input}'.\n"
                return 1
        fi
}

function _check_format() {
        if [ -z "$format" ]; then
                _print_status error "missing format.\n"
                return 1
        fi

        case "$format" in
        jpg|JPG|png|PNG|webp|WEBP)
                return 0
                ;;
        *)
                _print_status error "unsupported output format: '$format'.\n"
                return 1
                ;;
        esac
}

function _exec_program() {
        $program -i "$input" \
                -o "$output" \
                -s "$scale" \
                -m "${repo}/models" \
                -n "$model" \
                -f "$format"
}

function main() {
        if [[ "$@" == "" ]]; then
                _provide_help
                exit 0
        fi

        # parse argument
        while [[ $# != 0 ]]; do
        case "$1" in
                --help|-h|help)
                        _provide_help
                        exit 0
                        ;;
                --model|-m)
                        if [[ "$2" != "" && "${2:1}" != "-" ]]; then
                                model="$2"
                                shift 1
                        fi
                        ;;
                --scale|-s)
                        if [[ "$2" != "" && "${2:1}" != "-" ]]; then
                                scale="$2"
                                shift 1
                        fi
                        ;;
                --input|-i)
                        if [[ "$2" != "" && "${2:1}" != "-" ]]; then
                                input="$2"
                                shift 1
                        fi
                        ;;
                --output|-o)
                        if [[ "$2" != "" && "${2:1}" != "-" ]]; then
                                output="$2"
                                shift 1
                        fi
                        ;;
                --format|-f)
                        if [[ "$2" != "" && "${2:1}" != "-" ]]; then
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
        __ops=(
                '_check_os'
                '_check_arch'
                '_check_program_existence'
                '_check_model_and_scale'
                '_check_io'
                '_check_format'
                '_exec_program'
        )

        for _op in "${__ops[@]}"; do
                ${_op}
                if [ $? -ne 0 ]; then
                        exit 1
                fi
        done
}
main $@
