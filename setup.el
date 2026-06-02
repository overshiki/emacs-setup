#!/usr/bin/env emacs --script
;;; setup.el --- Post-installation setup -*- lexical-binding: t -*-

;; Install term-toggle
(unless (file-directory-p "deps")
  (make-directory "deps")
  (shell-command "cd deps && git clone https://github.com/amno1/emacs-term-toggle.git"))

(load "install.el")

;; Setup ~/.emacs.d
(let ((emacs-d-dir (expand-file-name "~/.emacs.d")))
  (if (file-directory-p emacs-d-dir)
      (message "~/.emacs.d already exists.")
    (make-directory emacs-d-dir)
    (message "Created ~/.emacs.d")))

;; Copy .emacs to home directory
(let ((src ".emacs")
      (dst (expand-file-name "~/.emacs")))
  (if (file-exists-p src)
      (progn
        (message "Copying %s to %s..." src dst)
        (copy-file src dst t)
        (message "Copied successfully."))
    (message "Warning: %s source file not found!" src)))

;; Configure git colors for Emacs shell
(message "Configuring git...")
(shell-command "git config --global color.ui always")
(shell-command "git config --global core.pager cat")

;; Install tramp-rpc to ~/lang/elisp
(message "Setting up tramp-rpc...")
(shell-command "mkdir -p ~/lang/elisp")

;; Clone emacs-tramp-rpc
(shell-command "cd ~/lang/elisp && git clone https://github.com/ArthurHeymans/emacs-tramp-rpc.git || true")

;; Build tramp-rpc Rust server
(unless (executable-find "cargo")
  (message "Installing Rust via rustup...")
  (shell-command "curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y"))
(shell-command ". \"$HOME/.cargo/env\" 2>/dev/null; cd ~/lang/elisp/emacs-tramp-rpc/server && cargo build --release")

;; Check librime for emacs-rime
(message "Checking librime for rime input method...")
(unless (executable-find "gcc")
  (message "WARNING: gcc not found. rime module cannot be compiled."))
(unless (or (file-exists-p "/usr/include/rime_api.h")
            (file-exists-p "/usr/local/include/rime_api.h"))
  (message "WARNING: librime headers not found. Install librime-dev (Ubuntu) or librime-devel (Rocky) for rime IME."))

(message "Setup complete.")
