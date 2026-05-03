#!/bin/sh

check_command() {
	command -v "$1" > /dev/null 2>&1 \
		|| {
			printf " Cannot find \033[1m${1}\033[0m. Exiting ...\n" \
			&& exit 1
		}
}

print_line() {
	CLEAR_LINE="\r\033[K\033[1A\033[K"
	printf "${CLEAR_LINE} ${1}\n"
}

reveal_cursor() {
	printf "\033[?25h\n"
	exit
}

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

PRINTF_ERR="\033[1;31mERR\033[0m"
PRINTF_OK="\033[1;32mOK\033[0m"

check_command curl
check_command sha256sum

if test -n "$1"; then
	GETHUB_REPO_NAME="$1"
fi

trap reveal_cursor EXIT INT TERM

printf "\n\n\033[?25l"
mkdir -p ~/.local/bin

print_line "Fetching environment ..."

curl -fLsS \
	"https://${GETHUB_REPO_HOST}/${GETHUB_REPO_NAME}/${GETHUB_REPO_BRANCH}/${GETHUB_REPO_ENV}" \
	> "$GETHUB_TMP_ENVIRONMENT_FILE" \
	|| {
		print_line "Couldn't find a valid GEThub environment. Exiting ..."
		exit 1
	}

export $(grep '^GETHUB_' "$GETHUB_TMP_ENVIRONMENT_FILE" | xargs)

if test -n "$2"; then
	case "$2" in
		'?')
			print_line '?'
			;;
		'X')
			print_line "Uninstalling ..."
			rm -f "${GETHUB_BIN_DIR}/${GETHUB_APP_NAME}"
			print_line "$PRINTF_OK"
			;;
		*)
			print_line "\"${2}\" not recognized."
			exit 1
			;;
	esac
	exit
fi

print_line "Downloading executable ..."

curl -fLsS \
	"$GETHUB_APP_URL" \
	> "$GETHUB_TMP_EXECUTABLE_FILE" \
	|| {
		print_line "Couldn't find the specified source distributable."
		exit 1
	}

print_line "Installing ..."

\cp -f "$GETHUB_TMP_EXECUTABLE_FILE" "${GETHUB_BIN_DIR}/${GETHUB_APP_NAME}" \
	|| {
		print_line "Failed to install."
		exit 1
	}

chmod +x "${GETHUB_BIN_DIR}/${GETHUB_APP_NAME}"

rm "$GETHUB_TMP_EXECUTABLE_FILE" "$GETHUB_TMP_ENVIRONMENT_FILE" \
	|| print_line "Failed to purge temporary files. Perhaps they were already removed?"

print_line "$PRINTF_OK"
