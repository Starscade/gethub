#!/bin/sh

set -e

_GETHUB_BIN_DIR=~/.local/bin
_GETHUB_TMP_BASENAME="/tmp/gethub-$(date +%s)"
_GETHUB_TMP_ENVIRONMENT_FILE="${_GETHUB_TMP_BASENAME}.env"
_GETHUB_TMP_EXECUTABLE_FILE="${_GETHUB_TMP_BASENAME}.bin"

: "${GETHUB_BIN_DIR:=${_GETHUB_BIN_DIR}}"
: "${GETHUB_REPO_BRANCH:=main}"
: "${GETHUB_REPO_ENV:=gethub.env}"
: "${GETHUB_REPO_HOST:=raw.githubusercontent.com}"
: "${GETHUB_REPO_NAME:=Starscade/gethub}"
: "${GETHUB_TMP_BASENAME:=${_GETHUB_TMP_BASENAME}}"
: "${GETHUB_TMP_ENVIRONMENT_FILE:=${_GETHUB_TMP_ENVIRONMENT_FILE}}"
: "${GETHUB_TMP_EXECUTABLE_FILE:=${_GETHUB_TMP_EXECUTABLE_FILE}}"

GETHUB_VERSION='v0.1.0'
PRINTF_ERR='\n \033[1;31mERR\033[0m\n\n'
PRINTF_OK='\n \033[1;32mOK\033[0m\n\n'
UNICODE_VERTICAL_PIPE='\342\224\203'

if test -n "$1"; then
	GETHUB_REPO_NAME="$1"
fi

printf "\n"
printf "     \033[1;93mGETHUB\033[0m: ${GETHUB_VERSION}\n"
printf " \033[1;93mREPOSITORY\033[0m: ${GETHUB_REPO_NAME}\n\n"
printf " ${UNICODE_VERTICAL_PIPE} Fetching remote environment ...\n"

curl -fLsS \
	"https://${GETHUB_REPO_HOST}/${GETHUB_REPO_NAME}/${GETHUB_REPO_BRANCH}/${GETHUB_REPO_ENV}" \
	> "$GETHUB_TMP_ENVIRONMENT_FILE" \
	|| {
		printf " ${UNICODE_VERTICAL_PIPE} Couldn't find a valid GEThub environment.\n"
		printf "$PRINTF_ERR"
		exit 1
	}

export $(grep '^GETHUB_' "$GETHUB_TMP_ENVIRONMENT_FILE" | xargs)

printf " ${UNICODE_VERTICAL_PIPE} Downloading executable ...\n"

curl -fLsS \
	"$GETHUB_APP_URL" \
	> "$GETHUB_TMP_EXECUTABLE_FILE" \
	|| {
		printf " ${UNICODE_VERTICAL_PIPE} Couldn't find the specified source distributable.\n"
		printf "$PRINTF_ERR"
		exit 1
	}

printf " ${UNICODE_VERTICAL_PIPE} Installing ...\n"

\cp -f "$GETHUB_TMP_EXECUTABLE_FILE" "${GETHUB_BIN_DIR}/${GETHUB_APP_NAME}" \
	|| {
		printf " ${UNICODE_VERTICAL_PIPE} Failed to install.\n"
		printf "$PRINTF_ERR"
		exit 1
	}

chmod +x "${GETHUB_BIN_DIR}/${GETHUB_TARGET_NAME}"

rm "$GETHUB_TMP_EXECUTABLE_FILE" "$GETHUB_TMP_ENVIRONMENT_FILE" \
	|| printf " ${UNICODE_VERTICAL_PIPE} Failed to purge temporary files. Perhaps they were already removed?\n"

printf "$PRINTF_OK"
