# dotfiles

Personal setup applied automatically to VS Code Dev Containers.

Configure in VS Code user `settings.json`:

```json
{
  "dotfiles.repository": "<path-or-git-url-to-this-repo>",
  "dotfiles.targetPath": "~/dotfiles",
  "dotfiles.installCommand": "install.sh"
}
```

`install.sh` runs once per container, after it's created. It is safe to re-run
by hand.

## Claude Code

`install.sh` installs the `claude` CLI and symlinks:

| In the container          | Points to                   |
|---------------------------|-----------------------------|
| `~/.claude/CLAUDE.md`     | `claude/CLAUDE.md`          |
| `~/.claude/settings.json` | `claude/settings.json`      |

Edits made through those links land in `~/dotfiles`; commit and push them from
there, or they are lost when the container is rebuilt.

### Per-project memory and plans

Project memory and plans can contain project details, so they are not kept in
this repo. They live in a `.claude-local` folder in the project itself, which is
on the workspace mount and survives container rebuilds:

```
/workspaces/<project>/.claude-local/
  memory/   -> linked as ~/.claude/projects/<project-key>/memory
  plans/    -> linked as ~/.claude/plans
```

One-time setup per project clone:

```sh
cd /workspaces/<project>
mkdir -p .claude-local/memory .claude-local/plans
echo '.claude-local/' >> .git/info/exclude   # local to this clone, never committed

# If Claude was already used in this container, copy its current memory and
# plans in first (the project key is the path with non-alphanumerics as '-').
key="$(pwd | sed 's/[^A-Za-z0-9]/-/g')"
cp -a ~/.claude/projects/"$key"/memory/. .claude-local/memory/ 2>/dev/null || true
cp -a ~/.claude/plans/. .claude-local/plans/ 2>/dev/null || true

~/dotfiles/install.sh                        # create the links
```

Existing files or folders at a link target are moved aside to
`<name>.bak.<timestamp>` rather than overwritten. Once the links work (check
with `ls -ld ~/.claude/plans ~/.claude/projects/*/memory`), remove the
backups:

```sh
rm -rf ~/.claude/*.bak.* ~/.claude/projects/*/*.bak.*
```

`~/.claude/plans` is shared by all projects, so if a container has several
projects with `.claude-local/plans`, only the first one is linked.

Never commit `~/.claude/.credentials.json`, `history.jsonl`, session transcripts
(`projects/*/*.jsonl`), `file-history/` or `paste-cache/`.
