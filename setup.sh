#!/bin/sh
# Outside the devcontainer: installs (or updates) Bash Learn and the course's other
# extensions from the Marketplace, then opens this repository in VS Code.
# In WSL, run it from the WSL terminal so the extensions go to the WSL side.

if ! command -v code > /dev/null 2>&1; then
  echo "No se encuentra el comando 'code'. Instala VS Code y, en macOS, ejecuta en VS Code" >&2
  echo "'Shell Command: Install 'code' command in PATH'. En WSL, instala VS Code en Windows." >&2
  exit 1
fi

for ext in ull-ssoo.bash-learn timonwong.shellcheck mads-hartmann.bash-ide-vscode; do
  code --install-extension "$ext" --force || exit 1
done
code "$(dirname "$0")"
