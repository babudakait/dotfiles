;; --------------------------------------------------------------------------------
;; PACKAGE-SYSTEN INITIALIZATION
;; --------------------------------------------------------------------------------
(require 'package)
(setq package-archives '(("melpa" . "https://melpa.org/packages/")
                         ("gnu" . "https://elpa.gnu.org/packages/")))
(package-initialize)
(unless package-archive-contents (package-refresh-contents))
(unless (package-installed-p 'use-package)
  (package-install 'use-package))
(require 'use-package)
(setq use-package-always-ensure t)  ;; auto-install packages


;; --------------------------------------------------------------------------------
;; BASIC SETUP
;; --------------------------------------------------------------------------------
;; UI Settings
(setq inhibit-startup-message t)
(menu-bar-mode -1)
(tool-bar-mode -1)
(scroll-bar-mode -1)
(setq ring-bell-function 'ignore)

;; Line Numbers
(global-display-line-numbers-mode t)
(setq display-line-numbers-type 'relative)

;; Disable Line Numbers for certain modes
(dolist (mode '(org-mode-hook
		vterm-mode-hook
		pdf-view-mode-hook))
  (add-hook mode (lambda () (display-line-numbers-mode -1))))

;; Other Useful settings
(require 'ido)
(ido-mode 1)
(ido-everywhere 1)
(show-paren-mode 1)
(save-place-mode 1)          ;; Remember cursor positions in files
(global-auto-revert-mode 1)  ;; if file changes on disk reload its buffer

;; Never let point get closer than 10 lines to top/bottom of window
(setq scroll-margin 10)
(setq scroll-conservatively 101)   ;; smooth scrolling, no recentering
(setq scroll-step 1)               ;; scroll by 1 line when needed

;; Handle temporary files
(setq auto-save-default nil)   ;; Disable auto-saving
(setq make-backup-files nil)   ;; Disable backup~ files
(setq create-lockfiles nil)    ;; Disable .#lock files

;; Something Performace Wise via ChatGPT
(setq gc-cons-threshold (* 50 1000 1000))
(add-hook 'emacs-startup-hook (lambda () (setq gc-cons-threshold (* 2 1000 1000))))

;; Set Font
(set-face-attribute 'default nil :font "Iosevka Light" :height 110)


;; --------------------------------------------------------------------------------
;; ORG-MODE SETUP
;; --------------------------------------------------------------------------------
(setq org-hide-emphasis-markers t)
(setq org-startup-folded 'overview)
(setq org-confirm-babel-evaluate nil)

(setq org-src-window-setup 'current-window)
(setq org-src-preserve-indentation t)
(setq org-edit-src-content-indentation 0)
(setq org-ellipsis " ▼ ")

(setq org-indent-indentation-per-level 3)
(add-hook 'org-mode-hook 'org-indent-mode)

(use-package org-modern
  :hook (org-mode . org-modern-mode)
  :custom
  ;; Headings & Lists
  (org-modern-star '("◉" "○" "◆" "◇" "▶" "▷"))
  (org-modern-list '((?- . "•") (?+ . "‣") (?* . "⁃")))
  ;; Checkboxes
  (org-modern-checkbox
   '((?X . "🟩") (?- . "▢") (?\s . "⬜")))
  ;; Tables & blocks
  (org-modern-table-vertical 1)
  (org-modern-table-horizontal 1)
  (org-modern-block-fringe 4)
  (org-modern-block-name t)
  (org-modern-block-border t)
  ;; Tags & todo keywords
  (org-modern-todo t)
  (org-modern-tag t))

(dolist (face '(org-level-1 org-level-2 org-level-3 org-level-4
                org-level-5 org-level-6 org-level-7 org-level-8))
  (set-face-attribute face nil :weight 'bold :height 1.3))

(use-package visual-fill-column
  :ensure t)

(defun my/org-visual-setup ()
  (setf visual-fill-column-width 110
	visual-fill-column-center-text t)
  (visual-fill-column-mode 1)
  (visual-line-mode 1))

(add-hook 'org-mode-hook 'my/org-visual-setup)

(require 'org-tempo)
(setq org-structure-template-alist
      '(("c"      . "src c")
        ("cpp"    . "src cpp")
        ("py"     . "src python")
        ("sh"     . "src shell")
	("awk"    . "src awk")
        ("js"     . "src js")
        ("el"     . "src emacs-lisp")
	("lisp"   . "src lisp")))

(with-eval-after-load 'org
  (add-to-list 'org-file-apps '("\\.png\\'" . "feh %s"))
  (add-to-list 'org-file-apps '("\\.jpg\\'" . "feh %s"))
  (add-to-list 'org-file-apps '("\\.jpeg\\'" . "feh %s"))
  (add-to-list 'org-file-apps '("\\.gif\\'" . "feh %s"))
  (add-to-list 'org-file-apps '("\\.webp\\'" . "feh %s"))
  (add-to-list 'org-file-apps '("\\.svg\\'" . "feh %s"))
  (add-to-list 'org-file-apps '("\\.mp4\\'" . "mpv %s")))


;; --------------------------------------------------------------------------------
;; HELPER FUNCTIONS
;; --------------------------------------------------------------------------------

;; --------------------------------------------------------------------------------
;; PDF-TOOLS PACKAGE
;; --------------------------------------------------------------------------------
(use-package pdf-tools
  :config
  (pdf-tools-install))


;; --------------------------------------------------------------------------------
;; THEME SETUP
;; --------------------------------------------------------------------------------
(use-package cyberpunk-theme)
(use-package doom-themes)

(defvar *my-themes*
  '(cyberpunk
    doom-material-dark
    doom-1337
    doom-acario-dark
    doom-ir-black))

(defvar *my-theme-index* 0)
(defvar *my-theme-state-file* "~/.emacs.d/theme-state.el")


(defun my/load-theme (index)
  "disable current themes and load theme at position index"
  (let* ((len   (length *my-themes*))
	 (idx   (mod index len))
	 (theme (nth idx *my-themes*)))
    (mapc #'disable-theme custom-enabled-themes)
    (load-theme theme t)
    (setq *my-theme-index* idx)
    (message "Theme loaded: %S" theme)))

(defun my/cycle-themes ()
  "cycle through themes defined in *my-theme*"
  (interactive)
  (my/load-theme (1+ *my-theme-index*)))

;; Keybinding
(global-set-key (kbd "<f5>") #'my/cycle-themes)

;; save theme on exit
(add-hook 'kill-emacs-hook
	  (lambda ()
	    (with-temp-file *my-theme-state-file*
	      (insert (format "(setq *my-theme-index* %d)" *my-theme-index*)))))

;; load theme at startup
(when (file-exists-p *my-theme-state-file*)
  (message "loading...")
  (load-file *my-theme-state-file*))

(my/load-theme *my-theme-index*)

;; --------------------------------------------------------------------------------
;; VTERM SETUP
;; --------------------------------------------------------------------------------
(use-package vterm
  :ensure t
  :commands vterm
  :config
  (setf vterm-shell "/bin/bash"))

(defvar *my-vterm-below* t)

(defun my/vterm-visible-p ()
  "checks if terminal buffer is displayed in a window. window or nil"
  (get-buffer-window "*vterm*" t))

(defun my/vterm-focused-p ()
  "checks if point (cursor) is on terminal. t or nil"
  (eq (selected-window) (my/vterm-visible-p)))

(defun my/show-vterm (&optional switch)
  "show terminal in split window 'below or 'right
if terminal buffer not created then first create it"
  (save-window-excursion
    (vterm))

  (let ((win (my/vterm-visible-p)))
    (unless win
      (setf win
	    (if *my-vterm-below*
		(split-window nil -15 'below)
	      (split-window nil -80 'right)))
      (set-window-buffer win (get-buffer "*vterm*")))
    (when switch (select-window win))))

(defun my/hide-vterm ()
  "hides terminal only when terminal is focused"
  (when (my/vterm-focused-p)
    (delete-window (get-buffer-window "*vterm*" t))))

(defun my/toggle-vterm ()
  "toggles terminal"
  (interactive)
  (if (my/vterm-focused-p)
      (my/hide-vterm)
    (my/show-vterm t)))

(defun my/move-vterm ()
  "moves terminal between below <-> right"
  (interactive)
  (setq *my-vterm-below* (not *my-vterm-below*))

  (when (my/vterm-visible-p)
    (my/hide-vterm))
  (my/show-vterm t))

(defun my/send-command-vterm (command)
  "send command to vterm"
  (my/show-vterm)
  (with-current-buffer "*vterm*"
    (goto-char (point-max))
    (term-send-raw-string (concat command "\n"))))

;; Keybindings
(global-set-key (kbd "C-`")   #'my/toggle-vterm)
(global-set-key (kbd "C-M-`") #'my/move-vterm)


;; --------------------------------------------------------------------------------
;; SLY SETUP - EVAL LAST EXPRESSION LISP
;; --------------------------------------------------------------------------------
(use-package sly
  :init
  (setq inferior-lisp-program "sbcl")
  :config
  (sly-setup '(sly-fancy)))

(defun my/indicate (beg end)
  (pulse-momentary-highlight-region beg end))

(defun my/lang-context-p (mode language)
  (or
   (derived-mode-p mode)
   (and (derived-mode-p 'org-mode)
	(org-in-src-block-p)
	(string=
	 (org-element-property :language (org-element-context))
	 language))))

(defun my/get-last-expression-lisp ()
  (with-syntax-table emacs-lisp-mode-syntax-table
    (thing-at-point 'sexp t)))

(defun my/eval-last-expression-lisp ()
  (let ((expr (my/get-last-expression-lisp)))
    (if (string-prefix-p "(defun " expr)
	(sly-eval-last-expression)
      (if-let ((buf (get-buffer "*sly-mrepl for sbcl*")))
	  (with-current-buffer buf
	    (goto-char (point-max))
	    (insert expr)
	    (sly-mrepl-return))
	(message "SLY REPL not running")))))

(defun my/eval-last-expression ()
  (interactive)
  (cond
   ((my/lang-context-p 'lisp-mode "lisp")
    (my/eval-last-expression-lisp))

   (t
    (message "context not supported"))))


(global-set-key (kbd "C-M-e") #'my/eval-last-expression)
