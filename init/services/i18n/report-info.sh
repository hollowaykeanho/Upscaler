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




I18N_Report_Info() {
        #___batch="$1"
        #___video="$2"
        #___model="$3"
        #___scale="$4"
        #___format="$5"
        #___parallel="$6"
        #___gpu="$7"
        #___input="$8"
        #___output="$9"


        # execute
        case "$UPSCALER_LANG" in
        DE|de)
                # German
                if [ "$1" = "1" ]; then
                        ___batch_job="ja"
                else
                        ___batch_job="nein"
                fi

                if [ "$2" = "1" ]; then
                        ___video_job="ja"
                else
                        ___video_job="nein"
                fi

                I18N_Status_Print "info" "
Stapelverarbeitung      : ${___batch_job}
Videoaufgabe            : ${___video_job}
Modell                  : ${3}
Skalierungsfaktor       : ${4}
Ausgewähltes Format     : ${5}
Parallelität            : ${6}
Ausgewählte GPU         : ${7}
Bereitgestellter Input  : ${8}
Ausgabe-Speicherort     : ${9}

"
                ;;
        *)
                # fallback to default english
                if [ "$1" = "1" ]; then
                        ___batch_job="yes"
                else
                        ___batch_job="no"
                fi

                if [ "$2" = "1" ]; then
                        ___video_job="yes"
                else
                        ___video_job="no"
                fi

                I18N_Status_Print "info" "
Batch Job       : ${___batch_job}
Video Job       : ${___video_job}
Model           : ${3}
Scaling Factor  : ${4}
Selected Format : ${5}
Parallelism     : ${6}
Selected GPU    : ${7}
Provided Input  : ${8}
Output Location : ${9}

"
                ;;
        esac


        # report status
        return 0
}
