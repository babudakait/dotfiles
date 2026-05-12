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

(setq auto-save-default nil)   ;; Disable auto-saving
(setq make-backup-files nil)   ;; Disable backup~ files
(setq create-lockfiles nil)    ;; Disable .#lock files

;; Something Performace Wise via ChatGPT
(setq gc-cons-threshold (* 50 1000 1000))
(add-hook 'emacs-startup-hook (lambda () (setq gc-cons-threshold (* 2 1000 1000))))

;; Set Font
(set-face-attribute 'default nil :font "Iosevka Light" :height 140)


;; --------------------------------------------------------------------------------
;; ORG-MODE SETUP
;; --------------------------------------------------------------------------------
(require 'org)
(require 'org-tempo)

(use-package visual-fill-column)

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

(setq org-hide-emphasis-markers t)
(setq org-startup-folded 'overview)
(setq org-confirm-babel-evaluate nil)

(setq org-src-window-setup 'current-window)
(setq org-src-preserve-indentation t)
(setq org-edit-src-content-indentation 0)
(setq org-ellipsis " ▼ ")

(setq org-indent-indentation-per-level 3)

(defun my/org-visual-setup ()
  (setf visual-fill-column-width 110
	visual-fill-column-center-text t)
  (visual-fill-column-mode 1)
  (visual-line-mode 1))

(add-hook 'org-mode-hook 'my/org-visual-setup)
(add-hook 'org-mode-hook 'org-indent-mode)

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
  (dolist (face '(org-level-1 org-level-2 org-level-3 org-level-4
			      org-level-5 org-level-6 org-level-7 org-level-8))
    (set-face-attribute face nil :weight 'bold :height 1.1))

  (add-to-list 'org-file-apps '("\\.png\\'" . "feh %s"))
  (add-to-list 'org-file-apps '("\\.jpg\\'" . "feh %s"))
  (add-to-list 'org-file-apps '("\\.jpeg\\'" . "feh %s"))
  (add-to-list 'org-file-apps '("\\.gif\\'" . "feh %s"))
  (add-to-list 'org-file-apps '("\\.webp\\'" . "feh %s"))
  (add-to-list 'org-file-apps '("\\.svg\\'" . "feh %s"))
  (add-to-list 'org-file-apps '("\\.mp4\\'" . "mpv %s")))


;; --------------------------------------------------------------------------------
;; THEME SETUP
;; --------------------------------------------------------------------------------
(use-package cyberpunk-theme)
(use-package doom-themes)

(defvar *my-themes*
  '(default
    cyberpunk
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
    (unless (eq theme 'default)
      (load-theme theme t))
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

