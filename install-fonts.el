#!/usr/bin/env emacs --script
;;; install-fonts.el --- Install Iosevka fonts -*- lexical-binding: t -*-

(require 'url)

(let ((urls '("https://github.com/be5invis/Iosevka/releases/download/v33.3.6/PkgTTC-SGr-Iosevka-33.3.6.zip"
              "https://github.com/be5invis/Iosevka/releases/download/v33.3.6/PkgTTC-SGr-IosevkaTerm-33.3.6.zip"))
      (font-dir (expand-file-name "~/.local/share/fonts")))
  (dolist (url urls)
    (let ((file (file-name-nondirectory url)))
      (unless (file-exists-p file)
        (message "Downloading %s..." file)
        (url-copy-file url file))
      (message "Extracting %s..." file)
      (call-process "unzip" nil nil nil "-o" file)))
  (make-directory font-dir t)
  (dolist (ttc (directory-files default-directory t "\\.ttc$"))
    (message "Installing %s..." (file-name-nondirectory ttc))
    (copy-file ttc (expand-file-name (file-name-nondirectory ttc) font-dir) t))
  (message "Rebuilding font cache...")
  (call-process "fc-cache" nil nil nil "-fv")
  (message "Fonts installed."))
