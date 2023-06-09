#!/usr/bin/env bash

set -e

SCRIPT_DIR=$(realpath "$(dirname "${0}")")
WORKSPACE=$(realpath "${SCRIPT_DIR}/..")

for manifest in $(find "${WORKSPACE}/tools/g2/manifests" -type f | sort); do
    echo Checking "${manifest}"
    python3 -m jsonschema "${WORKSPACE}/tools/g2/manifest-schema.json" -i "${manifest}"
done

if [[ -x "$(command -v shellcheck)" ]]; then
    echo Checking shell scripts..
    shellcheck -s bash -e SC1091 -e SC1090 -e SC2162 -e SC2164 -e SC2128 -e SC2029 "${WORKSPACE}"/tools/cleanup.sh "${WORKSPACE}"/tools/*gate*.sh "${WORKSPACE}"/tools/g2/stages/* "${WORKSPACE}"/tools/g2/lib/* "${WORKSPACE}"/tools/install-external-deps.sh
else
    echo No shellcheck executable found.  Please, install it.
    exit 1
fi
