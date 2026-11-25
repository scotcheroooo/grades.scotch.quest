#!/usr/bin/env bash
# Build the sideloadable zip, and optionally install it on a Roku in developer mode.
#   ./package.sh                       -> builds out/homehub.zip
#   ./package.sh 192.168.1.50 mypass   -> builds and installs to that Roku
set -euo pipefail
cd "$(dirname "$0")"
mkdir -p out
rm -f out/homehub.zip
zip -qr out/homehub.zip manifest source components images data
echo "Built out/homehub.zip"
if [ $# -ge 2 ]; then
  curl -sS --user "rokudev:$2" --digest \
    -F "mysubmit=Install" -F "archive=@out/homehub.zip" \
    "http://$1/plugin_install" | grep -o '<font color="red">[^<]*' | sed 's/<font color="red">//' || true
  echo "Sent to Roku at $1"
fi
