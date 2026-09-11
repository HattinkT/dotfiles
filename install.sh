#!/usr/bin/env bash
# Run automatically by VS Code Dev Containers after the dotfiles repo is cloned
# into a devcontainer (see "dotfiles.installCommand" in VS Code user settings).
set -euo pipefail

if ! command -v claude &> /dev/null; then
  curl -fsSL https://claude.ai/install.sh | bash
fi

if ! grep -q '.local/bin' ~/.bashrc 2>/dev/null; then
  echo 'export PATH="$HOME/.local/bin:$PATH"' >> ~/.bashrc
fi
