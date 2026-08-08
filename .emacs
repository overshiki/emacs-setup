;;; -*- lexical-binding: t -*-

(require 'package)
(require 'bind-key)

(setq package-archives '(("gnu" . "https://mirrors.ustc.edu.cn/elpa/gnu/")
                         ("melpa" . "https://mirrors.ustc.edu.cn/elpa/melpa/")
                         ("nongnu" . "https://mirrors.ustc.edu.cn/elpa/nongnu/")))

(package-initialize)

;; Load ELPA tramp early before any package can pull in the built-in version.
;; tramp-rpc requires >= 2.8.1.4, so we ensure the ELPA copy takes precedence.
(require 'tramp)

;; Append extra directories from ~/.exec-paths to `exec-path'.
(defun my/load-exec-paths ()
  "Append entries from ~/.exec-paths to `exec-path'."
  (let ((file (expand-file-name "~/.exec-paths")))
    (when (file-exists-p file)
      (with-temp-buffer
        (insert-file-contents file)
        (goto-char (point-min))
        (while (not (eobp))
          (let ((line (string-trim (thing-at-point 'line t))))
            (unless (or (string-empty-p line) (string-prefix-p "#" line))
              (add-to-list 'exec-path (expand-file-name line))))
          (forward-line 1))))))
(my/load-exec-paths)

;; Suppress harmless RPC lock-file warnings when reverting buffers.
;; These occur because TRAMP-RPC cannot find Emacs' local lock-file symlinks.
(require 'warnings)
(add-to-list 'warning-suppress-log-types '(unlock-file))

;; Enable ANSI color rendering in M-x shell
(add-hook 'shell-mode-hook 'ansi-color-for-comint-mode-on)

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(package-selected-packages
   '(auto-highlight-symbol cape clipmon cmake-mode company corfu counsel
                           diff-hl dired-sidebar diredfl dirvish
                           doom-themes eat elixir-mode futhark-mode
                           git-timemachine go-mode gptel grip-mode
                           gruber-darker-theme haskell-mode
                           highlight-indent-guides highlight-numbers
                           highlight-parentheses imenu-list jedi
                           julia-mode lsp-haskell magit
                           markdown-preview-mode math-preview mathjax
                           matlab-mode merlin-eldoc msgpack
                           multiple-cursors ninja-mode racket-mode
                           rime rust-mode scala-mode shrface
                           space-theming spacemacs-theme swiper-helm
                           term-toggle texfrag toml-mode
                           transpose-frame treemacs treesit-auto
                           tuareg valign w3m wgrep-ag yaml-mode)))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(default ((t (:family "Ubuntu Mono" :foundry "DAMA" :slant normal :weight normal :height 240 :width normal)))))

;; I prefer no theme in the end
;; (load-theme 'doom-dark+ :no-confirm)
;; (load-theme 'doom-ayu-dark :no-confirm)

(use-package doom-themes
  :ensure t
  :defer t)

(use-package spacemacs-theme
  :ensure t
  :defer t)

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

(use-package highlight-parentheses
  :ensure t
  :config
  (define-globalized-minor-mode global-highlight-parentheses-mode
    highlight-parentheses-mode
    (lambda ()
      (highlight-parentheses-mode t)))
  (global-highlight-parentheses-mode t))

(global-hl-line-mode 1)
;; (set-face-attribute 'hl-line nil :foreground nil)

(global-display-line-numbers-mode 1)

(setq-default cursor-type 'bar)


(use-package highlight-indent-guides
  :ensure t
  :hook (prog-mode . highlight-indent-guides-mode))

(use-package auto-highlight-symbol
  :ensure t
  :config
  (global-auto-highlight-symbol-mode t))

;; ── Major modes ─────────────────────────────────────────
(use-package go-mode :ensure t)
(use-package rust-mode :ensure t)
(use-package julia-mode :ensure t)
(use-package scala-mode :ensure t)
(use-package elixir-mode :ensure t)
(use-package futhark-mode :ensure t)
(use-package racket-mode :ensure t)
(use-package tuareg :ensure t)
(use-package haskell-mode :ensure t)

;; ── Syntax highlighting enhancements ─────────────────────
(use-package highlight-numbers
  :ensure t
  :hook (prog-mode . highlight-numbers-mode))

(use-package treesit-auto
  :ensure t
  :if (fboundp 'treesit-language-available-p)
  :custom
  (treesit-auto-install 'prompt)
  :config
  (treesit-auto-add-to-auto-mode-alist 'all)
  (global-treesit-auto-mode))

(defun my/font-lock-function-calls ()
  "Highlight function/macro calls as `font-lock-function-call-face'."
  (font-lock-add-keywords
   nil
   '(("\\_<\\(\\(?:\\sw\\|\\s_\\)+\\)\\s-*(" 1 'font-lock-function-call-face))
   'append))

(dolist (hook '(python-mode-hook python-ts-mode-hook
                julia-mode-hook julia-ts-mode-hook))
  (add-hook hook #'my/font-lock-function-calls))

(bind-key "C-;" 'comment-line)

(defun end-of-line-and-indented-new-line ()
  (interactive)
  (end-of-line)
  (newline-and-indent))

(bind-key "C-o" 'end-of-line-and-indented-new-line)
;; (bind-key "C-." 'find-file)
(bind-key "C-z" 'undo)
(bind-key "C-x C-e" 'end-of-buffer)
(bind-key "C-x e" 'end-of-buffer)
(bind-key "C-x C-g" 'beginning-of-buffer)
(bind-key "C-x g" 'beginning-of-buffer)

(bind-key "C-j" 'comment-line)


(setq make-backup-files nil) ; stop creating ~ files




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

(bind-key "C-l" 'xah-select-line)

(defun xah-forward-block (&optional n)
  (interactive "p")
  (let ((n (if (null n) 1 n)))
    (re-search-forward "\n[\t\n ]*\n+" nil "NOERROR" n)))

(bind-key "M-n" 'xah-forward-block)

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

(bind-key "M-p" 'xah-backward-block)

(use-package multiple-cursors
  :ensure t
  :bind (("C-c C-d" . mc/mark-next-like-this)
         ("C-<" . mc/mark-previous-like-this)
         ("C-c C-<" . mc/mark-all-like-this)))
(bind-key "C-i" 'kill-ring-save)


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

(bind-key "C-<backspace>" 'my-backward-delete-word)

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

(bind-key "C-<backspace>" 'le/backward-kill-word-stop-at-newline)


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

(bind-key "C-S-P" 'move-text-up)
(bind-key "C-S-N" 'move-text-down)

(bind-key "C-S-<up>" 'move-text-up)
(bind-key "C-S-<down>" 'move-text-down)

(bind-key "<M-up>" 'move-text-up)
(bind-key "<M-down>" 'move-text-down)

;; lsp
;; ;; use eglot instead
;; language servers

(use-package lsp-mode
  :ensure t
  :commands (lsp lsp-deferred)
  :hook ((python-mode . lsp)
         (python-ts-mode . lsp))
  :init
  (setq lsp-auto-guess-root t))

(defun haskell-format-buffer-with-ormolu ()
  "Format the current Haskell buffer using ormolu."
  (interactive)
  (unless (buffer-modified-p)
    (save-excursion
      (shell-command-on-region (point-min) (point-max) "ormolu" (current-buffer) t))))

(setq lsp-headerline-breadcrumb-enable nil)
(setq lsp-lens-enable nil)
(setq lsp-modeline-code-actions-enable nil)
(setq lsp-modeline-diagnostics-enable nil)
(setq lsp-diagnostics-provider :flycheck)  ;; or :none temporarily
(setq lsp-completion-provider :capf)
(setq lsp-enable-file-watchers nil)

(use-package lsp-haskell
  :ensure t
  :after lsp-mode
  :hook ((haskell-mode . lsp-deferred)
         (haskell-literate-mode . lsp-deferred))
  :init
  (add-hook 'haskell-mode-hook
            (lambda ()
              (add-hook 'before-save-hook 'haskell-format-buffer-with-ormolu nil t))))

(use-package auto-complete
  :ensure t
  :config
  (add-hook 'interactive-haskell-mode-hook 'ac-haskell-process-setup)
  (add-hook 'haskell-interactive-mode-hook 'ac-haskell-process-setup)
  (add-to-list 'ac-modes 'haskell-interactive-mode))

(use-package flymake
  :ensure t
  :hook (flymake-mode . (lambda ()
                          (setq flymake-suppress-zero-counters t)
                          (setq flymake-start-on-flymake-mode t)
                          (flymake-mode 1))))


(use-package lsp-ui
  :ensure t
  :after lsp
  :hook (lsp-mode . lsp-ui-mode)
  :config
  (setq lsp-ui-sideline-enable t
        lsp-ui-sideline-show-diagnostics t
        lsp-ui-sideline-diagnostic-max-lines 3
        lsp-ui-sideline-delay 0.5))

;; ── LLM writing assistant (Phase 1: on-demand via gptel) ──
;; Uses DeepSeek API. Key is read from ~/.deepseek_key.
(defun my/load-api-key-from-file (filename)
  "Read the first non-comment line from FILENAME as an API key."
  (let ((file (expand-file-name filename)))
    (if (file-exists-p file)
        (with-temp-buffer
          (insert-file-contents file)
          (goto-char (point-min))
          (let ((key nil))
            (while (and (not key) (not (eobp)))
              (let ((line (string-trim (thing-at-point 'line t))))
                (unless (or (string-empty-p line) (string-prefix-p "#" line))
                  (setq key line)))
              (forward-line 1))
            key))
      (message "API key file not found: %s" file)
      nil)))

(use-package gptel
  :ensure t
  :config
  (setq gptel-model 'deepseek-chat)
  (setq gptel-backend
        (gptel-make-openai "DeepSeek"
          :host "api.deepseek.com"
          :endpoint "/chat/completions"
          :key (my/load-api-key-from-file "~/.deepseek_key")
          :models '(deepseek-chat deepseek-reasoner)
          :stream t)))

(defun my/gptel-improve-writing (start end)
  "Improve selected English text with GPTel.
The improved text is inserted at the region, replacing the original."
  (interactive "r")
  (let ((text (buffer-substring-no-properties start end))
        (start-marker (copy-marker start))
        (end-marker (copy-marker end)))
    (gptel-request
     (format "Improve the following English writing. Fix grammar, clarity, and style. Return only the improved text, no explanation.\n\n%s" text)
     :callback
     (lambda (response _info)
       (if response
           (progn
             (delete-region start-marker end-marker)
             (goto-char start-marker)
             (insert response)
             (message "Writing improved"))
         (message "No response from LLM"))))))

(bind-key "C-c w" #'my/gptel-improve-writing)

(bind-key "C-x p" 'previous-buffer)
(bind-key "C-x C-p" 'previous-buffer)
(bind-key "C-x C-n" 'next-buffer)

(use-package term-toggle
  :ensure nil
  :bind (("C-M-]" . term-toggle-shell)
         ("C-`" . term-toggle-shell)))

(use-package swiper
  :ensure t
  :bind (("C-s" . swiper-thing-at-point)
         ("C-c s" . my/toggle-swiper-all-right)))

(use-package counsel
  :ensure t
  :bind (("M-s" . my/counsel-ag-thing-at-point)
         ("C-c C-s" . my/toggle-counsel-rg-right))
  :config
  (defun my/counsel-ag-thing-at-point ()
    "Search for the thing at point using `counsel-ag'."
    (interactive)
    (let ((input (ivy-thing-at-point)))
      (when (use-region-p)
        (deactivate-mark))
      (counsel-ag (and input (regexp-quote input))))))


(bind-key "C-k" 'kill-line)
(bind-key "M-k" 'kill-region)
(bind-key "TAB" 'tab-to-tab-stop)
(bind-key "TAB" (lambda () (interactive) (insert "  ")))
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


(bind-key "C-<right>" 'forward-to-separator)
(bind-key "C-<left>" 'backward-to-separator)
(bind-key "M-f" 'forward-to-separator)
(bind-key "M-b" 'backward-to-separator)


(bind-key "C-<right>" 'my-forward-word-or-other)
(bind-key "C-<right>" 'le/forward-word-stop-at-newline)
(bind-key "C-<left>" 'my-backward-word-or-other)
(bind-key "M-f" 'my-forward-word-or-other)
(bind-key "M-f" 'forward-char)
(bind-key "C-f" 'le/forward-word-stop-at-newline)
(bind-key "M-b" 'backward-char)
(bind-key "C-b" 'my-backward-word-or-other)

;; (require 'ido)
;; (ido-mode t)

(use-package ivy
  :ensure t
  :config
  (ivy-mode t)
  (setopt ivy-use-selectable-prompt t)
  (ivy-configure 'counsel-rg
    :update-fn 'auto)
  (ivy-configure 'counsel-ag
    :update-fn 'auto))

(use-package company
  :ensure t
  :hook (after-init . global-company-mode))

;; ;; use lsp instead
;; (add-hook 'haskell-mode-hook 'eglot-ensure)
;; (add-hook 'haskell-cabal-mode-hook 'eglot-ensure)
;; (add-hook 'racket-mode-hook 'eglot-ensure)

;; ── Git integration ──────────────────────────────────────
(use-package magit
  :ensure t
  :bind (("C-x g" . magit-status)
         ("C-x M-g" . magit-dispatch)))

(use-package diff-hl
  :ensure t
  :hook ((prog-mode . diff-hl-mode)
         (dired-mode . diff-hl-dired-mode))
  :config
  (global-diff-hl-mode +1))

(use-package git-timemachine
  :ensure t
  :defer t
  :commands (git-timemachine))

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

(bind-key "<C-M-up>" 'kb-scroll-up-hold-cursor)
(bind-key "<C-M-down>" 'kb-scroll-down-hold-cursor)

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


(bind-key "M-n" 'kb-scroll-up-hold-cursor)
(bind-key "M-p" 'kb-scroll-down-hold-cursor)

(bind-key "M-<up>" 'kb-scroll-down-hold-cursor)
(bind-key "M-<down>" 'kb-scroll-up-hold-cursor)

;; ── Review Mode ─────────────────────────────────────────
(defvar my/review-mode-map
  (let ((map (make-sparse-keymap)))
    (define-key map (kbd "C-p") #'kb-scroll-down-hold-cursor)
    (define-key map (kbd "C-n") #'kb-scroll-up-hold-cursor)
    (define-key map (kbd "<up>") #'kb-scroll-down-hold-cursor)
    (define-key map (kbd "<down>") #'kb-scroll-up-hold-cursor)
    map)
  "Keymap for my/review-mode.")

(define-minor-mode my/review-mode
  "Toggle review mode.
In review mode, C-p and C-n scroll the buffer instead of moving point."
  :global t
  :lighter nil
  :keymap my/review-mode-map)

(bind-key "C-c r" #'my/review-mode)
(bind-key "C-c v" #'revert-buffer)

(bind-key "M-w" 'kill-region)
(bind-key "C-w" 'kill-ring-save)
(bind-key "C-v" 'yank)

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

(use-package merlin-eldoc
  :ensure t
  :after merlin
  :config
  (merlin-eldoc-setup))


(defvar dired-jump-history nil
  "Stack of visited directories for C-x C-<down> navigation.")

(defvar dired-jump-last-buffer nil
  "Last buffer before jumping to Dired.")

(defun dired-jump-to-current-dir ()
  "Open Dired in current file's directory, or go to parent if already in Dired."
  (interactive)
  (if (derived-mode-p 'dired-mode)
      ;; Already in Dired: push current to history and go to parent
      (let ((current-dir (dired-current-directory)))
        (push current-dir dired-jump-history)
        (dired-up-directory))
    ;; Not in Dired: save buffer and jump to its directory
    (progn
      (setq dired-jump-history nil)  ; Clear history on fresh jump
      (when buffer-file-name
        (setq dired-jump-last-buffer (current-buffer)))
      (let ((target-dir (if buffer-file-name
                            (file-name-directory buffer-file-name)
                          default-directory)))
        (push target-dir dired-jump-history)
        (dired target-dir)))))

(defun jump-back-from-dired ()
  "Go back through history: child dir → last buffer."
  (interactive)
  (cond
   ;; In Dired with history: go to child directory
   ((and (derived-mode-p 'dired-mode) dired-jump-history)
    (let ((prev-dir (pop dired-jump-history)))
      (if (and prev-dir (file-directory-p prev-dir))
          (dired prev-dir)
        ;; History empty or invalid, try last buffer
        (when (and dired-jump-last-buffer (buffer-live-p dired-jump-last-buffer))
          (switch-to-buffer dired-jump-last-buffer)
          (setq dired-jump-last-buffer nil)))))
   
   ;; In Dired, no history, have last buffer: go to it
   ((and (derived-mode-p 'dired-mode) dired-jump-last-buffer 
         (buffer-live-p dired-jump-last-buffer))
    (switch-to-buffer dired-jump-last-buffer)
    (setq dired-jump-last-buffer nil))
   
   ;; Not in Dired: message
   ((not (derived-mode-p 'dired-mode))
    (message "Not in Dired"))
   
   ;; Nothing to go back to
   (t (message "No previous location"))))

;; Keybindings
(bind-key "C-x C-<up>" #'dired-jump-to-current-dir)
(bind-key "C-x C-<down>" #'jump-back-from-dired)

(bind-key "C-x <up>" #'dired-jump-to-current-dir)
(bind-key "C-x <down>" #'jump-back-from-dired)

(bind-key "C-x u" #'dired-jump-to-current-dir)
(bind-key "C-x n" #'jump-back-from-dired)

(defun copy-token-to-clipboard ()
  "Read first line from ~/.token and copy to clipboard."
  (interactive)
  (let ((token-file (expand-file-name "~/.token")))
    (if (file-exists-p token-file)
        (with-temp-buffer
          (insert-file-contents token-file)
          (goto-char (point-min))
          (let ((token (buffer-substring-no-properties
                        (point)
                        (line-end-position))))
            (kill-new token)
            (message "Token copied to clipboard: %s..." (substring token 0 (min 10 (length token))))))
      (error "Token file not found: %s" token-file))))

;; Bind to C-c t (or choose your own)
(bind-key "C-c t" 'copy-token-to-clipboard)

(require 'json)

(defun ssh-login-from-config ()
  "Read ~/.server JSON, select server via ivy, optionally prompt for password, open TRAMP-RPC at default-path."
  (interactive)
  (let* ((config-file (expand-file-name "~/.server"))
         (json-data (json-read-file config-file))
         (servers (mapcar (lambda (entry)
                            (cons (symbol-name (car entry)) (cdr entry)))
                          json-data))
         (server-name (ivy-read "Server: " (mapcar #'car servers)))
         (server-config (cdr (assoc server-name servers)))
         (user (cdr (assoc 'user server-config)))
         (ip (cdr (assoc 'ip server-config)))
         (is-passwd-required
          (let ((v (cdr (assoc 'is-passwd-required server-config))))
            (not (eq v :json-false))))   ; default true
         (default-path (or (cdr (assoc 'default-path server-config)) "/"))
         (default-path-expanded
          (if (string-prefix-p "/" default-path)
              default-path
            (concat "~/" default-path))))
    (when (or (null user) (null ip))
      (error "Missing 'user' or 'ip' for server %s" server-name))
    (when is-passwd-required
      (let ((passwd (read-passwd (format "Password for %s@%s: " user ip))))
        (auth-source-remember `(:host ,ip :user ,user :protocol "ssh")
                              `((secret . ,passwd)))))
    ;; (find-file (format "/ssh:%s@%s:%s" user ip default-path-expanded))
    (find-file (format "/rpc:%s@%s:%s" user ip default-path-expanded))
    (message "Connecting to %s@%s:%s..." user ip default-path-expanded)))
;; Bind to C-c S
(bind-key "C-c S" 'ssh-login-from-config)

(defun my-dired-file-split-layout ()
  "Split window: left 1/3 Dired (current dir), right 2/3 current file."
  (interactive)
  (let ((current-file buffer-file-name)
        (current-buffer (current-buffer))
        (current-dir (if buffer-file-name
                         (file-name-directory buffer-file-name)
                       default-directory))
        (total-width (window-width)))
    ;; Start fresh
    (delete-other-windows)
    ;; Create left window at exactly 1/3 width
    (let ((left-win (split-window (selected-window) 
                                  (floor (* total-width 0.66)) 
                                  'left)))
      ;; Left window: Dired
      (select-window left-win)
      (dired current-dir)
      ;; Right window: original file
      (let ((right-win (next-window)))
        (select-window right-win)
        (when current-file
          (switch-to-buffer current-buffer))))))


(defun my-toggle-split-layout ()
  "Toggle between split layout and single window."
  (interactive)
  (if (= (count-windows) 1)
      (my-dired-file-split-layout)
    (delete-other-windows)))

(bind-key "C-c 3" #'my-toggle-split-layout)


(defun next-file-by-extension ()
  "Go to next file with same extension in current directory."
  (interactive)
  (let* ((current-file (buffer-file-name))
         (ext (when current-file (file-name-extension current-file)))
         (dir (when current-file (file-name-directory current-file)))
         (files (when dir
                  (sort (directory-files dir nil (concat "\\." ext "$") t)
                        #'string<)))
         (next (when files
                 (cadr (member (file-name-nondirectory current-file) files)))))
    (cond
     ((not current-file) (message "Not visiting a file"))
     ((not ext) (message "Current file has no extension"))
     ((not next) (message "No next .%s file" ext))
     (t (find-file (expand-file-name next dir))))))

;; ;; Bind to C-c C-c <down>
;; (with-eval-after-load 'markdown-mode
;;   (define-key markdown-mode-map (kbd "C-c C-c <down>") #'next-file-by-extension))

(defun prev-file-by-extension ()
  "Go to previous file with same extension in current directory."
  (interactive)
  (let* ((current-file (buffer-file-name))
         (ext (when current-file (file-name-extension current-file)))
         (dir (when current-file (file-name-directory current-file)))
         (files (when dir
                  (sort (directory-files dir nil (concat "\\." ext "$") t)
                        #'string<)))
         (prev (when files
                 (let ((pos (cl-position (file-name-nondirectory current-file)
                                         files :test #'string=)))
                   (when (and pos (> pos 0))
                     (nth (1- pos) files))))))
    (cond
     ((not current-file) (message "Not visiting a file"))
     ((not ext) (message "Current file has no extension"))
     ((not prev) (message "No previous .%s file" ext))
     (t (find-file (expand-file-name prev dir))))))

(use-package markdown-mode
  :ensure t
  :mode (("\\.md\\'" . markdown-mode)
         ("\\.markdown\\'" . markdown-mode))
  :bind (:map markdown-mode-map
              ("C-c C-c <down>" . next-file-by-extension)
              ("C-c C-c <up>" . prev-file-by-extension))
  :config
  (setq markdown-command "pandoc -f markdown -t html5 -s --mathjax --highlight-style=tango")
  (setq markdown-fontify-code-blocks-natively t)

  (defun my/adjust-markdown-faces-for-theme (&rest _)
    "Adjust markdown code block background based on active theme."
    (if (member 'spacemacs-light custom-enabled-themes)
        (progn
          (set-face-attribute 'markdown-code-face nil :background "#f2f2f2")
          (set-face-attribute 'markdown-pre-face nil :background "#f2f2f2"))
      (when (facep 'markdown-code-face)
        (set-face-attribute 'markdown-code-face nil :background 'unspecified)
        (set-face-attribute 'markdown-pre-face nil :background 'unspecified))))

  (advice-add 'load-theme :after #'my/adjust-markdown-faces-for-theme)
  (my/adjust-markdown-faces-for-theme))


(defun display-current-dir ()
  "Display the directory of the current buffer's file in the minibuffer."
  (interactive)
  (if buffer-file-name
      (message "%s" (file-name-directory buffer-file-name))
    (message "%s" default-directory)))

(global-auto-revert-mode t)
(setq auto-revert-verbose nil)
(setq auto-revert-interval 1)            ; Check every second (default is 5)
(setq revert-without-query '(".*"))      ; Never ask, just reload

(load-file (let ((coding-system-for-read 'utf-8))
                (shell-command-to-string "agda --emacs-mode locate")))




(put 'downcase-region 'disabled nil)


(defun my-show-init-bindings ()
  "Show personal key bindings via bind-key."
  (interactive)
  (describe-personal-keybindings))


;; (use-package grip-mode
;;   :bind (:map markdown-mode-command-map
;;          ("g" . grip-mode)))

(use-package valign
  :ensure t
  :hook (markdown-mode . valign-mode))

(defun clear-local-mark-ring ()
  (interactive)
  (setq mark-ring nil)
  (message "Local mark ring cleared"))

(defun clear-global-mark-ring ()
  (interactive)
  (setq global-mark-ring nil)
  (message "Global mark ring cleared"))

(bind-key "C-c M-l" #'clear-local-mark-ring)
(bind-key "C-c M-g" #'clear-global-mark-ring)


;; ── Color Ring with Resource Reclamation ─────────────────

(defface le-hi-1  '((t (:background "#ffcccc"))) "Highlight face 1")
(defface le-hi-2  '((t (:background "#ccffcc"))) "Highlight face 2")
(defface le-hi-3  '((t (:background "#ccccff"))) "Highlight face 3")
(defface le-hi-4  '((t (:background "#ffffcc"))) "Highlight face 4")
(defface le-hi-5  '((t (:background "#ffccff"))) "Highlight face 5")
(defface le-hi-6  '((t (:background "#ccffff"))) "Highlight face 6")
(defface le-hi-7  '((t (:background "#ffe5cc"))) "Highlight face 7")
(defface le-hi-8  '((t (:background "#e5ccff"))) "Highlight face 8")
(defface le-hi-9  '((t (:background "#ccffe5"))) "Highlight face 9")
(defface le-hi-10 '((t (:background "#ffccd9"))) "Highlight face 10")
(defface le-hi-11 '((t (:background "#cce5ff"))) "Highlight face 11")
(defface le-hi-12 '((t (:background "#e5ffcc"))) "Highlight face 12")

(defvar le/hi-lock-faces
  '(le-hi-1 le-hi-2 le-hi-3 le-hi-4 le-hi-5 le-hi-6
    le-hi-7 le-hi-8 le-hi-9 le-hi-10 le-hi-11 le-hi-12)
  "Available faces in the ring, in order.")

(defun my/set-highlight-colors-for-theme (&rest _)
  "Set highlight face backgrounds based on the active theme."
  (let ((light-colors
         '("#ffcccc" "#ccffcc" "#ccccff" "#ffffcc" "#ffccff" "#ccffff"
           "#ffe5cc" "#e5ccff" "#ccffe5" "#ffccd9" "#cce5ff" "#e5ffcc"))
        (dark-colors
         '("#e06c75" "#98c379" "#61afef" "#e5c07b" "#c678dd" "#56b6c2"
           "#d19a66" "#a9a1e1" "#7bc275" "#ff6b9d" "#5cEfff" "#b9f27c")))
    (dotimes (i 12)
      (let* ((face (intern (format "le-hi-%d" (1+ i))))
             (color (if (member 'doom-ayu-dark custom-enabled-themes)
                        (nth i dark-colors)
                      (nth i light-colors))))
        ;; Use face-spec-set so colors survive face-spec-recalc on theme changes.
        (face-spec-set face `((t (:background ,color))))))))

(defun my/set-syntax-highlight-faces-for-theme (&rest _)
  "Set syntax-highlight face weights/colors after theme changes."
  ;; Function definitions, keywords, and types: keep theme color, but never bold.
  (set-face-attribute 'font-lock-function-name-face nil :weight 'normal)
  (set-face-attribute 'font-lock-keyword-face nil :weight 'normal)
  (set-face-attribute 'font-lock-type-face nil :weight 'normal)
  (let ((is-dark (member 'doom-ayu-dark custom-enabled-themes)))
    (if is-dark
        (progn
          (face-spec-set 'font-lock-function-call-face
                         '((t (:foreground "#61afef" :weight normal))))
          (face-spec-set 'font-lock-number-face
                         '((t (:foreground "#d19a66" :weight normal)))))
      (progn
        (face-spec-set 'font-lock-function-call-face
                       '((t (:foreground "#0066cc" :weight normal))))
        (face-spec-set 'font-lock-number-face
                       '((t (:foreground "#b35900" :weight normal))))))))

(advice-add 'load-theme :after #'my/set-highlight-colors-for-theme)
(advice-add 'load-theme :after #'my/set-syntax-highlight-faces-for-theme)
(my/set-highlight-colors-for-theme)
(my/set-syntax-highlight-faces-for-theme)

(defvar le/face-ring-allocated nil
  "List of plists (:face FACE :symbol SYMBOL :regexp REGEXP) tracking in-use colors.")
(make-variable-buffer-local 'le/face-ring-allocated)

(defvar le/face-ring-next-idx 0
  "Next index to try in the ring (circular).")
(make-variable-buffer-local 'le/face-ring-next-idx)

(defun le/symbol-at-point ()
  "Return the symbol at point as a string, or nil."
  (let ((bounds (bounds-of-thing-at-point 'symbol)))
    (when bounds
      (buffer-substring-no-properties (car bounds) (cdr bounds)))))

(defun le/find-entry-by-symbol (sym)
  "Find entry in le/face-ring-allocated where :symbol equals SYM."
  (cl-find-if (lambda (entry) (equal (plist-get entry :symbol) sym))
              le/face-ring-allocated))

(defun le/allocate-face ()
  "Find next available face in ring. Return face or error if full."
  (let ((n (length le/hi-lock-faces))
        (start le/face-ring-next-idx)
        (idx le/face-ring-next-idx)
        found)
    (while (and (not found) (< (- idx start) n))
      (let ((face (nth (mod idx n) le/hi-lock-faces)))
        (unless (cl-find-if (lambda (e) (eq (plist-get e :face) face))
                            le/face-ring-allocated)
          (setq found face)))
      (setq idx (1+ idx)))
    (unless found
      (user-error "Color ring full (%d/%d). Unhighlight something first."
                  (length le/face-ring-allocated) n))
    (setq le/face-ring-next-idx (mod idx n))
    found))

(defun le/release-face (face)
  "Release FACE back to ring. Update next-idx to prefer this slot."
  (setq le/face-ring-allocated
        (cl-remove-if (lambda (e) (eq (plist-get e :face) face))
                      le/face-ring-allocated))
  (let ((idx (cl-position face le/hi-lock-faces)))
    (when idx
      (setq le/face-ring-next-idx idx)))
  face)

(defun le/persistent-highlight-symbol ()
  "Highlight symbol at point using next available color from ring."
  (interactive)
  (let ((sym (le/symbol-at-point)))
    (unless sym
      (user-error "No symbol at point"))
    (when (le/find-entry-by-symbol sym)
      (user-error "Already persistently highlighted: %s" sym))
    (let* ((face (le/allocate-face))
           (stored-regexp (highlight-regexp (concat "\\<" (regexp-quote sym) "\\>") face)))
      (unless stored-regexp
        (setq stored-regexp (concat "\\<" (regexp-quote sym) "\\>")))
      (push (list :face face :symbol sym :regexp stored-regexp) le/face-ring-allocated)
      (message "Persistently highlighted: %s (%s)" sym face))))

(defun le/persistent-unhighlight-symbol ()
  "Remove highlight and reclaim its color."
  (interactive)
  (let ((sym (le/symbol-at-point))
        entry)
    (cond
     ;; Symbol at point is highlighted
     ((and sym (setq entry (le/find-entry-by-symbol sym)))
      (setq sym (plist-get entry :symbol)))
     ;; Prompt from active list
     (le/face-ring-allocated
      (setq sym (completing-read "Unhighlight symbol: "
                                 (mapcar (lambda (e) (plist-get e :symbol))
                                         le/face-ring-allocated)
                                 nil t))
      (setq entry (le/find-entry-by-symbol sym)))
     (t
      (user-error "No persistent highlights in this buffer")))
    ;; Unhighlight using stored regexp, release face
    (let ((face (plist-get entry :face))
          (regexp (plist-get entry :regexp)))
      (unhighlight-regexp regexp)
      (le/release-face face)
      (message "Removed persistent highlight: %s (reclaimed %s)" sym face))))

(defun le/clear-all-persistent-highlights ()
  "Remove all highlights, fully reset ring."
  (interactive)
  (dolist (entry le/face-ring-allocated)
    (cond
     ((plist-get entry :regexp)
      (ignore-errors (unhighlight-regexp (plist-get entry :regexp))))
     ((plist-get entry :overlay)
      (ignore-errors (delete-overlay (plist-get entry :overlay))))))
  (setq le/face-ring-allocated nil)
  (setq le/face-ring-next-idx 0)
  (message "All persistent highlights cleared, ring reset"))

(defun le/toggle-persistent-highlight ()
  "Toggle persistent highlight for symbol at point.
Highlight if not already highlighted; unhighlight if it is."
  (interactive)
  (let ((sym (le/symbol-at-point)))
    (unless sym
      (user-error "No symbol at point"))
    (let ((entry (le/find-entry-by-symbol sym)))
      (if entry
          ;; Already highlighted → unhighlight
          (let ((face (plist-get entry :face))
                (regexp (plist-get entry :regexp)))
            (unhighlight-regexp regexp)
            (le/release-face face)
            (message "Removed persistent highlight: %s (reclaimed %s)" sym face))
        ;; Not highlighted → highlight
        (let* ((face (le/allocate-face))
               (stored-regexp (highlight-regexp (concat "\\<" (regexp-quote sym) "\\>") face)))
          (unless stored-regexp
            (setq stored-regexp (concat "\\<" (regexp-quote sym) "\\>")))
          (push (list :face face :symbol sym :regexp stored-regexp) le/face-ring-allocated)
          (message "Persistently highlighted: %s (%s)" sym face))))))

(defun le/toggle-region-highlight ()
  "Toggle persistent highlight for the active region or region at point."
  (interactive)
  (cond
   ;; Case 1: Active region
   ((use-region-p)
    (let ((existing (cl-find-if
                     (lambda (entry)
                       (let ((ov (plist-get entry :overlay)))
                         (and ov
                              (= (overlay-start ov) (region-beginning))
                              (= (overlay-end ov) (region-end)))))
                     le/face-ring-allocated)))
      (if existing
          ;; Exact match → unhighlight
          (progn
            (delete-overlay (plist-get existing :overlay))
            (le/release-face (plist-get existing :face))
            (setq le/face-ring-allocated (remove existing le/face-ring-allocated))
            (message "Region highlight removed"))
        ;; New region → highlight
        (let* ((face (le/allocate-face))
               (ov (make-overlay (region-beginning) (region-end))))
          (overlay-put ov 'face face)
          (overlay-put ov 'le-region-highlight t)
          (push (list :face face :overlay ov) le/face-ring-allocated)
          (message "Region highlighted with %s" face)))))
   ;; Case 2: No region, point inside existing region highlight
   (t
    (let ((existing (cl-find-if
                     (lambda (entry)
                       (let ((ov (plist-get entry :overlay)))
                         (and ov
                              (>= (point) (overlay-start ov))
                              (<= (point) (overlay-end ov)))))
                     le/face-ring-allocated)))
      (if existing
          (progn
            (delete-overlay (plist-get existing :overlay))
            (le/release-face (plist-get existing :face))
            (setq le/face-ring-allocated (remove existing le/face-ring-allocated))
            (message "Region highlight removed"))
        (user-error "No region active and no highlighted region at point"))))))

;; ── Keybindings ─────────────────────────────────────────
(bind-key "C-c h" #'le/toggle-persistent-highlight)
(bind-key "C-c l" #'le/toggle-region-highlight)
(bind-key "C-c M-h" #'le/clear-all-persistent-highlights)

(defvar my/swiper-all-window nil
  "Window created by `my/toggle-swiper-all-right'.")

(defun my/toggle-swiper-all-right ()
  "Toggle a right-hand window running `swiper-all'.
First call: split right, switch there, launch `swiper-all'.
Second call: delete that window."
  (interactive)
  (if (and my/swiper-all-window (window-live-p my/swiper-all-window))
      (progn
        (delete-window my/swiper-all-window)
        (setq my/swiper-all-window nil))
    (setq my/swiper-all-window nil)
    (split-window-right)
    (other-window 1)
    (setq my/swiper-all-window (selected-window))
    (call-interactively #'swiper-all)))

(bind-key "C-c s" #'my/toggle-swiper-all-right)

(defvar my/counsel-rg-window nil
  "Window created by `my/toggle-counsel-rg-right'.")

(defun my/toggle-counsel-rg-right ()
  "Toggle a right-hand window running `counsel-rg'.
First call: split right, switch there, launch `counsel-rg' in `default-directory'.
Second call: delete that window."
  (interactive)
  (if (and my/counsel-rg-window (window-live-p my/counsel-rg-window))
      (progn
        (delete-window my/counsel-rg-window)
        (setq my/counsel-rg-window nil))
    (setq my/counsel-rg-window nil)
    (split-window-right)
    (other-window 1)
    (setq my/counsel-rg-window (selected-window))
    (call-interactively #'counsel-rg)))

(bind-key "C-c C-s" #'my/toggle-counsel-rg-right)

(global-hi-lock-mode 1)

(defun my-dired-search-to-buffer ()
  "Search files in current Dired directory and show results in a temp buffer.
Uses ripgrep if available, falls back to grep. Shows relative paths and highlights matches."
  (interactive)
  (let* ((dir (dired-current-directory))
         (default-directory dir)
         (prompt (format "Search in %s: " (abbreviate-file-name dir)))
         (pattern (read-string prompt))
         (buf (get-buffer-create "*Dired Search Results*"))
         (pattern-re (regexp-quote pattern)))
    (when (string-empty-p pattern)
      (user-error "Empty search pattern"))
    (with-current-buffer buf
      (setq buffer-read-only nil)
      (erase-buffer)
      (insert (propertize (format "Search: %s\nDirectory: %s\n%s\n\n"
                                  pattern (abbreviate-file-name dir)
                                  (make-string 50 ?-))
                          'face 'bold))
      (let ((cmd (if (executable-find "rg")
                     (format "rg -nH --color=never --sort path -e %s"
                             (shell-quote-argument pattern))
                   (format "grep -rnH -I -e %s"
                           (shell-quote-argument pattern)))))
        (call-process-shell-command cmd nil t))
      ;; Setup compilation-mode for clickable links first
      (compilation-mode)
      (setq-local compilation-error-regexp-alist
                  '(("^\\([^:\n]+\\):\\([0-9]+\\):" 1 2)))
      ;; Add persistent keyword highlighting for the search pattern
      (font-lock-add-keywords nil `((,pattern-re 0 'hi-yellow prepend)) 'append)
      (font-lock-flush)
      (font-lock-ensure))
    (pop-to-buffer buf)
    (goto-char (point-min))
    (forward-line 4)))

(use-package dired
  :bind (:map dired-mode-map
              ("C-c s" . my-dired-search-to-buffer)))


(defvar my-toggle-themes '(doom-ayu-dark spacemacs-light doom-one-light)
  "List of themes to rotate through.")

(defun my-toggle-theme ()
  "Cycle to the next theme in `my-toggle-themes'."
  (interactive)
  (let* ((current (car custom-enabled-themes))
         (current-idx (cl-position current my-toggle-themes))
         (next-idx (mod (1+ (or current-idx -1)) (length my-toggle-themes)))
         (next (nth next-idx my-toggle-themes)))
    (mapc #'disable-theme custom-enabled-themes)
    (load-theme next t)
    (message "Switched to %s" next)))

;; Bind to a convenient key, e.g., C-c t
(bind-key "C-x t" #'my-toggle-theme)

(add-to-list 'load-path (expand-file-name "~/lang/elisp/emacs-tramp-rpc/lisp"))
(use-package tramp-rpc
  :ensure nil
  :after tramp)

(defun copy-file-path-to-clipboard ()
  "Copy the absolute path of the current buffer's file to the system clipboard."
  (interactive)
  (if-let ((path (buffer-file-name)))
      (progn
        (kill-new path)
        (message "Copied: %s" path))
    (message "No file associated with this buffer")))

;; Bind to C-c p
(bind-key "C-c p" #'copy-file-path-to-clipboard)

(defun ivy-jump-to-project-doc ()
  "Find project root via .git, then jump to README.md, CHANGELOG.md, .gitignore, or project.cabal with ivy."
  (interactive)
  (let* ((root (locate-dominating-file default-directory ".git"))
         (files (when root
                  (directory-files root t "^\\(\\(README\\|CHANGELOG\\)\\.md\\|\\.gitignore\\|project\\.cabal\\)$"))))
    (if (not root)
        (message "No .git found")
      (if (null files)
          (message "No project files in %s" root)
        (ivy-read "Project file: "
                  (mapcar (lambda (f) (cons (file-name-nondirectory f) f)) files)
                  :action (lambda (x) (find-file (cdr x)))
                  :caller 'ivy-jump-to-project-doc)))))

;; Bind it
(bind-key "C-c d" #'ivy-jump-to-project-doc)

(defvar my-help-messages-alist
  '(("pip ustc" . "-i https://mirrors.ustc.edu.cn/pypi/simple")
    ("Git force push" . "git push --force-with-lease")
    ("Docker prune" . "docker system prune -a")
    ("Python venv" . "python -m venv .venv && source .venv/bin/activate")
    ("CMake build" . "cmake -B build -S . && cmake --build build"))
  "Alist of (LABEL . COMMAND) for quick help lookup.")

(defun ivy-copy-help-message ()
  "Select a help message from `my-help-messages-alist' via ivy and copy to clipboard."
  (interactive)
  (ivy-read "Help: "
            my-help-messages-alist
            :action (lambda (x)
                      (let ((msg (cdr x)))
                        (kill-new msg)
                        (message "Copied: %s" msg)))
            :caller 'ivy-copy-help-message))

;; Bind it
(bind-key "C-c C-x h" #'ivy-copy-help-message)

(bind-key "C-c k" #'describe-personal-keybindings)

(use-package vterm
  :ensure nil
  :load-path "~/lang/elisp/emacs-libvterm"
  :commands (vterm my/vterm-toggle)
  :config
  (add-hook 'vterm-exit-functions
            (lambda (buffer)
              (when (string= (buffer-name buffer) my/vterm-toggle-buffer-name)
                (kill-buffer buffer)))))

(defvar my/vterm-toggle-buffer-name "*vterm-toggle*"
  "Name of the dedicated toggle vterm buffer.")

(defun my/vterm-toggle ()
  "Toggle a dedicated vterm buffer in a bottom window."
  (interactive)
  (let ((buffer (get-buffer my/vterm-toggle-buffer-name))
        (window (get-buffer-window my/vterm-toggle-buffer-name)))
    (cond
     ;; Visible: hide it
     (window
      (delete-window window))
     ;; Hidden but exists: show in bottom split
     (buffer
      (let ((win (split-window-below -15)))
        (select-window win)
        (switch-to-buffer buffer)))
     ;; Doesn't exist: create
     (t
      (let ((win (split-window-below -15)))
        (select-window win)
        (vterm my/vterm-toggle-buffer-name))))))

(use-package tramp-proxy
  :ensure nil
  :load-path "~/lang/elisp/emacs-tramp-tunnel")

(let ((proxy-file (expand-file-name "~/.server-proxy")))
  (when (file-exists-p proxy-file)
    (setq tramp-proxy-host
          (string-trim
           (with-temp-buffer
             (insert-file-contents proxy-file)
             (buffer-string))))))

(use-package eat
  :ensure t
  :commands (eat my/eat-local)
  :config
  (define-key eat-semi-char-mode-map (kbd "C-c C-e") #'eat-emacs-mode)
  (define-key eat-mode-map (kbd "C-c C-e") #'eat-semi-char-mode)
  (advice-add 'eat :around #'my-tramp-rpc-local-terminal-advice))

;; ── Chinese input method ─────────────────────────────────
(use-package rime
  :ensure t
  :init
  (setq default-input-method "rime")
  :custom
  (rime-show-candidate 'popup)
  (rime-inline-ascii t)
  (rime-inline-ascii-trigger 'shift-l)
  (rime-default-schema-id "luna_pinyin_simp")
  :config
  ;; Prevent rime from stalling when system librime is missing
  (unless (file-exists-p (expand-file-name "librime-emacs.so"
                                            (file-name-directory (locate-library "rime"))))
    (message "WARNING: rime module not built. Run M-x rime-compile-module after installing librime-dev.")))

(defvar my-tramp-rpc-local-terminals t
  "When non-nil, open terminal emulators locally even in TRAMP-RPC buffers.")

(defun my-tramp-rpc-local-terminal-advice (orig-fun &rest args)
  "Run terminal emulator with local `default-directory'."
  (if (and my-tramp-rpc-local-terminals
           (boundp 'tramp-rpc-method)
           (file-remote-p default-directory)
           (string-prefix-p "/rpc:" (expand-file-name default-directory)))
      (let ((default-directory (expand-file-name "~")))
        (apply orig-fun args))
    (apply orig-fun args)))


(defun my/tramp-rpc-copy-to-local ()
  "Copy the current remote file to a local path selected via ivy."
  (interactive)
  (unless buffer-file-name
    (user-error "Not visiting a file"))
  (unless (file-remote-p buffer-file-name)
    (user-error "Not a remote file"))
  (let* ((remote-file buffer-file-name)
         (filename (file-name-nondirectory remote-file))
         (default-dest (expand-file-name filename "~"))
         (local-dest (read-file-name "Local destination: " "~" default-dest nil filename)))
    (copy-file remote-file local-dest t)  ; t = overwrite
    (message "Copied → %s" local-dest)))

(bind-key "C-c c" #'my/tramp-rpc-copy-to-local)

(defun my/eat-local ()
  "Open eat in local directory, ignoring TRAMP default-directory."
  (interactive)
  (let ((default-directory (expand-file-name "~")))
    (eat)))

(use-package dired-sidebar
  :ensure t
  :bind ("C-]" . dired-sidebar-toggle-sidebar))

(use-package imenu-list
  :bind ("C-c i" . imenu-list-smart-toggle)
  :custom (imenu-list-focus-after-entry t))
