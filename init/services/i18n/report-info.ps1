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
. "${env:LIBS_UPSCALER}\services\i18n\__printer.ps1"




function I18N-Report-Info {
	param(
		[string]$___batch,
		[string]$___video,
		[string]$___model,
		[string]$___scale,
		[string]$___format,
		[string]$___parallel,
		[string]$___gpu,
		[string]$___input,
		[string]$___output
	)

	# execute
	switch (${env:UPSCALER_LANG}) {
	{ $_ -in "DE", "de" } {
		# german
		if ($___batch -eq 1) {
			$___batch_job = "ja"
		} else {
			$___batch_job = "nein"
		}

		if ($___video -eq 1) {
			$___video_job = "ja"
		} else {
			$___video_job = "nein"
		}

		$null = I18N-Status-Print "info" @"

Stapelverarbeitung	: ${___batch_job}
Videoaufgabe		: ${___video_job}
Modell			: ${___model}
Skalierungsfaktor	: ${___scale}
Ausgewähltes Format	: ${___format}
Parallelität		: ${___parallel}
Ausgewählte GPU		: ${___gpu}
Bereitgestellter Input	: ${___input}
Ausgabe-Speicherort	: ${___output}

"@
	} default {
		# fallback to default english
		if ($___batch -eq 1) {
			$___batch_job = "yes"
		} else {
			$___batch_job = "no"
		}

		if ($___video -eq 1) {
			$___video_job = "yes"
		} else {
			$___video_job = "no"
		}

		$null = I18N-Status-Print "info" @"

Batch Job       : ${___batch_job}
Video Job       : ${___video_job}
Model           : ${___model}
Scaling Factor  : ${___scale}
Selected Format : ${___format}
Parallelism     : ${___parallel}
Selected GPU    : ${___gpu}
Provided Input  : ${___input}
Output Location : ${___output}

"@
	}}


	# report status
	return 0
}
