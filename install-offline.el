#!/usr/bin/env emacs --script
;;; install-offline.el --- Install everything from local download/ directory -*- lexical-binding: t -*-

(require 'package)

(defvar download-dir (expand-file-name "download"))

(unless (file-directory-p download-dir)
  (error "Download directory %s not found. Run download.el first." download-dir))

;; --- 1. Install ELPA packages ---
(message "=== Installing Emacs packages ===")
(let ((source-elpa (expand-file-name "elpa" download-dir))
      (target-elpa (expand-file-name "~/.emacs.d/elpa")))
  (unless (file-directory-p source-elpa)
    (error "No elpa directory found in %s" download-dir))
  (when (file-directory-p target-elpa)
    (message "Removing existing elpa directory...")
    (delete-directory target-elpa t))
  (copy-directory source-elpa target-elpa t t t)
  (package-initialize)
  ;; Recompile in case Emacs version differs between download and install machines
  (message "Recompiling packages for current Emacs version...")
  (byte-recompile-directory target-elpa 0 t)
  (message "ELPA packages installed"))

;; --- 2. Install term-toggle ---
(message "=== Installing term-toggle ===")
(let ((source (expand-file-name "emacs-term-toggle" download-dir))
      (target "deps/emacs-term-toggle"))
  (unless (file-directory-p source)
    (error "emacs-term-toggle not found in download/"))
  (make-directory "deps" t)
  (when (file-directory-p target)
    (delete-directory target t))
  (copy-directory source target t t t)
  (package-install-file (expand-file-name "term-toggle.el" target))
  (message "term-toggle installed"))

;; --- 3. Install tramp-rpc ---
(message "=== Installing tramp-rpc ===")
(let ((source (expand-file-name "emacs-tramp-rpc" download-dir))
      (target (expand-file-name "~/lang/elisp/emacs-tramp-rpc")))
  (unless (file-directory-p source)
    (error "emacs-tramp-rpc not found in download/"))
  (make-directory (expand-file-name "~/lang/elisp") t)
  (when (file-directory-p target)
    (delete-directory target t))
  (copy-directory source target t t t)
  (message "tramp-rpc installed to %s" target)
  (let ((binary (expand-file-name "server/target/release/tramp-rpc-server" target)))
    (if (file-exists-p binary)
        (message "Rust binary found at %s" binary)
      (message "WARNING: Rust binary missing. If architecture differs, run 'cargo build --release' in %s/server"
               target))))

;; tramp is installed from the elpa/ snapshot (GNU ELPA version >= 2.8.1.4)

;; --- 4. Install fonts ---
(message "=== Installing fonts ===")
(let ((font-dir (expand-file-name "~/.local/share/fonts")))
  (make-directory font-dir t)
  (dolist (zip (directory-files download-dir t "\\.zip$"))
    (message "Extracting %s..." (file-name-nondirectory zip))
    (shell-command
     (format "unzip -o %s -d %s"
             (shell-quote-argument zip)
             (shell-quote-argument download-dir))))
  (dolist (ttc (directory-files download-dir t "\\.ttc$"))
    (message "Installing font %s..." (file-name-nondirectory ttc))
    (copy-file ttc (expand-file-name (file-name-nondirectory ttc) font-dir) t))
  (message "Rebuilding font cache...")
  (shell-command "fc-cache -fv")
  (message "Fonts installed"))

;; --- 5. Copy .emacs to home ---
(message "=== Copying .emacs ===")
(let ((src ".emacs")
      (dst (expand-file-name "~/.emacs")))
  (if (file-exists-p src)
      (progn
        (copy-file src dst t)
        (message ".emacs copied to %s" dst))
    (message "Warning: .emacs not found in current directory")))

;; --- 6. Setup ~/.emacs.d ---
(let ((emacs-d-dir (expand-file-name "~/.emacs.d")))
  (unless (file-directory-p emacs-d-dir)
    (make-directory emacs-d-dir)
    (message "Created ~/.emacs.d")))

;; --- 7. Optional Emacs tarball notice ---
(let ((emacs-tarball (expand-file-name "emacs-30.2.tar.xz" download-dir)))
  (when (file-exists-p emacs-tarball)
    (message "Emacs 30.2 source tarball found at %s" emacs-tarball)
    (message "To build: tar -xJf %s && cd emacs-30.2 && ./configure && make && sudo make install"
             emacs-tarball)
    (message "(Requires build dependencies to be pre-installed)")))

(message "=== Offline installation complete ===")
