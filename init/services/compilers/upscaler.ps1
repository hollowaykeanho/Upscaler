# BSD 3-Clause License
#
# Copyright (c) 2024, (Holloway) Chew, Kean Ho
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
. "${env:LIBS_UPSCALER}\services\i18n\report-simulation.ps1"
. "${env:LIBS_UPSCALER}\services\io\os.ps1"
. "${env:LIBS_UPSCALER}\services\io\fs.ps1"
. "${env:LIBS_UPSCALER}\services\io\strings.ps1"




function UPSCALER-Batch-Load {
	param(
		[string]$___video,
		[string]$___model,
		[string]$___scale,
		[string]$___format,
		[string]$___parallel,
		[string]$___gpu,
		[string]$___input,
		[string]$___output
	)


	# validate input
	if ( ((STRINGS-Is-Empty "${___video}") -eq 0) -or
		((STRINGS-Is-Empty "${___model}") -eq 0) -or
		((STRINGS-Is-Empty "${___scale}") -eq 0) -or
		((STRINGS-Is-Empty "${___format}") -eq 0) -or
		((STRINGS-Is-Empty "${___parallel}") -eq 0) -or
		((STRINGS-Is-Empty "${___gpu}") -eq 0) -or
		((STRINGS-Is-Empty "${___input}") -eq 0) -or
		((STRINGS-Is-Empty "${___output}") -eq 0)) {
		return 1
	}


	if ((STRINGS-Is-Empty "$(UPSCALER-Program-Get)") -eq 0) {
		return 1
	}


	# report status
	return 0
}




function UPSCALER-Batch-Run {
	param(
		[string]$___video,
		[string]$___model,
		[string]$___scale,
		[string]$___format,
		[string]$___parallel,
		[string]$___gpu,
		[string]$___input,
		[string]$___output
	)


	# validate input
	if ( ((STRINGS-Is-Empty "${___video}") -eq 0) -or
		((STRINGS-Is-Empty "${___model}") -eq 0) -or
		((STRINGS-Is-Empty "${___scale}") -eq 0) -or
		((STRINGS-Is-Empty "${___format}") -eq 0) -or
		((STRINGS-Is-Empty "${___parallel}") -eq 0) -or
		((STRINGS-Is-Empty "${___gpu}") -eq 0) -or
		((STRINGS-Is-Empty "${___input}") -eq 0) -or
		((STRINGS-Is-Empty "${___output}") -eq 0)) {
		return 1
	}


	# execute
	if ((STRINGS-Is-Empty "${env:UPSCALER_TEST_MODE}") -ne 0) {
		$null = I18N-Report-Simulation "$(UPSCALER-Program-Get) ${___cmd}"
		$null = FS-Make-Housing-Directory "${___output}"
		$null = FS-Remove-Silently "${___output}"
		$___process = FS-Copy-File "${___input}" "${___output}"
		if ($___process -eq 0) {
			return 0
		}
	}


	# report status
	return 0
}




function UPSCALER-Batch-Setup {
	param(
		[string]$___video,
		[string]$___model,
		[string]$___scale,
		[string]$___format,
		[string]$___parallel,
		[string]$___gpu,
		[string]$___input,
		[string]$___output
	)


	# validate input
	if ( ((STRINGS-Is-Empty "${___video}") -eq 0) -or
		((STRINGS-Is-Empty "${___model}") -eq 0) -or
		((STRINGS-Is-Empty "${___scale}") -eq 0) -or
		((STRINGS-Is-Empty "${___format}") -eq 0) -or
		((STRINGS-Is-Empty "${___parallel}") -eq 0) -or
		((STRINGS-Is-Empty "${___gpu}") -eq 0) -or
		((STRINGS-Is-Empty "${___input}") -eq 0) -or
		((STRINGS-Is-Empty "${___output}") -eq 0)) {
		return 1
	}


	if ((STRINGS-Is-Empty "$(UPSCALER-Program-Get)") -eq 0) {
		return 1
	}


	# report status
	return 0
}




function UPSCALER-Format-Validate {
	param(
		[string]$___format
	)


	# valdiate input
	if ((STRINGS-Is-Empty "${___format}") -eq 0) {
		return ""
	}


	# execute
	switch ($(STRINGS-To-Lowercase "${___format}")) {
	{ $_ -in "jpeg", "jpg" } {
		return "jpg"
	} "png" {
		return "png"
	} "webp" {
		return "webp"
	} "native" {
		return "native"
	} default {
		return ""
	}}
}




function UPSCALER-Output-Filename-Image {
	param(
		[string]$___output,
		[string]$___input,
		[string]$___format
	)


	# validate input
	if ((STRINGS-IS-Empty "${___output}") -ne 0) {
		return "${___output}"
	}

	if ((STRINGS-IS-Empty "${___input}") -eq 0) {
		return ""
	}


	# execute
	$___output = FS-Extension-Remove "$(Split-Path -Leaf -Path "${___input}")" "*"
	if ($(Split-Path -Parent -Path "${___input}") -ne "${___input}") {
		$___output = "$(Split-Path -Parent -Path "${___input}")\${___output}-upscaled"
	} else {
		$___output = ".\${___output}-upscaled"
	}

	switch ($___format) {
	"jpg" {
		$___output = "${___output}.jpg"
	} "webp" {
		$___output = "${___output}.webp"
	} default {
		$___output = "${___output}.png"
	}}

	return $___output
}




function UPSCALER-Output-Filename-Video {
	param(
		[string]$___output,
		[string]$___input
	)


	# validate input
	if ((STRINGS-IS-Empty "${___output}") -ne 0) {
		return "${___output}"
	}

	if ((STRINGS-IS-Empty "${___input}") -eq 0) {
		return ""
	}


	# execute
	$___output = FS-Extension-Remove "$(Split-Path -Leaf -Path "${___input}" "*")" "*"
	$___output = "$(Split-Path -Parent -Path "${___input}")\${___output}-upscaled"
	$___output = "${___output}.$((Split-Path -Path ${___input} -Leaf).Split(".")[1])"

	return $___output
}




function UPSCALER-GPU-Scan {
	# validate input
	$___program = UPSCALER-Program-Get
	if ((STRINGS-Is-Empty "${___program}") -eq 0) {
		return ""
	}


	# create a dummy PNG file for upscale
	$___filename = "${env:UPSCALER_PATH_ROOT}\.dummy.png"
	$___target = "${env:UPSCALER_PATH_ROOT}\.dummy-upscaled.png"
	$___header = @(
		0x89,  0x50,  0x4E,  0x47,  0x0D,  0x0A,  0x1A,  0x0A,
		0x00,  0x00,  0x00,  0x0D,  0x49,  0x48,  0x44,  0x52,
		0x00,  0x00,  0x00,  0x01,  0x00,  0x00,  0x00,  0x01,
		0x08,  0x06,  0x00,  0x00,  0x00,  0x1F,  0x15,  0xC4,
		0x89,  0x00,  0x00,  0x00,  0x0A,  0x49,  0x44,  0x41,
		0x54,  0x78,  0x9C,  0x63,  0x00,  0x01,  0x74,  0x52,
		0x47,  0x42,  0x00,  0xAE,  0xCE,  0x1C,  0xE9,  0x00,
		0x00,  0x00,  0x04,  0x67,  0x41,  0x4D,  0x41,  0x00,
		0x00,  0xAF,  0xC8,  0x37,  0x05,  0x8A,  0xE9,  0x00,
		0x00,  0x00,  0x00,  0x49,  0x45,  0x4E,  0x44,  0xAE,
		0x42,  0x60,  0x82
	)
	$___bytes = [byte[]]$___header
	$null = FS-Remove-Silently "${___filename}"
	$null = FS-Remove-Silently "${___target}"
	[System.IO.File]::WriteAllBytes($___filename, $___bytes)
	$___result = & $___program -s 1 -i $___filename -o $___target  2>&1
	$null = FS-Remove-Silently "${___filename}"
	$null = FS-Remove-Silently "${___target}"
	return $___result
}




function UPSCALER-GPU-Verify {
	param(
		[string]$___gpu
	)


	# validate input
	if ((STRINGS-Is-Empty "${___gpu}") -eq 0) {
		return 1
	}


	# execute
	$___term = UPSCALER-GPU-Scan
	$___verdict = $false
	$___lines = $___term -split "`n"
	foreach ($___line in $___lines) {
		if ($___line -notmatch '^\[') {
			continue
		}

		$___line = $___line -replace '\]\s*$', ''
		$___line = $___line -replace '^\[\s*', ''
		$___id = $___line.Split(' ',  2)[0]

		if ($___gpu -eq $___id) {
			$___verdict = $true
			break
		}
	}


	# report status
	if ($___verdict) {
		return 0
	}

	return 1
}




function UPSCALER-Is-Available {
	$___process = UPSCALER-Program-Get
	if ((STRINGS-Is-Empty "${___process}") -eq 0) {
		return 1
	}

	$___process = FS-Is-Target-Exist "${___process}"
	if ($___process -ne 0) {
		return 1
	}


	# report status
	return 0
}




function UPSCALER-Model-Get {
	param(
		[string]$___id
	)


	# validate input
	if ((STRINGS-Is-Empty "${___id}") -eq 0) {
		return ""
	}


	# execute
	foreach ($___model in (Get-ChildItem `
		-Path "${env:UPSCALER_PATH_ROOT}\models" `
		-Filter *.sh)) {
		$___model_ID = $___model.Name -replace '\.sh$'
		if ($___model_ID -ne $___id) {
			continue
		}


		# given ID is a valid model
		$___model_NAME = ""
		$___model_SCALE_MAX = "any"

		foreach ($___line in $(Get-Content "$($___model.FullName)")) {
			$___line = $___line -replace '#.*', ''

			if ((STRINGS-Is-Empty "${___line}") -eq 0) {
				continue
			}

			$___key, $___value = $___line -split '=', 2
			$___key = $___key.Trim() -replace '^''|''$|^"|"$'
			$___value = $___value.Trim() -replace '^''|''$|^"|"$'
			switch ($___key) {
			"model_name" {
				$___model_NAME = $___value
			} "model_max_scale" {
				$___model_SCALE_MAX = $___value
			} default {
				# unknown - do nothing
			}}
		}


		# print out
		return "${___model_ID}│${___model_SCALE_MAX}│${___model_NAME}"
	}


	# report status
	return ""
}




function UPSCALER-Program-Get {
	if (-not (OS-Host-System -eq "windows")) {
		return ""
	}

	if (-not (OS-Host-Arch -eq "amd64")) {
		return ""
	}

	return "${env:UPSCALER_PATH_ROOT}/bin/windows-amd64.exe"
}




function UPSCALER-Run-Image {
	param(
		[string]$___model,
		[string]$___scale,
		[string]$___format,
		[string]$___gpu,
		[string]$___input,
		[string]$___output
	)


	# validate input
	if (((STRINGS-Is-Empty "${___model}") -eq 0) -or
		((STRINGS-Is-Empty "${___scale}") -eq 0) -or
		((STRINGS-Is-Empty "${___format}") -eq 0) -or
		((STRINGS-Is-Empty "${___gpu}") -eq 0) -or
		((STRINGS-Is-Empty "${___input}") -eq 0) -or
		((STRINGS-Is-Empty "${___output}") -eq 0)) {
		return 1
	}


	if ((STRINGS-Is-Empty "$(UPSCALER-Program-Get)") -eq 0) {
		return 1
	}


	# construct arugment
	$___cmd = "-i '${___input}' -o '${___output}'"
	$___cmd = "${___cmd} -m '${env:UPSCALER_PATH_ROOT}/models/' -n '${___model}'"
	$___cmd = "${___cmd} -s '${___scale}' -g '${___gpu}'"
	switch ($___format) {
	"jpg" {
		$___cmd = "${___cmd} -f jpg"
	} "webp" {
		$___cmd = "${___cmd} -f webp"
	} default {
		# do nothing - maintain png
	}}


	# execute
	$null = FS-Make-Housing-Directory "${___output}"
	$null = FS-Remove-Silently "${___output}"
	if ((STRINGS-Is-Empty "${env:UPSCALER_TEST_MODE}") -ne 0) {
		$null = I18N-Report-Simulation "$(UPSCALER-Program-Get) ${___cmd}"
		$___process = FS-Copy-File "${___input}" "${___output}"
		if ($___process -eq 0) {
			return 0
		}
	} else {
		$___process = OS-Exec "$(UPSCALER-Program-Get)" "${___cmd}"
		if ($___process -eq 0) {
			return 0
		}
	}


	# report status
	return 1
}




function UPSCALER-Scale-Get {
	param(
		[string]$___limit,
		[string]$___input
	)


	# validate input
	if (
		((STRINGS-Is-Empty "${___limit}") -eq 0) -or
		((STRINGS-Is-Empty "${___input}") -eq 0)) {
		return 0
	}


	# execute
	switch ($___limit) {
	"any" {
		switch ($___input) {
		"1" {
			return 1
		} "2" {
			return 2
		} "3" {
			return 3
		} "4" {
			return 4
		} default {
		}}
	} "1" {
		switch ($___input) {
		"1" {
			return 1
		} default {
		}}
	} "2" {
		switch ($___input) {
		"2" {
			return 2
		} default {
		}}
	} "3" {
		switch ($___input) {
		"3" {
			return 3
		} default {
		}}
	} "4" {
		switch ($___input) {
		"4" {
			return 4
		} default {
		}}
	} default {
	}}


	# report status
	return 0
}
