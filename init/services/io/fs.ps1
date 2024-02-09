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
function FS-Append-File {
	param (
		[string]$__target,
		[string]$__content
	)


	# validate target
	if ([string]::IsNullOrEmpty($__target)) {
		return 1
	}


	# perform file write
	$null = Add-Content -Path $__target -Value $__content


	# report status
	if ($?) {
		return 0
	}

	return 1
}




function FS-Copy-All {
	param (
		[string]$__source,
		[string]$__destination
	)


	# validate input
	if ([string]::IsNullOrEmpty($__source) -or [string]::IsNullOrEmpty($__destination)) {
		return 1
	}


	# execute
	$null = Copy-Item -Path "${__source}\*" -Destination "${__destination}" -Recurse


	# report status
	if ($?) {
		return 0
	}
	return 1
}




function FS-Copy-File {
	param (
		[string]$__source,
		[string]$__destination
	)


	# validate input
	if ([string]::IsNullOrEmpty($__source) -or [string]::IsNullOrEmpty($__destination)) {
		return 1
	}


	# execute
	$null = Copy-Item -Path "${__source}" -Destination "${__destination}"


	# report status
	if ($?) {
		return 0
	}

	return 1
}




function FS-Extension-Remove {
	param (
		[string]$__target,
		[string]$__extension
	)


	# execute
	return FS-Extension-Replace "${__target}" "${__extension}" ""
}




function FS-Extension-Replace {
	param (
		[string]$__target,
		[string]$__extension,
		[string]$__candidate
	)


	# validate input
	if ([string]::IsNullOrEmpty($__target)) {
		return ""
	}


	# execute
	if ($__extension -eq "*") {
		$___target = Split-Path -Leaf "${__target}"
		$___target = $___target -replace '(\.\w+)+$'

		if (-not [string]::IsNullOrEmpty($(Split-Path -Parent "${__target}"))) {
			$___target = $(Split-Path -Parent "${__target}") + "\" + "${___target}"
		}
	} elseif (-not [string]::IsNullOrEmpty($__extension)) {
		if ($__extension.Substring(0,1) -eq ".") {
			$__extension = $__extension.Substring(1)
		}

		$___target = Split-Path -Leaf "${__target}"
		$___target = $___target -replace "\.${__extension}$"

		if (-not [string]::IsNullOrEmpty($__candidate)) {
			if ($__candidate.Substring(0,1) -eq ".") {
				$___target += "." + $__candidate.Substring(1)
			} else {
				$___target += "." + $__candidate
			}
		}

		if (-not [string]::IsNullOrEmpty($(Split-Path -Parent "${__target}"))) {
			$___target = $(Split-Path -Parent "${__target}") + "\" + "${___target}"
		}
	} else {
		$___target = $__target
	}

	return $___target
}




function FS-Get-MIME {
	param(
		[string]$___target
	)


	# validate input
	if ((FS-Is-Target-Exist $___target) -ne 0) {
		return ""
	}


	# execute
	$___process = FS-Is-Directory "${___target}"
	if ($___process -eq 0) {
		return "inode/directory"
	}


	switch ((Get-ChildItem $___target).Extension.ToLower()) {
	".avif" {
		return "image/avif"
	} ".gif" {
		return "image/gif"
	} ".gzip" {
		return "application/x-gzip"
	} { $_ -in ".jpg", ".jpeg" } {
		return "image/jpeg"
	} ".json" {
		return "application/json"
	} ".mkv" {
		return "video/mkv"
	} ".mp4" {
		return "video/mp4"
	} ".png" {
		return "image/png"
	} ".rar" {
		return "application/x-rar-compressed"
	} ".tiff" {
		return "image/tiff"
	} ".webp" {
		return "image/webp"
	} ".xml" {
		return "application/xml"
	} ".zip" {
		return "application/zip"
	} default {
		return ""
	}}
}




function FS-Is-Directory {
	param (
		[string]$__target
	)


	# execute
	if ([string]::IsNullOrEmpty($__target)) {
		return 1
	}

	if (Test-Path -Path "${__target}" -PathType Container -ErrorAction SilentlyContinue) {
		return 0
	}

	return 1
}




function FS-Is-File {
	param (
		[string]$__target
	)


	# execute
	if ([string]::IsNullOrEmpty($__target)) {
		return 1
	}

	$__process = FS-Is-Directory "${__target}"
	if ($__process -eq 0) {
		return 1
	}

	if (Test-Path -Path "${__target}" -ErrorAction SilentlyContinue) {
		return 0
	}

	return 1
}




function FS-Is-Target-Exist {
	param (
		[string]$__target
	)


	# validate input
	if ([string]::IsNullOrEmpty("${__target}")) {
		return 1
	}


	# perform checking
	$__process = FS-Is-Directory "${__target}"
	if ($__process -eq 0) {
		return 0
	}

	$__process = FS-Is-File "${__target}"
	if ($__process -eq 0) {
		return 0
	}


	# report status
	return 1
}




function FS-List-All {
	param (
		[string]$__target
	)


	# validate input
	if ([string]::IsNullOrEmpty("${__target}")) {
		return 1
	}


	# execute
	if ((FS-Is-Directory "${__target}") -ne 0) {
		return 1
	}

	try {
		foreach ($__item in (Get-ChildItem -Path "${__target}" -Recurse)) {
			Write-Host $__item.FullName
		}

		return 0
	} catch {
		return 1
	}
}




function FS-Make-Directory {
	param (
		[string]$__target
	)


	# validate input
	if ([string]::IsNullOrEmpty("${__target}")) {
		return 1
	}

	$__process = FS-Is-Directory "${__target}"
	if ($__process -eq 0) {
		return 0
	}

	$__process = FS-Is-Target-Exist "${__target}"
	if ($__process -eq 0) {
		return 1
	}


	# execute
	$__process = New-Item -ItemType Directory -Force -Path "${__target}"


	# report status
	if ($__process) {
		return 0
	}

	return 1
}




function FS-Make-Housing-Directory {
	param (
		[string]$__target
	)


	# validate input
	if ([string]::IsNullOrEmpty($__target)) {
		return 1
	}

	$__process = FS-Is-Directory $__target
	if ($__process -eq 0) {
		return 0
	}


	# perform create
	$__process = FS-Make-Directory (Split-Path -Path $__target)


	# report status
	return $__process
}




function FS-Move {
	param (
		[string]$__source,
		[string]$__destination
	)


	# validate input
	if ([string]::IsNullOrEmpty($__source) -or [string]::IsNullOrEmpty($__destination)) {
		return 1
	}


	# execute
	try {
		Move-Item -Path $__source -Destination $__destination -Force
		if (!$?) {
			return 1
		}
	} catch {
		return 1
	}


	# report status
	return 0
}




function FS-Remake-Directory {
	param (
		[string]$__target
	)


	# execute
	$null = FS-Remove-Silently "${__target}"
	$__process = FS-Make-Directory "${__target}"


	# report status
	if ($__process -eq 0) {
		return 0
	}

	return 1
}




function FS-Remove {
	param (
		[string]$__target
	)


	# validate input
	if ([string]::IsNullOrEmpty($__target)) {
		return 1
	}


	# execute
	$__process = Remove-Item $__target -Force -Recurse


	# report status
	if ($__process -eq $null) {
		return 0
	}

	return 1
}




function FS-Remove-Silently {
	param (
		[string]$__target
	)


	# validate input
	if ([string]::IsNullOrEmpty($__target)) {
		return 0
	}


	# execute
	$null = Remove-Item $__target -Force -Recurse -ErrorAction SilentlyContinue


	# report status
	return 0
}




function FS-Rename {
	param (
		[string]$__source,
		[string]$__target
	)


	# execute
	return FS-Move "${__source}" "${__target}"
}




function FS-Touch-File {
	param(
		[string]$__target
	)


	# validate input
	if ([string]::IsNullOrEmpty($__target)) {
		return 1
	}

	$__process = FS-Is-File "${__target}"
	if ($__process -eq 0) {
		return 0
	}


	# execute
	$__process = New-Item -Path "${__target}"


	# report status
	if ($__process) {
		return 0
	}

	return 1
}




function FS-Write-File {
	param (
		[string]$__target,
		[string]$__content
	)


	# validate input
	if ([string]::IsNullOrEmpty($__target)) {
		return 1
	}

	$__process = FS-Is-File "${__target}"
	if ($__process -eq 0) {
		return 1
	}


	# perform file write
	$null = Set-Content -Path $__target -Value $__content


	# report status
	if ($?) {
		return 0
	}

	return 1
}
