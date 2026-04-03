(require 'package)

(setq package-archives '(("gnu" . "https://mirrors.ustc.edu.cn/elpa/gnu/")
                         ("melpa" . "https://mirrors.ustc.edu.cn/elpa/melpa/")
                         ("nongnu" . "https://mirrors.ustc.edu.cn/elpa/nongnu/")))

(setq package-list
      '(corfu
        cape
        jedi
        company
        multiple-cursors
        use-package
        auto-highlight-symbol
        auto-complete
        highlight-parentheses
        clipmon
        highlight-indent-guides
        swiper-helm
        lsp-haskell
        doom-themes
        go-mode
        haskell-mode
        futhark-mode
        racket-mode
        tuareg         ;;; ocaml
        julia-mode
        rust-mode
        markdown-mode
        elixir-mode
        scala-mode
        transpose-frame
        matlab-mode
        counsel
        merlin-eldoc
        gruber-darker-theme
        ))

(package-initialize)
(dolist (package package-list)
  (unless (package-installed-p package)
    (package-refresh-contents)
    (package-install package)))

;;; -*- lexical-binding: t -*-
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(custom-enabled-themes '(doom-ayu-dark))
 '(custom-safe-themes
   '("5c7720c63b729140ed88cf35413f36c728ab7c70f8cd8422d9ee1cedeb618de5"
     "599f72b66933ea8ba6fce3ae9e5e0b4e00311c2cbf01a6f46ac789227803dd96"
     "166a2faa9dc5b5b3359f7a31a09127ebf7a7926562710367086fcc8fc72145da"
     "5244ba0273a952a536e07abaad1fdf7c90d7ebb3647f36269c23bfd1cf20b0b8"
     "73ae9ba31609c7cb11be2012f06ffb5e3c9c34886ea60cc9c2a72e4e2a281ddb"
     "9b9d7a851a8e26f294e778e02c8df25c8a3b15170e6f9fd6965ac5f2544ef2a9"
     default))
 '(package-selected-packages nil))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(default ((t (:family "Ubuntu Mono" :foundry "DAMA" :slant normal :weight normal :height 220 :width normal)))))

;; (add-hook 'python-mode-hook 'jedi:setup)

;; use company instead of this
;; ;; https://stackoverflow.com/questions/8095715/emacs-auto-complete-mode-at-startup
;; (global-auto-complete-mode t)
;; (defun auto-complete-mode-maybe ()
;;   "No maybe for you. Only AC!"
;;   (unless (minibufferp (current-buffer))
;;     (auto-complete-mode 1)))

;; I prefer no theme in the end
;; (load-theme 'doom-dark+ :no-confirm)
;; (load-theme 'doom-ayu-dark :no-confirm)
;; (load-theme 'gruber-darker :no-confirm)
;; (load-theme 'doom-ayu-light :no-confirm)
(load-theme 'doom-one-light :no-confirm)

;; (use-package dired+
;;   :ensure t
;;   :config
;;   (setq diredp-hide-details-flag nil)
;;   (diredp-toggle-find-file-relation)
;;   (diredp-toggle-automatic-preview-mode)
;;   (diredp-toggle-highlight-autofiles-mode))

(use-package diredfl
  :ensure t
  :hook (dired-mode . diredfl-mode))

(tool-bar-mode -1)
(menu-bar-mode -1)
(setq inhibit-startup-message t)


(tab-bar-mode t)

(setq-default indent-tabs-mode nil)
(setq-default tab-width 2
              standard-indent 2
              )

(require 'highlight-parentheses)
(define-globalized-minor-mode global-highlight-parentheses-mode
  highlight-parentheses-mode
  (lambda ()
    (highlight-parentheses-mode t)))
(global-highlight-parentheses-mode t)

(global-hl-line-mode 1)
;; (set-face-attribute 'hl-line nil :foreground nil)

(global-display-line-numbers-mode 1)

(setq-default cursor-type 'bar)


(add-hook 'prog-mode-hook 'highlight-indent-guides-mode)
(global-auto-highlight-symbol-mode t)

;; (define-key global-map (kbd "C-;") 'comment-line)

(defun end-of-line-and-indented-new-line ()
  (interactive)
  (end-of-line)
  (newline-and-indent))

(define-key global-map (kbd "C-o") 'end-of-line-and-indented-new-line)
;; (define-key global-map (kbd "C-.") 'find-file)
(define-key global-map (kbd "C-z") 'undo)
(define-key global-map (kbd "C-x C-e") 'end-of-buffer)
(define-key global-map (kbd "C-x e") 'end-of-buffer)
(define-key global-map (kbd "C-x C-a") 'beginning-of-buffer)
(define-key global-map (kbd "C-x a") 'beginning-of-buffer)

(define-key global-map (kbd "C-j") 'comment-line)


(setq make-backup-files nil) ; stop creating ~ files

;; use company instead of this
;; (global-corfu-mode)
;; (corfu-popupinfo-mode)
;; (setq corfu-terminal t)
;; (add-to-list 'completion-at-point-functions #'cape-file)
;; (add-to-list 'completion-at-point-functions #'cape-dabbrev)


(global-hl-line-mode 1)
(set-face-attribute 'hl-line nil :foreground nil)

(defun xah-select-line ()
  (interactive)
  (if (region-active-p)
      (if visual-line-mode
          (let ((xp1 (point)))
            (end-of-visual-line 1)
            (when (eq xp1 (point))
              (end-of-visual-line 2)))
        (progn
          (forward-line 1)
          (end-of-line)))
    (if visual-line-mode
        (progn (beginning-of-visual-line)
               (push-mark (point) t t)
               (end-of-visual-line))
      (progn
        (push-mark (line-beginning-position) t t)
        (end-of-line)))))

(global-set-key (kbd "C-l") 'xah-select-line)

(defun xah-forward-block (&optional n)
  (interactive "p")
  (let ((n (if (null n) 1 n)))
    (re-search-forward "\n[\t\n ]*\n+" nil "NOERROR" n)))

(global-set-key (kbd "M-n") 'xah-forward-block)

(defun xah-backward-block (&optional n)
  "Move cursor to previous text block.
See: `xah-forward-block'
URL `http://xahlee.info/emacs/emacs/emacs_move_by_paragraph.html'
Version 2016-06-15"
  (interactive "p")
  (let ((n (if (null n) 1 n))
        ($i 1))
    (while (<= $i n)
      (if (re-search-backward "\n[\t\n ]*\n+" nil "NOERROR")
          (progn (skip-chars-backward "\n\t "))
        (progn (goto-char (point-min))
               (setq $i n)))
      (setq $i (1+ $i)))))

(global-set-key (kbd "M-p") 'xah-backward-block)

(require 'multiple-cursors)

(global-set-key (kbd "C-d") 'mc/mark-next-like-this)
(global-set-key (kbd "C-<") 'mc/mark-previous-like-this)
(global-set-key (kbd "C-c C-<") 'mc/mark-all-like-this)
;; (global-set-key (kbd "C-i") 'kill-ring-save)


;; https://stackoverflow.com/questions/28221079/ctrl-backspace-in-emacs-deletes-too-much
;; https://www.reddit.com/r/emacs/comments/2ny06e/delete_text_not_kill_it_into_killring/
(defun my-delete-word (arg)
  "Delete characters forward until encountering the end of a word.
With argument, do this that many times.
This command does not push erased text to kill-ring."
  (interactive "p")
  (delete-region (point) (progn (forward-word arg) (point))))

;; (defun my-backward-delete-word (arg)
;;   "Delete characters backward until encountering the beginning of a word.
;; With argument, do this that many times.
;; This command does not push erased text to kill-ring."
;;   (interactive "p")
;;   (my-delete-word (- arg)))

;; (global-set-key [C-backspace] 'my-backward-delete-word)

;; (defun le/backward-delete-word (arg)
;;   (interactive "p")
;;   (delete-region (point) (progn (my-backward-word-or-other arg) (point))))

(defun previous-line-end-position-from (pos) 
  (save-excursion
    (goto-char pos)
    (forward-line -1)
    (end-of-line)
    (point)))

(defun next-line-start-position-from (pos)
  (save-excursion
    (goto-char pos)
    (forward-line)
    (beginning-of-line)
    (point)))

(defun le/backward-kill-word-stop-at-newline (arg)
  (interactive "p")
  (let (
        (start (point))
        (stop nil)
        (line-start (line-beginning-position))
       )
    ;; (forward-word -1)
    (my-backward-word-or-other arg)
    (setq stop (point))
    
    (if (save-excursion
            (goto-char start)
            (re-search-backward "\n" stop t))
      ;; (setq stop (line-beginning-position 0)))
        ;; then
        (progn 
          (setq stop (previous-line-end-position-from line-start))
          ;; (goto-char (previous-line-end-position-from line-start))
          (delete-region start stop)
          (goto-char stop)
          
        )
      ;; else
        (delete-region start stop)
      )))

(global-set-key [C-backspace] 'le/backward-kill-word-stop-at-newline)


(defun le/forward-word-stop-at-newline (arg)
  (interactive "p")
  (let (
        (pos (point))
        (is-end-of-line (= (point)
                           (save-excursion
                             (end-of-line)
                             (point))))
       )
    (if (save-excursion
        (forward-word)
        (re-search-backward "\n" pos t))
        ;; then
        (if is-end-of-line
            (goto-char (next-line-start-position-from (point)))
            (end-of-line))
      ;; else
      (forward-word)
      )))

(defun move-text-internal (arg)
  (cond
   ((and mark-active transient-mark-mode)
    (if (> (point) (mark))
        (exchange-point-and-mark))
    (let ((column (current-column))
          (text (delete-and-extract-region (point) (mark))))
      (forward-line arg)
      (move-to-column column t)
      (set-mark (point))
      (insert text)
      (exchange-point-and-mark)
      (setq deactivate-mark nil)))
   (t
    (let ((column (current-column)))
      (beginning-of-line)
      (when (or (> arg 0) (not (bobp)))
        (forward-line)
        (when (or (< arg 0) (not (eobp)))
          (transpose-lines arg))
        (forward-line -1))
      (move-to-column column t)))))

(defun move-text-down (arg)
  "Move region (transient-mark-mode active) or current line
  arg lines down."
  (interactive "*p")
  (move-text-internal arg))

(defun move-text-up (arg)
  "Move region (transient-mark-mode active) or current line
  arg lines up."
  (interactive "*p")
  (move-text-internal (- arg)))

(provide 'move-text)

(global-set-key (kbd "C-S-P") 'move-text-up)
(global-set-key (kbd "C-S-N") 'move-text-down)


(global-set-key (kbd "C-S-<up>") 'move-text-up)
(global-set-key (kbd "C-S-<down>") 'move-text-down)

;; (global-set-key (kbd "<M-up>") 'move-text-up)
;; (global-set-key (kbd "<M-down>") 'move-text-down)

;; lsp
;; ;; use eglot instead
;; language servers
(require 'lsp)
(require 'lsp-haskell)
;; Hooks so haskell and literate haskell major modes trigger LSP setup
(add-hook 'haskell-mode-hook #'lsp)
(add-hook 'haskell-literate-mode-hook #'lsp)


(defun haskell-format-buffer-with-ormolu ()
  "Format the current Haskell buffer using ormolu."
  (interactive)
  (unless (buffer-modified-p)
    (save-excursion
      (shell-command-on-region (point-min) (point-max) "ormolu" (current-buffer) t))))


(add-hook 'haskell-mode-hook
          (lambda ()
            (add-hook 'before-save-hook 'haskell-format-buffer-with-ormolu nil t)))


;; auto-complete
(add-hook 'interactive-haskell-mode-hook 'ac-haskell-process-setup)
(add-hook 'haskell-interactive-mode-hook 'ac-haskell-process-setup)
(eval-after-load "auto-complete"
  '(add-to-list 'ac-modes 'haskell-interactive-mode))



(use-package lsp-mode
  :hook (python-mode . lsp)
  :config
  (setq lsp-pyls-server-command '("pylsp")))


(add-hook 'flymake-mode-hook
          (lambda ()
            (setq flymake-suppress-zero-counters t)
            (setq flymake-start-on-flymake-mode t)
            (flymake-mode 1)))

(use-package lsp-ui
  :after lsp-mode
  :hook (lsp-mode . lsp-ui-mode)
  :config
  (setq lsp-ui-sideline-enable t
        lsp-ui-sideline-show-diagnostics t
        lsp-ui-sideline-diagnostic-max-lines 3
        lsp-ui-sideline-delay 0.5))
            
          

(define-key global-map (kbd "C-x p") 'previous-buffer)
(define-key global-map (kbd "C-x n") 'next-buffer)
(define-key global-map (kbd "C-x C-p") 'previous-buffer)
(define-key global-map (kbd "C-x C-n") 'next-buffer)

(define-key global-map (kbd "C-M-]") 'term-toggle-shell)
(define-key global-map (kbd "C-`") 'term-toggle-shell)

(define-key global-map (kbd "C-s") 'swiper-thing-at-point)
(define-key global-map (kbd "M-s") 'counsel-ag)
;; (define-key global-map (kbd "C-s") 'save-buffer)


(define-key global-map (kbd "C-k") 'kill-line)
(define-key global-map (kbd "M-k") 'kill-region)
;; (global-set-key (kbd "TAB") 'tab-to-tab-stop)
(global-set-key (kbd "TAB") (lambda () (interactive) (insert "  ")))
;; (setq-default indent-tabs-mode nil)
								
;; (global-whitespace-mode 1)

;; https://emacs.stackexchange.com/questions/26417/custom-c-arrow-cursor-movement
;; (setq separators-regexp "[\-'\"();:,.\\/?!@#%&*+=\([:blank:]*\)]")
(setq separators-regexp "['\"();:,.\\/!@#%&*+=]")
(defun forward-to-separator()
    "Move to the next separator like in the every NORMAL editor"
    (interactive)
    (let ((my-pos (re-search-forward separators-regexp)))
        (goto-char my-pos)))

(defun backward-to-separator()
    "Move to the previous separator like in the every NORMAL editor"
    (interactive)
    (let ((my-pos (re-search-backward separators-regexp)))
        (goto-char my-pos)))


(defun my-backward-word-or-other (&optional n)
  "Move over the preceding word or non-word characters."
  (interactive "p")
  (unless (bobp)
    (if (eq ?w (char-syntax (char-before)))
        (backward-word)
      (skip-syntax-backward "^w"))))

(defun my-forward-word-or-other ()
  "Move over the following word or non-word characters."
  (interactive)
  (unless (eobp)
    (if (eq ?w (char-syntax (char-after)))
        (forward-word)
      (skip-syntax-forward "^w"))))


;; (global-set-key (kbd "C-<right>") 'forward-to-separator)
;; (global-set-key (kbd "C-<left>") 'backward-to-separator)
;; (global-set-key (kbd "M-f") 'forward-to-separator)
;; (global-set-key (kbd "M-b") 'backward-to-separator)


;; (global-set-key (kbd "C-<right>") 'my-forward-word-or-other)
(global-set-key (kbd "C-<right>") 'le/forward-word-stop-at-newline)
(global-set-key (kbd "C-<left>") 'my-backward-word-or-other)
;; (global-set-key (kbd "M-f") 'my-forward-word-or-other)
(global-set-key (kbd "M-f") 'forward-char)
(global-set-key (kbd "C-f") 'le/forward-word-stop-at-newline)
(global-set-key (kbd "M-b") 'backward-char)
(global-set-key (kbd "C-b") 'my-backward-word-or-other)


(ivy-mode t)
;; (require 'ido)
;; (ido-mode t)

(company-mode t)  ;; auto-completion
(add-hook 'after-init-hook 'global-company-mode)

;; ;; use lsp instead
;; (add-hook 'haskell-mode-hook 'eglot-ensure)
;; (add-hook 'haskell-cabal-mode-hook 'eglot-ensure)
;; (add-hook 'racket-mode-hook 'eglot-ensure)


(setopt ivy-use-selectable-prompt t)
(global-git-gutter-mode +1)

(unless (file-exists-p "~/.emacs.d/tmp/tramp-autosaves/")
  (make-directory "~/.emacs.d/tmp/tramp-autosaves/" t))
(setq tramp-auto-save-directory "~/.emacs.d/tmp/tramp-autosaves/")


;; (defun kb-scroll-up-hold-cursor ()
;;   "Scroll up one position in file."
;;   (interactive)
;;   (scroll-up-command 1))

;; (defun kb-scroll-down-hold-cursor ()
;;   "Scroll down one position in file."
;;   (interactive)
;;   (scroll-up-command -1))

;; (defun kb-scroll-up ()
;;   "Scroll up one position in file, move cursor with the scroll."
;;   (interactive)
;;   (scroll-up-command -1)
;;   (forward-line -1))

;; (defun kb-scroll-down ()
;;   "Scroll down one position in file, move cursor with the scroll."
;;   (interactive)
;;   (scroll-up-command 1)
;;   (forward-line 1))

;; ;; (bind-key "C-M-P"  'kb-scroll-up-hold-cursor)
;; ;; (bind-key "C-M-N"  'kb-scroll-down-hold-cursor)

;; (global-set-key (kbd "<C-M-up>") 'kb-scroll-up-hold-cursor)
;; (global-set-key (kbd "<C-M-down>") 'kb-scroll-down-hold-cursor)

(defun kb-scroll-up-hold-cursor ()
  "Scroll up one position in file."
  (interactive)
  (scroll-up-command 1)
  (forward-line 1))

(defun kb-scroll-down-hold-cursor ()
  "Scroll down one position in file."
  (interactive)
  (scroll-up-command -1)
  (forward-line -1))


;; (global-set-key (kbd "M-p") 'kb-scroll-up-hold-cursor)
;; (global-set-key (kbd "M-n") 'kb-scroll-down-hold-cursor)

(global-set-key (kbd "M-<up>") 'kb-scroll-down-hold-cursor)
(global-set-key (kbd "M-<down>") 'kb-scroll-up-hold-cursor)

(global-set-key (kbd "M-w") 'kill-region)
(global-set-key (kbd "C-w") 'kill-ring-save)
(global-set-key (kbd "C-v") 'yank)

(setq inhibit-startup-screen t)

(let ((opam-share (ignore-errors (car (process-lines "opam" "var" "share")))))
 (when (and opam-share (file-directory-p opam-share))
  ;; Register Merlin
  (add-to-list 'load-path (expand-file-name "emacs/site-lisp" opam-share))
  (autoload 'merlin-mode "merlin" nil t nil)
  ;; Automatically start it in OCaml buffers
  (add-hook 'tuareg-mode-hook 'merlin-mode t)
  (add-hook 'caml-mode-hook 'merlin-mode t)
  ;; Use opam switch to lookup ocamlmerlin binary
  (setq merlin-command 'opam)
  ;; To easily change opam switches within a given Emacs session, you can
  ;; install the minor mode https://github.com/ProofGeneral/opam-switch-mode
  ;; and use one of its "OPSW" menus.
  ))

(merlin-eldoc-setup)


;; Jump to Dired (from file buffer)
(defun dired-jump-to-current-dir ()
  "Open Dired in the directory of the current buffer's file."
  (interactive)
  (if buffer-file-name
      (progn
        (setq dired-jump-last-buffer (current-buffer))
        (dired (file-name-directory buffer-file-name)))
    (dired default-directory)))

;; Jump back to file (from Dired)
(defvar dired-jump-last-buffer nil
  "Last buffer before jumping to Dired.")

(defun jump-back-to-file-from-dired ()
  "If in Dired, jump back to the file at point or last buffer."
  (interactive)
  (if (derived-mode-p 'dired-mode)
      (let ((file (dired-get-file-for-visit)))
        (cond
         ((file-regular-p file)
          (find-file file))
         ((and dired-jump-last-buffer (buffer-live-p dired-jump-last-buffer))
          (switch-to-buffer dired-jump-last-buffer))
         (t (message "No file to jump to"))))
    (message "Not in Dired")))

;; Keybindings
(global-set-key (kbd "C-x C-<up>") #'dired-jump-to-current-dir)
(global-set-key (kbd "C-x C-<down>") #'jump-back-to-file-from-dired)

;; ========== markdown-preview-mode Configuration ==========
;; ============================================
;; Configuration
;; ============================================

;; Tell markdown-preview-mode where to find custom template
(setq markdown-preview--preview-template
      (expand-file-name "~/.emacs.d/markdown-preview-mode/preview.html"))

;; Override to send raw markdown instead of rendered HTML
(with-eval-after-load 'markdown-preview-mode
  (defun markdown-preview--send-preview-to (websocket preview-uuid)
    (let ((md-buffer (gethash preview-uuid markdown-preview--preview-buffers)))
      (when md-buffer
        (with-current-buffer md-buffer
          (let* ((raw-source (buffer-substring-no-properties (point-min) (point-max)))
                 (total-lines (max 1 (count-lines (point-min) (point-max))))
                 (current-line (line-number-at-pos))
                 (window-lines (count-screen-lines (window-start) (point)))
                 (mark-position-percent (number-to-string 
                    (truncate (* 100 (/ (float (- current-line (/ window-lines 2))) total-lines)))))
                 ;; Encode to UTF-8 bytes first, then base64
                 (utf8-bytes (encode-coding-string raw-source 'utf-8))
                 (encoded-source (base64-encode-string utf8-bytes t)))
            
            (websocket-send-text websocket
              (concat "<div data-b64=\""
                      encoded-source
                      "\" data-pos=\""
                      mark-position-percent
                      "\"></div>"))))))))

;; Auto-mode for .md files
(add-to-list 'auto-mode-alist '("\\.md\\'" . markdown-mode))
(add-to-list 'auto-mode-alist '("\\.markdown\\'" . markdown-mode))

(global-auto-revert-mode t)
(setq auto-revert-verbose nil)
(setq auto-revert-interval 1)            ; Check every second (default is 5)
(setq revert-without-query '(".*"))      ; Never ask, just reload

(load-file (let ((coding-system-for-read 'utf-8))
                (shell-command-to-string "agda --emacs-mode locate")))
