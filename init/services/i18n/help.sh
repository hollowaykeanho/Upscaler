# BSD 3-Clause License
#
# Copyright (c) 2024 (Holloway) Chew, Kean Ho
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
. "${LIBS_UPSCALER}/services/i18n/__printer.sh"




I18N_Status_Print_Help() {
        # execute
        case "$UPSCALER_LANG" in
        DE|de)
                # German
                I18N_Status_Print "info" "
HOLLOWAY'S UPSCALER
-------------------

Befehl:
        $ ./start.sh.ps1 \\
                --model MODELLBEZEICHNUNG \\
                --scale EINTEILUNGSFAKTOR \\
                --format FORMAT \\
                --parallel GESAMTE ARBEITSFÄDEN               # Nur für Video \\
                --video                                       # Nur für Video \\
                --input PFAD_ZUR_DATEI
                --output PFAD_ZUR_DATEI_ODER_ZUM_VERZEICHNIS  # wahlfrei
                --gpu GPU_ID                                  # wahlfrei (erfordert 1 Lauf zur Identifizierung)

BEISPIELE:
        # skalieren Sie nur hoch, ohne eine codierung zu verwenden.
        $ ./start.sh.ps1 \\
                --model ultrasharp \\
                --scale 4 \\
                --input my-image.jpg


        # hochskalieren, aber in etwas anderes formatieren und unter einem
        # anderen Namen speichern
        $ ./start.sh.ps1 \\
                --model ultrasharp \\
                --scale 4 \\
                --format webp \\
                --input my-image.jpg \\
                --output my-image-bigger.webp


        # grundlegendes video-upscaling ohne verwendung von codierung
        $ ./start.sh.ps1 \\
                --model ultrasharp \\
                --scale 4 \\
                --video \\
                --input my-video.mp4


        # video hochskalieren, aber anderes Bildformat verwenden
        $ ./start.sh.ps1 \\
                --model ultrasharp \\
                --scale 4 \\
                --format webp \\
                --video \\
                --input my-video.mp4


# VERFÜGBARE FORMATE
    (1) '' (Leer – Verwenden Sie das AI RAW PNG Format ohne codierung)
    (2) PNG
    (3) JPG
    (4) WEBP


VERFÜGBARE MODELLE:
"

                for __model in "${UPSCALER_PATH_ROOT}/models"/*.sh; do
                        . "$__model"
                        __model_ID="${__model##*/}"
                        __model_ID="${__model_ID%%.*}"
                        __model_NAME="${model_name}"
                        __model_SCALE_MAX="any"
                        if [ "$model_max_scale" -gt 0 ]; then
                                __model_SCALE_MAX="${__model_SCALE_MAX}"
                        fi


                        I18N_Status_Print "info" "
        ID              : ${__model_ID}
        Name            : ${__model_NAME}
        Max. Skalierung : ${__model_SCALE_MAX}

"
                done
                ;;
        *)
                # fallback to default english
                I18N_Status_Print "info" "
HOLLOWAY'S UPSCALER
-------------------

COMMAND:
        $ ./start.sh.ps1 \\
                --model MODEL_NAME \\
                --scale SCALE_FACTOR \\
                --format FORMAT \\
                --parallel TOTAL_WORKING_THREADS  # only for video \\
                --video                           # only for video \\
                --input PATH_TO_FILE
                --output PATH_TO_FILE_OR_DIR      # optional
                --gpu GPU_ID                      # optional (requires 1 run for identification)

EXAMPLES:
        # upscale only without using any encoding.
        $ ./start.sh.ps1 \\
                --model ultrasharp \\
                --scale 4 \\
                --input my-image.jpg


        # upscale but format to something else and save with different name
        $ ./start.sh.ps1 \\
                --model ultrasharp \\
                --scale 4 \\
                --format webp \\
                --input my-image.jpg \\
                --output my-image-bigger.webp


        # basic video upscaling without using any encoding
        $ ./start.sh.ps1 \\
                --model ultrasharp \\
                --scale 4 \\
                --video \\
                --input my-video.mp4


        # upscale video but use other image format
        $ ./start.sh.ps1 \\
                --model ultrasharp \\
                --scale 4 \\
                --format webp \\
                --video \\
                --input my-video.mp4


AVAILABLE FORMATS
    (1) '' (Empty - Use AI raw png format without encoding)
    (2) PNG
    (3) JPG
    (4) WEBP


AVAILABLE MODELS:
"

                for __model in "${UPSCALER_PATH_ROOT}/models"/*.sh; do
                        . "$__model"
                        __model_ID="${__model##*/}"
                        __model_ID="${__model_ID%%.*}"
                        __model_NAME="${model_name}"
                        __model_SCALE_MAX="any"
                        if [ "$model_max_scale" -gt 0 ]; then
                                __model_SCALE_MAX="${__model_SCALE_MAX}"
                        fi


                        I18N_Status_Print "info" "
        ID        : ${__model_ID}
        Name      : ${__model_NAME}
        Max Scale : ${__model_SCALE_MAX}

"
                done
                ;;
        esac
        unset ___mode  ___executable


        # report status
        return 0
}
