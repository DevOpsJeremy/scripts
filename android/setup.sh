#!/use/bin/env sh

set -euox

. /etc/os-release
curl -sSk https://packages.microsoft.com/config/debian/$VERSION_ID/packages-microsoft-prod.deb -o m.deb
sudo dpkg -i m.deb
rm m.deb

sudo apt update && \
  sudo apt install -y \
  git-all \
  python3 \
  python3-venv \
  powershell

