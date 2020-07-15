#!/usr/bin/env sh
# Download and install the latest evkill release
# Environment:
#   - ARCH: download evkill for this architecture, use use current system
#           architecture as a default.
set -euo pipefail

ARCH="${ARCH:-$(uname -m)}"

REPO="Enteee/evkill"

curl -s "https://api.github.com/repos/${REPO}/releases/latest" \
   | grep "${ARCH}" \
   | grep "browser_download_url" \
   | cut -d '"' -f 4 \
   | xargs -n1 curl -s -L --output evkill

chmod +x evkill
