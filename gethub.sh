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
PRINTF_ELLIPSIS='\033[37m...\033[0m'
PRINTF_ERR='\n \033[1;31mERR\033[0m\n\n'
PRINTF_OK='\n \033[1;32mOK\033[0m\n\n'
PRINTF_PIPE='\033[93m\342\224\203\033[0m'

if test -n "$1"; then
	GETHUB_REPO_NAME="$1"
fi

printf "\n"
printf "     \033[1;93mGETHUB\033[0m: ${GETHUB_VERSION}\n"
printf " \033[1;93mREPOSITORY\033[0m: ${GETHUB_REPO_NAME}\n"
printf "     \033[1;93mBRANCH\033[0m: ${GETHUB_REPO_BRANCH}\n"
printf "\n"
printf " ${PRINTF_PIPE} Fetching remote environment ${PRINTF_ELLIPSIS}\n"

curl -fLsS \
	"https://${GETHUB_REPO_HOST}/${GETHUB_REPO_NAME}/${GETHUB_REPO_BRANCH}/${GETHUB_REPO_ENV}" \
	> "$GETHUB_TMP_ENVIRONMENT_FILE" \
	|| {
		printf " ${PRINTF_PIPE} Couldn't find a valid GEThub environment.\n"
		printf "$PRINTF_ERR"
		exit 1
	}

export $(grep '^GETHUB_' "$GETHUB_TMP_ENVIRONMENT_FILE" | xargs)

if test -n "$2" && test "$2" = 'X'; then
	printf " ${PRINTF_PIPE} Uninstalling ${PRINTF_ELLIPSIS}\n"
	rm "${GETHUB_BIN_DIR}/${GETHUB_APP_NAME}" || {
		printf "$PRINTF_ERR"
		exit 1
	}
	printf "$PRINTF_OK"
	exit
fi

printf " ${PRINTF_PIPE} Downloading executable ${PRINTF_ELLIPSIS}\n"

curl -fLsS \
	"$GETHUB_APP_URL" \
	> "$GETHUB_TMP_EXECUTABLE_FILE" \
	|| {
		printf " ${PRINTF_PIPE} Couldn't find the specified source distributable.\n"
		printf "$PRINTF_ERR"
		exit 1
	}

printf " ${PRINTF_PIPE} Installing ${PRINTF_ELLIPSIS}\n"

\cp -f "$GETHUB_TMP_EXECUTABLE_FILE" "${GETHUB_BIN_DIR}/${GETHUB_APP_NAME}" \
	|| {
		printf " ${PRINTF_PIPE} Failed to install.\n"
		printf "$PRINTF_ERR"
		exit 1
	}

chmod +x "${GETHUB_BIN_DIR}/${GETHUB_APP_NAME}"

rm "$GETHUB_TMP_EXECUTABLE_FILE" "$GETHUB_TMP_ENVIRONMENT_FILE" \
	|| printf " ${PRINTF_PIPE} Failed to purge temporary files. Perhaps they were already removed?\n"

printf "$PRINTF_OK"
