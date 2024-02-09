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
. "${env:LIBS_UPSCALER}\services\io\os.ps1"
. "${env:LIBS_UPSCALER}\services\io\fs.ps1"
. "${env:LIBS_UPSCALER}\services\io\strings.ps1"




function UPSCALER-Is-Available {
	if (-not (OS-Host-System -eq "windows")) {
		return 1
	}

	if (-not (OS-Host-Arch -eq "amd64")) {
		return 1
	}

	$___process = FS-Is-Target-Exist "${env:UPSCALER_PATH_ROOT}/bin/windows-amd64.exe"
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
