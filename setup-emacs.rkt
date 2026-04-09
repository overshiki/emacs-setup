#!/usr/bin/env racket
#lang racket

(require racket/file)

;; Get home directory
(define home-dir (find-system-path 'home-dir))

;; Paths
(define emacs-d-dir (build-path home-dir ".emacs.d"))
(define emacs-file (build-path home-dir ".emacs"))


(when (not (directory-exists? "deps"))
  (system "mkdir deps")
  (system "cd deps && git clone https://github.com/amno1/emacs-term-toggle.git")
  )
 
(system "emacs --script install.el")

;; (define markdown-preview-src "markdown-preview-mode")
;; (define markdown-preview-dest (build-path emacs-d-dir "markdown-preview-mode"))

(define eww-style-tgt "~/.emacs.d/modern-eww-style.el")
(define eww-style-src "./modern-eww-style.el")

(define emacs-src ".emacs")

;; Check if .emacs.d exists, create if not
(if (directory-exists? emacs-d-dir)
    (printf "~a already exists.~n" emacs-d-dir)
    (begin
      (printf "Creating ~a directory...~n" emacs-d-dir)
      (make-directory emacs-d-dir)
      (printf "~a created successfully.~n" emacs-d-dir)))

;; Copy .emacs to home directory
(if (file-exists? emacs-src)
    (begin
      (printf "Copying ~a to ~a...~n" emacs-src emacs-file)
      (when (file-exists? emacs-file)
        (printf "Destination ~a already exists, overwriting...~n" emacs-file))
      (copy-file emacs-src emacs-file #t)  ; #t means overwrite
      (printf "~a copied successfully to ~a~n" emacs-src emacs-file))
    (printf "Warning: ~a source file not found!~n" emacs-src))

;; Copy modern-eww-style.el into ~/.emacs.d/ 
(copy-file eww-style-src eww-style-tgt)

;; ;; Copy markdown-preview-mode to .emacs.d
;; (if (directory-exists? markdown-preview-src)
;;     (begin
;;       (printf "Copying ~a to ~a...~n" markdown-preview-src markdown-preview-dest)
;;       ;; Remove destination if it already exists
;;       (when (directory-exists? markdown-preview-dest)
;;         (printf "Destination ~a already exists, removing old version...~n" markdown-preview-dest)
;;         (delete-directory/files markdown-preview-dest))
;;       ;; Copy the directory
;;       (copy-directory/files markdown-preview-src markdown-preview-dest)
;;       (printf "~a copied successfully to ~a~n" markdown-preview-src markdown-preview-dest))
;;     (printf "Error: ~a source directory not found!~n" markdown-preview-src))
