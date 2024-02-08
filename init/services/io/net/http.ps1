# Copyright 2024 (Holloway) Chew, Kean Ho <hollowaykeanho@gmail.com>
#
# Licensed under the Apache License, Version 2.0 (the "License"); you may not
# use this file except in compliance with the License. You may obtain a copy
# of the License at:
#                 http://www.apache.org/licenses/LICENSE-2.0
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS, WITHOUT
# WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the
# License for the specific language governing permissions and limitations
# under the License.
function HTTP-Download {
	param (
		[string]$___method,
		[string]$___url,
		[string]$___filepath,
		[string]$___shasum_type,
		[string]$___shasum_value,
		[string]$___auth_header
	)


	# validate input
	if ([string]::IsNullOrEmpty($___url) -or [string]::IsNullOrEmpty($___filepath)) {
		return 1
	}

	if ([string]::IsNullOrEmpty($___method)) {
		$___method = "GET"
	}


	# execute
	## clean up workspace
	$null = Remove-Item $___filepath -Force -Recurse -ErrorAction SilentlyContinue
	$null = FS-Make-Directory (Split-Path -Path $___filepath) -ErrorAction SilentlyContinue

	## download payload
	if (-not [string]::IsNullOrEmpty($___auth_header)) {
		$null = Invoke-RestMethod `
			-FollowRelLink `
			-MaximumFollowRelLink 16 `
			-Headers $___auth_header `
			-OutFile $___filepath `
			-Method $___method `
			-Uri $___url
	} else {
		$null = Invoke-RestMethod `
			-FollowRelLink `
			-MaximumFollowRelLink 16 `
			-OutFile $___filepath `
			-Method $___method `
			-Uri $___url
	}

	if (-not (Test-Path -Path $___filepath)) {
		return 1
	}

	## checksum payload
	if ([string]::IsNullOrEmpty($___shasum_type) -or
		[string]::IsNullOrEmpty($___shasum_value)) {
		return 0
	}

	switch ($___shasum_type) {
	'1' {
		$___hasher = New-Object `
			System.Security.Cryptography.SHA1CryptoServiceProvider
	} '224' {
		return 1
	} '256' {
		$___hasher = New-Object `
			System.Security.Cryptography.SHA256CryptoServiceProvider
	} '384' {
		$___hasher = New-Object `
			System.Security.Cryptography.SHA384CryptoServiceProvider
	} '512' {
		$___hasher = New-Object `
			System.Security.Cryptography.SHA512CryptoServiceProvider
	} '512224' {
		return 1
	} '512256' {
		return 1
	} Default {
		return 1
	}}

	$___fileStream = [System.IO.File]::OpenRead($___filepath)
	$___hash = $___hasher.ComputeHash($___fileStream)
	$___hash = [System.BitConverter]::ToString($___hash).Replace("-", "").ToLower()
	if ($___hash -ne $___shasum_value) {
		return 1
	}


	# report status
	return 0
}




function HTTP-Setup {
	return 0 # using PowerShell native function
}
