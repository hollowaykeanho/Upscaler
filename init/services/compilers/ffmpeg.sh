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
. "${LIBS_UPSCALER}/services/i18n/report-simulation.sh"
. "${LIBS_UPSCALER}/services/io/os.sh"
. "${LIBS_UPSCALER}/services/io/fs.sh"
. "${LIBS_UPSCALER}/services/io/strings.sh"




FFMPEG_Is_Available() {
        # execute
        if [ ! "$(STRINGS_Is_Empty "$UPSCALER_TEST_MODE")" = "0" ]; then
                I18N_Report_Simulation "ffmpeg & ffprobe"
                return 0
        fi

        OS_Is_Command_Available "ffmpeg"
        if [ $? -ne 0 ]; then
                return 1
        fi

        OS_Is_Command_Available "ffprobe"
        if [ $? -ne 0 ]; then
                return 1
        fi


        # report status
        return 0
}




FFMPEG_Video_Dissect() {
        #___input="$1"
        #___output="$2"

        return 0
}




FFMPEG_Video_Reassemble() {
        #___input="$1"
        #___output="$2"

        return 0
}
