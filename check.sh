#!/bin/bash
#--------------------------------------------------------------------------------
#  Copyright 2016 Joseph Skora
#
#  Licensed under the Apache License, Version 2.0 (the "License");
#  you may not use this file except in compliance with the License.
#  You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
#  Unless required by applicable law or agreed to in writing, software
#  distributed under the License is distributed on an "AS IS" BASIS,
#  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#  See the License for the specific language governing permissions and
#  limitations under the License.
#--------------------------------------------------------------------------------
#
# Facilitate verifying that all scripts are included in the setup.sh and diff.sh scripts.

RC=0
for X in *; do
    if [ "$X" == "setup.sh" -o "$X" == "check.sh" -o "$X" == "diff.sh" -o "$X" == "README.md" ]; then
        continue
    fi
    grep -E "^safe_copy $X" setup.sh >/dev/null
    if [ $? -ne 0 ]; then
        echo "[check.sh] '$X' is not setup in setup.sh"
        RC=1
    fi
    grep -E "^safe_diff $X" diff.sh >/dev/null
    if [ $? -ne 0 ]; then
        echo "[check.sh] '$X' is not verified in diff.sh"
        RC=1
    fi
done
if [ $RC != 0 ]; then
    echo "[check.sh] =========================================="
    echo "[check.sh] Commit rejected until scripts are updated."
    echo "[check.sh] =========================================="
fi
exit $RC
