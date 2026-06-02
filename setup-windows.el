#!/usr/bin/env emacs --script
;;; setup-windows.el --- Windows Emacs setup -*- lexical-binding: t -*-
;;; Commentary:
;;; Copies .emacs-windows to the correct init file location on Windows.
;;; Also installs term-toggle from deps/ if available.
;;; Code:

(unless (eq system-type 'windows-nt)
  (message "WARNING: This script is designed for Windows. Detected: %s" system-type))

(let ((src "./.emacs-windows")
      (dst (expand-file-name "~/.emacs")))
  (unless (file-exists-p src)
    (error "Source file .emacs-windows not found in current directory"))
  (message "Copying %s to %s ..." src dst)
  (copy-file src dst t)
  (message "Copied successfully."))

(let ((emacs-d-dir (expand-file-name "~/.emacs.d")))
  (unless (file-directory-p emacs-d-dir)
    (make-directory emacs-d-dir)
    (message "Created %s" emacs-d-dir)))

;; Install term-toggle from cached deps if available
(let ((term-toggle-dir "deps/emacs-term-toggle"))
  (when (file-exists-p (expand-file-name "term-toggle.el" term-toggle-dir))
    (message "Installing term-toggle...")
    (package-install-file (expand-file-name "term-toggle.el" term-toggle-dir))
    (message "term-toggle installed.")))

(message "Windows setup complete. Start Emacs to install remaining packages.")
;;; setup-windows.el ends here
