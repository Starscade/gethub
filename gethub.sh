#!/bin/sh

set -e

GETHUB_BIN_DIR=~/.local/bin
GETHUB_REPO_BRANCH=main
GETHUB_REPO_ENV=gethub.env
GETHUB_REPO_HOST=raw.githubusercontent.com
GETHUB_REPO_NAME=Starscade/gethub
GETHUB_TMP_BASENAME="/tmp/gethub-$(date +%s)"
GETHUB_TMP_ENVIRONMENT_FILE="${GETHUB_TMP_BASENAME}.env"
GETHUB_TMP_EXECUTABLE_FILE="${GETHUB_TMP_BASENAME}.bin"
GETHUB_VERSION='v0.1.0'

UNICODE_VERTICAL_PIPE='\342\224\203'

if test -n "$1"; then
	GETHUB_REPO_NAME="$1"
fi

printf "\n"
printf " \033[1;93mGETHUB\033[0m: ${GETHUB_VERSION}\n"
printf " \033[1;93mORIGIN\033[0m: ${GETHUB_REPO_NAME}\n\n"
printf " ${UNICODE_VERTICAL_PIPE} Fetching remote environment ...\n"

wget -qO \
	"$GETHUB_TMP_ENVIRONMENT_FILE" \
	"https://${GETHUB_REPO_HOST}/${GETHUB_REPO_NAME}/${GETHUB_REPO_BRANCH}/${GETHUB_REPO_ENV}" \
	|| {
		printf " ${UNICODE_VERTICAL_PIPE} Couldn't find a valid GEThub environment.\n"
		printf "\n \033[1;31mERR\033[0m\n\n"
		exit 1
	}

export $(grep '^GETHUB_' "$GETHUB_TMP_ENVIRONMENT_FILE" | xargs)

printf " ${UNICODE_VERTICAL_PIPE} Downloading executable ...\n"

wget -qO \
	"$GETHUB_TMP_EXECUTABLE_FILE" \
	"https://${GETHUB_REPO_HOST}/${GETHUB_REPO_NAME}/${GETHUB_REPO_BRANCH}/${GETHUB_SOURCE_PATH}" \
	|| {
		printf " ${UNICODE_VERTICAL_PIPE} Couldn't find the specified source distributable.\n"
		printf "\n \033[1;31mERR\033[0m\n\n"
		exit 1
	}

printf " ${UNICODE_VERTICAL_PIPE} Installing ...\n"

\cp -f "$GETHUB_TMP_EXECUTABLE_FILE" "${GETHUB_BIN_DIR}/${GETHUB_TARGET_NAME}" \
	|| printf " ${UNICODE_VERTICAL_PIPE} Failed to install.\n"

chmod +x "${GETHUB_BIN_DIR}/${GETHUB_TARGET_NAME}"

rm "$GETHUB_TMP_EXECUTABLE_FILE" "$GETHUB_TMP_ENVIRONMENT_FILE" \
	|| printf " ${UNICODE_VERTICAL_PIPE} Failed to purge temporary files. Perhaps they were already removed?\n"

printf "\n \033[1;32mOK\033[0m\n\n"
