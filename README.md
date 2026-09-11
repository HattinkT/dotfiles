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

`install.sh` runs once per container, after it's created.
