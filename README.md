# herdr-atuin

A [Herdr](https://herdr.dev) plugin that resumes your agent panes through [Atuin threads](https://atuin.sh) after a Herdr restart.

Herdr already restores your workspaces, tabs and panes. This plugin changes what each agent pane runs when it comes back: `atuin threads resume <session>` instead of the agent's own resume. Atuin catches the thread up from sync first, and writes the session back out if the agent's local copy is gone.

Each pane is matched by the session Herdr's own integration reported for it, so several agents in the same directory each get their own session back.

## Install

```sh
herdr plugin install atuinsh/herdr-atuin
```

You need:

- Herdr 0.9.2 or later, with its integration installed for your agent (`herdr integration install claude`, `herdr integration install codex`, ...)
- Atuin with thread capture on (`atuin threads enable`)
- `jq` on your `PATH`

## How it works

When Herdr detects an agent in a pane, or its status changes, the plugin reads the session Herdr has for that pane. If Atuin has captured that thread, the plugin reports `atuin threads resume <session>` as the pane's resume command. Until Atuin has the thread, it leaves the pane alone and Herdr's own resume applies.

To stop resuming agents altogether, set `resume_agents_on_restore = false` under `[session]` in Herdr's config.
