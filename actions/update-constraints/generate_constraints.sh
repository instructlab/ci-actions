#!/bin/sh
set -xe

# Require Linux; at least until we generate constraints files for each platform
if [ "$(uname)" != "Linux" ]; then
    echo "This script is only supported on Linux."
    exit 1
fi

# Read list of requirements files from the config file
REQUIREMENTS_FILES=$(grep -v '^#' requirements-files.in | tr '\n' ' ')

CONSTRAINTS_FILE=constraints-dev.txt

export UV_INDEX_STRATEGY=unsafe-best-match

# shellcheck disable=SC2086
uv pip compile -U \
    --no-header \
    --annotate \
    --annotation-style line \
    --allow-unsafe \
    --output-file=$CONSTRAINTS_FILE \
    --constraint constraints-dev.txt.in \
    $REQUIREMENTS_FILES

# clean up empty lines and comments
sed '/^#.*/d' -i constraints-dev.txt
sed '/^$/d' -i constraints-dev.txt

# pip-compile lists -r requirements.txt twice for some reason: once with
# relative path and once with absolute. Clean it up.
sed -E 's/-r \/[^ ]+\/[^,]+, *//' -i $CONSTRAINTS_FILE
