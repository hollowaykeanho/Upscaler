# Copyright (c) 2024, (Holloway) Chew, Kean Ho <hello@hollowaykeanho.com>
#
#
# BSD 3-Clause License
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
function HestiaOS-To-Arch-UNIX {
        param (
                [string]$___value
        )


        # execute
        switch ($___value.ToLower()) {
        { $_ -in "any", "none" } {
                return "all"
        } { $_ -in "386", "i386", "486", "i486", "586", "i586", "686", "i686" } {
                return "i386"
        } "armle" {
                return "armel"
        } "mipsle" {
                return "mipsel"
        } "mipsr6le" {
                return "mipsr6el"
        } "mipsn32le" {
                return "mipsn32el"
        } "mipsn32r6le" {
                return "mipsn32r6el"
        } "mips64le" {
                return "mips64el"
        } "mips64r6le" {
                return "mips64r6el"
        } "powerpcle" {
                return "powerpcel"
        } "ppc64le" {
                return "ppc64el"
        } default {
                return $___value.ToLower()
        }}
}
