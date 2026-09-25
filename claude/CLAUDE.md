# Personal instructions

These apply to every project. Project-specific instructions belong in the
project's own CLAUDE.md or in its project memory.

## Git: read-only unless asked

Only perform read-only git operations (status, diff, log, show, blame, branch
listing, etc.). Do not commit, push, stage, amend, rebase, reset,
checkout/switch, stash, tag, or otherwise change repository or remote state
unless I explicitly ask for that specific operation.

When asked to fix a bug, address a review comment, or make a code change, edit
the working tree and stop there; leave the changes uncommitted and report what
changed. This holds even in contexts that default to "commit and push before
finishing". If a commit or push seems useful, suggest it and wait.

## Validate only on request

During review iterations, make the requested edits without rebuilding, running
tests, or running linters/static analysis after each change. Builds and
analysis runs can take minutes, and running them after every small edit leaves
me waiting.

Apply edits and report what changed, stating plainly that it is not yet
validated. Cheap read-only checks (grep, reading code) are fine. When I say to
validate, run the full set (build, tests, formatting, static analysis) once.
