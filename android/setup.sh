#!/use/bin/env sh

set -euox

download() {
  set +e

  SOURCE="$1"
  if [ -z "$SOURCE" ]; then
    echo "ERROR: No source provided"
    exit 1
  fi
  CURL_ARGS="'$SOURCE'"
  shift

  DEST="$1"
  if [ ! -z "$DEST" ]; then
    CURL_ARGS="$CURL_ARGS -o '$DEST'"
    shift
  fi

  EXTRA_ARGS="$@"
  if [ -z "$EXTRA_ARGS" ]; then
    EXTRA_ARGS="-sSk"
  fi
  CURL_ARGS="$CURL_ARGS $EXTRA_ARGS"
  set -e

  echo curl $CURL_ARGS
  curl $CURL_ARGS
}
gh_get() {
  set +e

  DOWNLOAD_ARGS=""

  SOURCE="$1"
  if [ -z "$SOURCE" ]; then
    echo "ERROR: No source provided"
    exit 1
  fi
  SOURCE="$1"
  shift

  DEST="$1"
  if [ ! -z "$DEST" ]; then
    DOWNLOAD_ARGS="$DOWNLOAD_ARGS '$DEST'"
    shift
  fi

  BRANCH="$1"
  if [ -z "$BRANCH" ]; then
    BRANCH="main"
  else
    shift
  fi

  BRANCH="$1"
  if [ -z "$BRANCH" ]; then
    BRANCH="scripts"
  fi

  URL="https://raw.githubusercontent.com/DevOpsJeremy/$REPO/refs/heads/$BRANCH/$SOURCE"
  DOWNLOAD_ARGS="$URL $DOWNLOAD_ARGS"
  set -e

  echo download $DOWNLOAD_ARGS
  download $DOWNLOAD_ARGS
}

. /etc/os-release

if dpkg-query -W -f='${Status}' gh 2>/dev/null | grep -q "^install ok installed$"; then
  sudo mkdir -p -m 755 /etc/apt/keyrings && \
  out=$(mktemp) && download https://cli.github.com/packages/githubcli-archive-keyring.gpg $out && \
  cat $out | sudo tee /etc/apt/keyrings/githubcli-archive-keyring.gpg > /dev/null && \
  sudo chmod go+r /etc/apt/keyrings/githubcli-archive-keyring.gpg && \
  sudo mkdir -p -m 755 /etc/apt/sources.list.d && \
  echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | sudo tee /etc/apt/sources.list.d/github-cli.list > /dev/null
fi

if dpkg-query -W -f='${Status}' powershell 2>/dev/null | grep -q "^install ok installed$"; then
    out=$(mktemp)
    download https://packages.microsoft.com/config/debian/$VERSION_ID/packages-microsoft-prod.deb $out && \
    sudo dpkg -i m.$out && \
    rm $out
fi

sudo apt update && \
  sudo apt install -y \
  git-all \
  python3 \
  python3-venv \
  powershell \
  gh

gh_get android/setup.sh
