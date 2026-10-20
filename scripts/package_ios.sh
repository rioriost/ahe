#!/bin/sh
# Generate an iPhone/iPad host from the shared extension without touching macOS archives.
set -eu
cd "$(dirname "$0")/.."
if [ -e 'build/safari-ios/Anti-Homograph Extension' ]; then
    printf '%s\n' 'The iOS project already exists; build it or move it before regenerating.' >&2
    exit 1
fi
mkdir -p build/safari-ios
xcrun safari-web-extension-converter extension \
    --project-location build/safari-ios \
    --app-name 'Anti-Homograph Extension' \
    --bundle-identifier st.rio.ahe \
    --ios-only --swift --no-open --no-prompt
python3 scripts/prepare_ios.py
