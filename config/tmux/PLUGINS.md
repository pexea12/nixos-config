# tmux plugins

Managed by [TPM](https://github.com/tmux-plugins/tpm).

| Action | Key |
|---|---|
| Install plugins | `prefix + I` |
| Update plugins | `prefix + U` |
| Remove unlisted plugins | `prefix + alt + u` |

---

## tmux-sensible

Sane baseline defaults that everyone can agree on. No manual usage needed.

---

## tmux-yank

Copy to system clipboard from copy mode.

| Action | Key |
|---|---|
| Enter copy mode | `prefix + [` |
| Start selection | `v` |
| Copy to clipboard | `y` |
| Copy current command line | `prefix + y` |
| Copy current working directory | `prefix + Y` |

---

## tmux-resurrect

Manually save and restore tmux sessions across reboots. Preserves windows, panes, and pane contents.

| Action | Key |
|---|---|
| Save session | `prefix + Ctrl-s` |
| Restore session | `prefix + Ctrl-r` |

---

## tmux-continuum

Automatic companion to tmux-resurrect. Saves sessions every 15 minutes and restores on tmux start.

No manual action needed. Configured with:
- `@continuum-restore on` — auto-restore on tmux start
- `@resurrect-capture-pane-contents on` — saves pane contents

---

## vim-tmux-navigator

Seamless navigation between vim splits and tmux panes using the same keys. No prefix needed.

| Action | Key |
|---|---|
| Move left | `Ctrl-h` |
| Move down | `Ctrl-j` |
| Move up | `Ctrl-k` |
| Move right | `Ctrl-l` |
