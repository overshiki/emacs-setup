
My personal setup scripts for Emacs configuration and dependencies.

## Overview

A collection of Racket scripts to install Emacs, configure fonts, and set up post-installation requirements.

## Files

| File | Description |
|------|-------------|
| `emacs.rkt` | Main script to install Emacs, current emacs version is emacs-30.2 |
| `font.rkt` | Script to install required fonts |
| `install.el` | Emacs Lisp dependencies (used by `emacs.rkt`, no need to run directly) |
| `setup-emacs.rkt` | Post-installation setup script |
| `.emacs` | Emacs configuration file |
| `markdown-preview-mode/` | Markdown preview mode files |

## Usage

1. **Install fonts** (optional):
   ```bash
   racket font.rkt
   ```

2. **Install Emacs**:
   ```bash
   racket emacs.rkt
   ```

3. **Run post-installation setup**:
   ```bash
   racket setup-emacs.rkt
   ```

## What `setup-emacs.rkt` Does

- Creates `~/.emacs.d` directory if it doesn't exist
- Copies `.emacs` to `~/.emacs`
- Copies `markdown-preview-mode/` to `~/.emacs.d/markdown-preview-mode/`

## Note

- `install.el` is a dependency loaded by `emacs.rkt` during installation
- Do not run `install.el` directly
