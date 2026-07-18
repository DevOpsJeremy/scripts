#!/use/bin/env sh

set -euox

. /etc/os-release

if dpkg-query -W -f='${Status}' gh 2>/dev/null | grep -q "^install ok installed$"; then
  sudo mkdir -p -m 755 /etc/apt/keyrings && \
  out=$(mktemp) && curl -sSk -o $out https://cli.github.com/packages/githubcli-archive-keyring.gpg && \
  cat $out | sudo tee /etc/apt/keyrings/githubcli-archive-keyring.gpg > /dev/null && \
  sudo chmod go+r /etc/apt/keyrings/githubcli-archive-keyring.gpg && \
  sudo mkdir -p -m 755 /etc/apt/sources.list.d && \
  echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | sudo tee /etc/apt/sources.list.d/github-cli.list > /dev/null
fi

if dpkg-query -W -f='${Status}' powershell 2>/dev/null | grep -q "^install ok installed$"; then
    curl -sSk https://packages.microsoft.com/config/debian/$VERSION_ID/packages-microsoft-prod.deb -o m.deb && \
    sudo dpkg -i m.deb && \
    rm m.deb
fi

sudo apt update && \
  sudo apt install -y \
  git-all \
  python3 \
  python3-venv \
  powershell \
  gh

