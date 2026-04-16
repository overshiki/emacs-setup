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
 '(package-selected-packages
   '(auto-highlight-symbol cape clipmon cmake-mode company corfu counsel
                           diredfl doom-themes elixir-mode
                           futhark-mode git-gutter go-mode
                           gruber-darker-theme haskell-mode
                           highlight-indent-guides
                           highlight-parentheses jedi julia-mode
                           lsp-haskell markdown-preview-mode
                           math-preview mathjax matlab-mode
                           merlin-eldoc multiple-cursors ninja-mode
                           racket-mode rust-mode scala-mode shrface
                           space-theming spacemacs-theme swiper-helm
                           term-toggle transpose-frame tuareg w3m
                           wgrep-ag)))
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
(define-key global-map (kbd "C-x C-g") 'beginning-of-buffer)
(define-key global-map (kbd "C-x g") 'beginning-of-buffer)

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
(global-set-key (kbd "C-x C-<up>") #'dired-jump-to-current-dir)
(global-set-key (kbd "C-x C-<down>") #'jump-back-from-dired)

(global-set-key (kbd "C-x <up>") #'dired-jump-to-current-dir)
(global-set-key (kbd "C-x <down>") #'jump-back-from-dired)

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
(global-set-key (kbd "C-c t") 'copy-token-to-clipboard)

(require 'json)

(defun ssh-login-from-config ()
  "Read ~/.server JSON (user, ip), prompt for password, login via TRAMP."
  (interactive)
  (let* ((config-file (expand-file-name "~/.server"))
         (json-data (json-read-file config-file))
         (user (cdr (assoc 'user json-data)))
         (ip (cdr (assoc 'ip json-data)))
         (passwd (read-passwd (format "Password for %s@%s: " user ip))))
    (when (or (null user) (null ip))
      (error "Missing 'user' or 'ip' in ~/.server"))
    ;; Temporarily cache password for this TRAMP session
    (let ((auth-source-creation-prompts
           `((user . ,user) (host . ,ip) (secret . ,passwd))))
      (auth-source-remember '(:host ,ip :user ,user :protocol "ssh")
                            `((secret . ,passwd))))
    (find-file (format "/ssh:%s@%s:~/" user ip))
    (message "Connecting to %s@%s..." user ip)))

;; Bind to C-c S
(global-set-key (kbd "C-c S") 'ssh-login-from-config)

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

;; Bind to C-c 3
(global-set-key (kbd "C-c 3") #'my-dired-file-split-layout)

(defun my-toggle-split-layout ()
  "Toggle between split layout and single window."
  (interactive)
  (if (= (count-windows) 1)
      (my-dired-file-split-layout)
    (delete-other-windows)))

(global-set-key (kbd "C-c 3") #'my-toggle-split-layout)


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

;; Bindings
(with-eval-after-load 'markdown-mode
  (define-key markdown-mode-map (kbd "C-c C-c <down>") #'next-file-by-extension)
  (define-key markdown-mode-map (kbd "C-c C-c <up>") #'prev-file-by-extension))

;; ========== markdown-preview-mode Configuration ==========
;; ============================================
;; Configuration
;; ============================================

;; Auto-mode for .md files
(add-to-list 'auto-mode-alist '("\\.md\\'" . markdown-mode))
(add-to-list 'auto-mode-alist '("\\.markdown\\'" . markdown-mode))


(setq markdown-preview--preview-template
      (expand-file-name "~/.emacs.d/markdown-preview-mode/preview.html"))

(defun my-markdown-preview-eww-full ()
  "Render markdown to HTML and open in EWW full window."
  (interactive)
  (let* ((md-buffer (current-buffer))
         (md-file (or buffer-file-name
                      (make-temp-file "markdown-preview" nil ".md")))
         (html-file (concat (file-name-sans-extension md-file) ".html"))
         (template markdown-preview--preview-template)
         (raw-content (buffer-substring-no-properties (point-min) (point-max))))
    
    ;; Save temp file if buffer not visiting file
    (unless buffer-file-name
      (with-temp-file md-file
        (insert raw-content)))
    
    ;; Generate HTML with embedded markdown
    (with-temp-file html-file
      (when (file-exists-p template)
        (insert-file-contents template))
      ;; Replace placeholder or insert script call
      (goto-char (point-min))
      (let ((base64-md (base64-encode-string 
                        (encode-coding-string raw-content 'utf-8) t)))
        (if (search-forward "<div id=\"content\">" nil t)
            (replace-match (format "<div id=\"content\" data-markdown=\"%s\">" base64-md))
          ;; Fallback
          (goto-char (point-max))
          (insert (format "\n<script>renderMarkdown('%s');</script>" base64-md)))))
    
    ;; Open in EWW
    (eww-open-file html-file)
    (delete-other-windows)))


;; (load "~/.emacs.d/modern-eww-style.el")
;; ;; Basic usage
;; (require 'modern-eww-style)
;; (modern-eww-style-enable)

;; ;; With shrface integration (RECOMMENDED)
;; (require 'shrface)              ; Install from MELPA first
;; (require 'modern-eww-style)
;; (modern-eww-style-enable)
;; (modern-eww-style-shrface-enable)   ; Enable enhanced tables


;; (load "~/.emacs.d/modern-w3m-style.el")
;; (require 'modern-w3m-style)
;; ;; Enable for all w3m buffers
;; (modern-w3m-style-global-mode 1)
;; ;; Or use presets
;; (modern-w3m-style-github-preset)

;; ;; Configure markdown-mode to use w3m for live preview
;; (defun markdown-live-preview-window-w3m (file)
;;   "Preview FILE with w3m.
;; To be used with `markdown-live-preview-window-function'."
;;   (if (require 'w3m nil t)
;;       (progn
;;         (w3m (concat "file://" file))
;;         (get-buffer "*w3m*"))
;;     (error "w3m is not present or not loaded on this version of Emacs")))

;; ;; Set the preview function to use w3m
;; (setq markdown-live-preview-window-function #'markdown-live-preview-window-w3m
;; )

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
  "Show active key bindings from init file, skipping commented lines."
  (interactive)
  (with-current-buffer (find-file-noselect user-init-file)
    (goto-char (point-min))
    (with-output-to-temp-buffer "*My Key Bindings*"
      (princ "Active Key Bindings:\n\n")
      (while (re-search-forward "^(\\s-*\\(global-set-key\\|define-key\\)" nil t)
        ;; Check if line is commented (semicolon before open paren)
        (unless (save-excursion
                  (beginning-of-line)
                  (looking-at ".*;.*("))
          (let ((line (thing-at-point 'line t)))
            (princ line)))))))
