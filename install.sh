#!/bin/sh

if test -z "$GETHUB_BIN_DIR"; then
	GETHUB_BIN_DIR=~/.local/bin
fi

set -a
. gethub.env
set +a

cp -iv "$GETHUB_SOURCE_PATH" "${GETHUB_BIN_DIR}/${GETHUB_TARGET_NAME}"
