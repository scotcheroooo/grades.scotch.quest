#!/usr/bin/env bash
# Build the sideloadable zip, and optionally install it on a Roku in developer mode.
#   ./package.sh                       -> builds out/better-roku-os.zip
#   ./package.sh 192.168.1.50 mypass   -> builds and installs to that Roku
set -euo pipefail
cd "$(dirname "$0")"
mkdir -p out
rm -f out/better-roku-os.zip
zip -qr out/better-roku-os.zip manifest source components images data
echo "Built out/better-roku-os.zip"
if [ $# -ge 2 ]; then
  curl -sS --user "rokudev:$2" --digest \
    -F "mysubmit=Install" -F "archive=@out/better-roku-os.zip" \
    "http://$1/plugin_install" | grep -o '<font color="red">[^<]*' | sed 's/<font color="red">//' || true
  echo "Sent to Roku at $1"
fi
