#!/usr/bin/env bash
# Lakera Guard Demo: quick installer for macOS.
#
#   curl -fsSL https://raw.githubusercontent.com/mkol5222/lakera-demo-app/main/install.sh | bash
#
# Downloads the latest release from GitHub over HTTPS, verifies its SHA-256
# checksum, installs "Lakera Guard Demo.app" into /Applications (or
# ~/Applications when /Applications is not writable) and opens it.
#
# Environment overrides:
#   INSTALL_DIR=/path   install somewhere else
#   NO_OPEN=1           do not launch the app after installing
set -euo pipefail

REPO="mkol5222/lakera-demo-app"
APP="Lakera Guard Demo.app"
ASSET="Lakera-Guard-Demo_macos-universal.app.zip"
BASE="https://github.com/${REPO}/releases/latest/download"

say() { printf '\033[1;35m==>\033[0m %s\n' "$*"; }
die() { printf '\033[1;31merror:\033[0m %s\n' "$*" >&2; exit 1; }

[ "$(uname -s)" = "Darwin" ] || die "this installer supports macOS only"
for cmd in curl ditto shasum; do
  command -v "$cmd" >/dev/null 2>&1 || die "missing required command: $cmd"
done

fetch() { curl -fsSL --proto '=https' --tlsv1.2 --retry 3 -o "$2" "$1"; }

tmp="$(mktemp -d)"
trap 'rm -rf "$tmp"' EXIT

say "Downloading latest release of ${APP%.app}"
fetch "${BASE}/${ASSET}" "$tmp/$ASSET" || die "download failed"
fetch "${BASE}/SHA256SUMS.txt" "$tmp/SHA256SUMS.txt" || die "checksum download failed"

say "Verifying SHA-256 checksum"
expected="$(awk -v f="$ASSET" '{ n=$2; sub(/^\.\//, "", n); if (n == f) print $1 }' "$tmp/SHA256SUMS.txt")"
actual="$(shasum -a 256 "$tmp/$ASSET" | awk '{print $1}')"
[ -n "$expected" ] || die "no checksum listed for $ASSET"
[ "$expected" = "$actual" ] || die "checksum mismatch (expected $expected, got $actual)"

dest="${INSTALL_DIR:-/Applications}"
if [ -z "${INSTALL_DIR:-}" ] && [ ! -w "$dest" ]; then
  dest="$HOME/Applications"
fi
mkdir -p "$dest"

if pgrep -xq lakera-demo; then
  say "Quitting running app"
  osascript -e 'quit app "Lakera Guard Demo"' >/dev/null 2>&1 || true
  sleep 1
fi

say "Installing to $dest/$APP"
ditto -x -k "$tmp/$ASSET" "$tmp/unpacked"
[ -d "$tmp/unpacked/$APP" ] || die "archive does not contain $APP"
rm -rf "${dest:?}/$APP"
ditto "$tmp/unpacked/$APP" "$dest/$APP"
# The app is ad-hoc signed and not notarized. Files fetched by curl carry no
# quarantine flag, but clear it anyway so Gatekeeper does not block the first launch.
xattr -dr com.apple.quarantine "$dest/$APP" 2>/dev/null || true

say "Installed ${APP%.app} ($(defaults read "$dest/$APP/Contents/Info" CFBundleShortVersionString 2>/dev/null || echo '?'))"
if [ -z "${NO_OPEN:-}" ]; then
  open "$dest/$APP"
fi
