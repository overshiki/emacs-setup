
My personal setup scripts for Emacs configuration and dependencies.

## Overview

A collection of scripts to install Emacs, configure fonts, and set up post-installation requirements.

## Files

| File | Description |
|------|-------------|
| `build-emacs.sh` | Main script to install Emacs (bash), current emacs version is emacs-30.2 |
| `install-fonts.el` | Script to install required fonts (Emacs Lisp) |
| `install.el` | Emacs Lisp dependencies (used by `setup.el`, no need to run directly) |
| `setup.el` | Post-installation setup script (Emacs Lisp) |
| `.emacs` | Emacs configuration file |
| `markdown-preview-mode/` | Markdown preview mode files |

## Usage

1. **Build Emacs**:
   ```bash
   ./build-emacs.sh
   ```

2. **Install fonts** (optional):
   ```bash
   emacs --script install-fonts.el
   ```

3. **Run post-installation setup**:
   ```bash
   emacs --script setup.el
   ```

## What `setup.el` Does

- Creates `~/.emacs.d` directory if it doesn't exist
- Copies `.emacs` to `~/.emacs`
- Installs `term-toggle` from `deps/`
- Downloads and extracts `tramp-2.8.1.3` to `~/lang/elisp/`
- Clones and builds `emacs-tramp-rpc` Rust server

## Note

- `install.el` is a dependency loaded by `setup.el` during installation
- Do not run `install.el` directly


## reference

Keybindings & usage

 Key / Command          Action
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
 C-x g                  Open Magit status with staged/unstaged diffs
 C-x M-g                Open Magit dispatch menu
 M-x git-timemachine    Step through history of current file


Common Magit keys in the status buffer
 Key   Action
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
 s     Stage file/hunk at point
 u     Unstage file/hunk at point
 S     Stage all changes
 U     Unstage all changes
 TAB   Expand/collapse diff for file at point
 RET   Jump to source from a diff hunk
 c c   Commit staged changes
 d d   Diff arbitrary refs/branches
 k     Discard changes (destructive — use carefully)
 ?     Show all available keys
