#!/usr/bin/env bash
set -o errexit
set -o pipefail

url="${1:?Usage: yt-thumb.sh <url>}"
tmpdir="$(mktemp -d /tmp/yt-thumb-XXXXXX)"

cleanup() {
    rm -rf "$tmpdir"
}
trap cleanup EXIT

yt-dlp --write-thumbnail --skip-download -o "$tmpdir/thumb" "$url" >/dev/null 2>&1

thumb_file=$(find "$tmpdir" -type f 2>/dev/null | head -1)

if [[ -z "$thumb_file" ]]; then
    echo "No thumbnail found for $url"
    exit 1
fi

dims="$(tput cols)x$(tput lines)@0x0"
kitty +kitten icat --clear 2>/dev/null || true
kitty +kitten icat --hold --scale-up --place "$dims" "$thumb_file" 2>/dev/null
