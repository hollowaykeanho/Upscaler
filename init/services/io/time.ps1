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
function TIME-Format-ISO8601-Date {
	param(
		[string]$___epoch
	)


	# validate input
	if ([string]::IsNullOrEmpty($___epoch)) {
		return 1
	}


	# execute
	$___t = (Get-Date "1970-01-01 00:00:00.000Z") + ([TimeSpan]::FromSeconds($___epoch))
	return $___t.ToString("yyyy-MM-dd")
}




function TIME-Is-Available {
	return 0
}




function TIME-Now {
	return Get-Date (Get-Date).ToUniversalTime() -UFormat %s
}
