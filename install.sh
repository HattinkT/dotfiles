#!/usr/bin/env bash
# Run automatically by VS Code Dev Containers after the dotfiles repo is cloned
# into a devcontainer (see "dotfiles.installCommand" in VS Code user settings).
# Safe to re-run by hand, e.g. after adding a .claude-local folder to a project.
set -euo pipefail

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CLAUDE_DIR="$HOME/.claude"

if ! command -v claude &> /dev/null; then
  curl -fsSL https://claude.ai/install.sh | bash
fi

if ! grep -q '.local/bin' ~/.bashrc 2>/dev/null; then
  echo 'export PATH="$HOME/.local/bin:$PATH"' >> ~/.bashrc
fi

# Make $2 a symlink to $1. An existing real file or directory at $2 is moved
# aside to a timestamped .bak so nothing is lost.
link() {
  local src="$1" dst="$2"
  mkdir -p "$(dirname "$dst")"
  if [ -e "$dst" ] && [ ! -L "$dst" ]; then
    mv "$dst" "$dst.bak.$(date +%Y%m%d%H%M%S)"
  fi
  ln -sfn "$src" "$dst"
}

# User-level Claude config, shared by all projects.
link "$DOTFILES_DIR/claude/CLAUDE.md" "$CLAUDE_DIR/CLAUDE.md"
link "$DOTFILES_DIR/claude/settings.json" "$CLAUDE_DIR/settings.json"

# Per-project memory and plans live in <workspace>/.claude-local, which is on
# the workspace mount and so survives container rebuilds. Projects without a
# .claude-local folder are left alone.
plans_linked=""
for local_dir in /workspaces/*/.claude-local; do
  [ -d "$local_dir" ] || continue
  project_dir="$(dirname "$local_dir")"
  # Claude Code names project folders after the project path with every
  # non-alphanumeric character replaced by '-'.
  project_key="$(printf '%s' "$project_dir" | sed 's/[^A-Za-z0-9]/-/g')"

  if [ -d "$local_dir/memory" ]; then
    link "$local_dir/memory" "$CLAUDE_DIR/projects/$project_key/memory"
  fi

  # ~/.claude/plans is shared by all projects, so only the first project with
  # a plans folder gets it.
  if [ -d "$local_dir/plans" ]; then
    if [ -z "$plans_linked" ]; then
      link "$local_dir/plans" "$CLAUDE_DIR/plans"
      plans_linked="$project_dir"
    else
      echo "install.sh: ~/.claude/plans already linked to $plans_linked, skipping $project_dir" >&2
    fi
  fi
done
