#!/usr/bin/env sh

REPO_URL=${REPO_URL:-${1:-https://github.com/DevOpsJeremy/server}}
REPO_PATH=${REPO_PATH:-${2:-~/.server}}
ENABLE_CRED_HELPER=${ENABLE_CRED_HELPER:-${3:-true}}
CREDENTIAL_HELPER=${CREDENTIAL_HELPER:-${4:-store}}

SUDO=" "
if [ $(command -v sudo 2>/dev/null) ]; then
	SUDO="sudo "
fi

GIT_PKG=${GIT_PKG:-git}
if command -v apt-get >/dev/null 2>&1; then
	pkg_update() {
		${SUDO}apt update $@
	}
	pkg_install() {
		${SUDO}apt install -y $@
	}
elif command -v dnf >/dev/null 2>&1; then
	pkg_update() {
		${SUDO}dnf update -y $@
	}
	pkg_install() {
		${SUDO}dnf install -y $@
	}
elif command -v yum >/dev/null 2>&1; then
	pkg_update() {
		${SUDO}yum update -y
	}
	pkg_install() {
		${SUDO}yum install -y
	}
elif command -v pacman >/dev/null 2>&1; then
	pkg_update() {
		${SUDO}pacman -Sy
	}
	pkg_install() {
		${SUDO}pacman -S
	}
elif command -v apk >/dev/null 2>&1; then
	pkg_update() {
		${SUDO}apk update
	}
	pkg_install() {
		${SUDO}apk add
	}
else
	echo "Unsupported package manager"
	exit 1
fi

pkg_update
pkg_install $GIT_PKG

if [ "$ENABLE_CRED_HELPER" == "true" ]; then
	git config --global credential.helper $CREDENTIAL_HELPER
fi

mkdir -p "$(dirname "$REPO_PATH")"
git clone "$REPO_URL" "$REPO_PATH"
