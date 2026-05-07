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

;; Install tramp and tramp-rpc to ~/lang/elisp
(system "mkdir -p ~/lang/elisp")

;; Download and extract tramp 2.8.1.3
(system "wget -c https://ftp.gnu.org/gnu/tramp/tramp-2.8.1.3.tar.gz -O /tmp/tramp-2.8.1.3.tar.gz")
(system "cd ~/lang/elisp && tar -xzf /tmp/tramp-2.8.1.3.tar.gz")

;; Clone emacs-tramp-rpc
(system "cd ~/lang/elisp && git clone https://github.com/ArthurHeymans/emacs-tramp-rpc.git || true")

;; Build tramp-rpc Rust server
(when (not (system "which cargo > /dev/null 2>&1"))
  (display "Installing Rust via rustup...\n")
  (system "curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y"))
(system ". \"$HOME/.cargo/env\" 2>/dev/null; cd ~/lang/elisp/emacs-tramp-rpc/server && cargo build --release")

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

