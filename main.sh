#!/usr/bin/env bash

# Copyright The Helm Authors
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     https://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

set -o errexit
set -o nounset
set -o pipefail
set -x

SCRIPT_DIR=$(dirname -- "$(readlink -f "${BASH_SOURCE[0]}" || realpath "${BASH_SOURCE[0]}")")
MARK="5.7"

export SCRIPT_DIR
export MARK

main() {

    export

    curl -LO https://github.com/kovetskiy/mark/releases/download/${MARK}/mark_${MARK}_Linux_x86_64.tar.gz && \
    tar -xvzf mark_5.7_Linux_x86_64.tar.gz && \
    chmod +x mark && \
    sudo mv mark /usr/local/bin/mark

    if [[ -x "${SCRIPT_DIR}/${INPUT_ACTION}.sh" ]]; then
        "${SCRIPT_DIR}/${INPUT_ACTION}.sh"
    else
        echo "Invalid action: ${INPUT_ACTION}"
    fi

}

main
