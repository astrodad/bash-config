#!/bin/bash
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
