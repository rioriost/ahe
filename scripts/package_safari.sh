#!/bin/sh
# Generate a local macOS host app without changing Safari or signing settings.
set -eu
cd "$(dirname "$0")/.."
if [ -e 'build/safari/Anti-Homograph Extension' ]; then
    printf '%s\n' 'The generated project already exists; build it or move it before regenerating.' >&2
    exit 1
fi
mkdir -p build/safari
xcrun safari-web-extension-converter extension \
    --project-location build/safari \
    --app-name 'Anti-Homograph Extension' \
    --bundle-identifier st.rio.ahe \
    --macos-only --swift --no-open --no-prompt
