#lang racket
(require "lib.rkt")
(require racket/match)

(define sys (get-os))

(match sys
  ('ubuntu
   (begin
     (display "ubuntu linux")
     (system "sudo apt-get update")
     (system "sudo apt-get install -y libgnutls28-dev libtinfo-dev pkg-config libgccjit-12-dev ripgrep")))
  ('rocky
   (begin
     (display "rocky linux")
     (system "sudo yum install -y gnutls pkg-config gnutls-devel ncurses-devel zlib zlib-devel libgccjit libgccjit-devel ripgrep")))
  ;; nothing matched
  (_
   (display "system not recognized"))
   (raise 'failed #t)
  )
(system "wget -c https://mirror.ossplanet.net/gnu/emacs/emacs-30.2.tar.xz")
(system "tar -xvf emacs-30.2.tar.xz")
(system "cd emacs-30.2 && ./configure && make -j4 && sudo make install")
