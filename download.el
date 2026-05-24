#!/usr/bin/env emacs --script
;;; download.el --- Cache all dependencies for offline installation -*- lexical-binding: t -*-

(require 'package)
(require 'url)

(defvar download-dir (expand-file-name "download"))
(defvar download-elpa-dir (expand-file-name "elpa" download-dir))

(make-directory download-dir t)

;; --- 1. ELPA/MELPA packages ---
;; We snapshot the entire local ~/.emacs.d/elpa/ directory. This captures
;; ALL installed packages (including dependencies and packages not explicitly
;; declared in use-package blocks) with their exact versions.
(message "=== Snapshotting Emacs packages ===")
(let ((local-elpa (expand-file-name "~/.emacs.d/elpa")))
  (unless (file-directory-p local-elpa)
    (error "No local elpa directory found at %s" local-elpa))
  (when (file-directory-p download-elpa-dir)
    (delete-directory download-elpa-dir t))
  (copy-directory local-elpa download-elpa-dir t t t)
  (message "Copied packages to %s" download-elpa-dir))

;; --- 2. Git repositories ---
(message "=== Cloning git repositories ===")

(let ((dir (expand-file-name "emacs-term-toggle" download-dir)))
  (if (file-directory-p dir)
      (message "emacs-term-toggle already exists, skipping...")
    (message "Cloning emacs-term-toggle...")
    (shell-command
     (format "git clone --depth 1 https://github.com/amno1/emacs-term-toggle.git %s"
             (shell-quote-argument dir)))))

(let ((dir (expand-file-name "emacs-tramp-rpc" download-dir)))
  (if (file-directory-p dir)
      (message "emacs-tramp-rpc already exists, skipping...")
    (message "Cloning emacs-tramp-rpc...")
    (shell-command
     (format "git clone --depth 1 https://github.com/ArthurHeymans/emacs-tramp-rpc.git %s"
             (shell-quote-argument dir))))
  ;; Build Rust server (WARNING: binary is architecture-specific!)
  (message "Building tramp-rpc server...")
  (let ((default-directory (expand-file-name "server" dir)))
    (shell-command "cargo build --release")))

;; --- 3. Tarballs ---
(message "=== Downloading tarballs ===")

;; tramp is now installed from GNU ELPA (captured in elpa/ snapshot)
;; and automatically kept up-to-date via package-install.

;; Optional: Emacs source tarball (for build-emacs.sh)
(let ((emacs-file (expand-file-name "emacs-30.2.tar.xz" download-dir)))
  (if (file-exists-p emacs-file)
      (message "emacs tarball already exists, skipping...")
    (message "Downloading Emacs 30.2 tarball...")
    (url-copy-file "https://mirror.ossplanet.net/gnu/emacs/emacs-30.2.tar.xz"
                   emacs-file t)))

;; --- 4. Fonts ---
(message "=== Downloading fonts ===")

(dolist (url '("https://github.com/be5invis/Iosevka/releases/download/v33.3.6/PkgTTC-SGr-Iosevka-33.3.6.zip"
               "https://github.com/be5invis/Iosevka/releases/download/v33.3.6/PkgTTC-SGr-IosevkaTerm-33.3.6.zip"))
  (let ((file (expand-file-name (file-name-nondirectory url) download-dir)))
    (if (file-exists-p file)
        (message "%s already exists, skipping..." (file-name-nondirectory file))
      (message "Downloading %s..." (file-name-nondirectory file))
      (url-copy-file url file t))))

(message "=== All downloads complete in %s ===" download-dir)
