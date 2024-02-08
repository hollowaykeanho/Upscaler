# Copyright 2023  (Holloway) Chew, Kean Ho <hollowaykeanho@gmail.com>
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
function STRINGS-Has-Prefix {
	param(
		[string]$__prefix,
		[string]$__content
	)


	# validate input
	$__process = STRINGS-Is-Empty "${__prefix}"
	if ($__process -eq 0) {
		return 1
	}


	# execute
	if ($__content.StartsWith($__prefix)) {
		return 0
	}


	# report status
	return 1
}




function STRINGS-Has-Suffix {
	param(
		[string]$__suffix,
		[string]$__content
	)


	# validate input
	$__process = STRINGS-Is-Empty "${__suffix}"
	if ($__process -eq 0) {
		return 1
	}


	# execute
	if ($__content.EndsWith($__suffix)) {
		return 0
	}


	# report status
	return 1
}




function STRINGS-Is-Empty {
	param(
		$__target
	)


	# execute
	if ([string]::IsNullOrEmpty($__target)) {
		return 0
	}


	# report status
	return 1
}




function STRINGS-Replace-All {
	param(
		[string]$__content,
		[string]$__subject,
		[string]$__replacement
	)


	# validate input
	$__process = STRINGS-Is-Empty "${__content}"
	if ($__process -eq 0) {
		return ""
	}

	$__process = STRINGS-Is-Empty "${__subject}"
	if ($__process -eq 0) {
		return $__content
	}

	$__process = STRINGS-Is-Empty "${__replacement}"
	if ($__process -eq 0) {
		return $__content
	}


	# execute
	$__right = $__content
	$__register = ""
	while ($__right) {
		$__left = $__right -replace "$($__subject).*", ""

		if ($__left -eq $__right) {
			return "${__register}${__right}"
		}

		# replace this occurence
		$__register += "${__left}${__replacement}"
		$__right = $__right -replace "^.*?${__subject}", ""
	}


	# report status
	return $__register
}




function STRINGS-To-Lowercase {
	param(
		[string]$__content
	)

	return $__content.ToLower()
}




function STRINGS-Trim-Whitespace-Left {
	param(
		[string]$__content
	)

	return $__content.TrimStart()
}




function STRINGS-Trim-Whitespace-Right {
	param(
		[string]$__content
	)

	return $__content.TrimEnd()
}




function STRINGS-Trim-Whitespace {
	param(
		[string]$__content
	)

	$__content = STRINGS-Trim-Whitespace-Left $__content
	$__content = STRINGS-Trim-Whitespace-Right $__content

	return $__content
}




function STRINGS-To-Uppercase {
	param(
		[string]$__content
	)

	return $__content.ToUpper()
}
