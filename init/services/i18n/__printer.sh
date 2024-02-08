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
. "${LIBS_UPSCALER}/services/io/strings.sh"




I18N_Status_Print() {
        #___mode="$1"
        #___message="$2"


        # execute
        ___tag="$(I18N_Status_Tag_Get_Type "$1")"
        ___color=""
        case "$1" in
        error)
                ___color="31"
                ;;
        warning)
                ___color="33"
                ;;
        info)
                ___color="36"
                ;;
        note)
                ___color="35"
                ;;
        success)
                ___color="32"
                ;;
        ok)
                ___color="36"
                ;;
        done)
                ___color="36"
                ;;
        *)
                # do nothing
                ;;
        esac

        if [ ! -z "$COLORTERM" ] || [ "$TERM" = "xterm-256color" ]; then
                # terminal supports color mode
                if [ ! -z "$___color" ]; then
                        1>&2 printf -- "%b" \
                                "\033[1;${___color}m${___tag}\033[0;${___color}m${2}\033[0m"
                else
                        1>&2 printf -- "%b" "${___tag}${2}"
                fi
        else
                1>&2 printf -- "%b" "${___tag}${2}"
        fi

        unset ___color ___tag
}




I18N_Status_Tag_Create() {
        #___content="$1"
        #___spacing="$2"


        # validate input
        if [ "$(STRINGS_Is_Empty "$1")" -eq 0 ]; then
                printf -- ""
                return 0
        fi


        # execute
        printf -- "%b" "⦗$1⦘$2"
        return 0
}




I18N_Status_Tag_Get_Type() {
        #___mode="$1"


        # execute
        case "$UPSCALER_LANG" in
        DE|de)
                printf -- "%b" "$(I18N_Status_Tag_Get_Type_DE "$1")"
                ;;
        *)
                # fallback to default english
                printf -- "%b" "$(I18N_Status_Tag_Get_Type_EN "$1")"
                ;;
        esac
}




I18N_Status_Tag_Get_Type_EN() {
        #___mode="$1"


        # execute (REMEMBER: make sure the text and spacing are having the same length)
        case "$1" in
        error)
                printf -- "%b" "$(I18N_Status_Tag_Create " ERROR " "   ")"
                ;;
        warning)
                printf -- "%b" "$(I18N_Status_Tag_Create " WARNING " " ")"
                ;;
        info)
                printf -- "%b" "$(I18N_Status_Tag_Create " INFO " "    ")"
                ;;
        note)
                printf -- "%b" "$(I18N_Status_Tag_Create " NOTE " "    ")"
                ;;
        success)
                printf -- "%b" "$(I18N_Status_Tag_Create " SUCCESS " " ")"
                ;;
        ok)
                printf -- "%b" "$(I18N_Status_Tag_Create " OK " "      ")"
                ;;
        done)
                printf -- "%b" "$(I18N_Status_Tag_Create " DONE " "    ")"
                ;;
        *)
                printf -- ""
                ;;
        esac
}




I18N_Status_Tag_Get_Type_DE() {
        #___mode="$1"


        # execute (REMEMBER: make sure the text and spacing are having the same length)
        case "$1" in
        error)
                printf -- "%b" "$(I18N_Status_Tag_Create " FEHLER " "    ")"
                ;;
        warning)
                printf -- "%b" "$(I18N_Status_Tag_Create " WARNUNG " "   ")"
                ;;
        info)
                printf -- "%b" "$(I18N_Status_Tag_Create " INFO " "      ")"
                ;;
        note)
                printf -- "%b" "$(I18N_Status_Tag_Create " ANMERKUNG " " ")"
                ;;
        success)
                printf -- "%b" "$(I18N_Status_Tag_Create " ERFOLG " "    ")"
                ;;
        ok)
                printf -- "%b" "$(I18N_Status_Tag_Create " OKAY " "      ")"
                ;;
        done)
                printf -- "%b" "$(I18N_Status_Tag_Create " FERTIG " "    ")"
                ;;
        *)
                printf -- ""
                ;;
        esac
}
