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

(use-package visual-fill-column
  :ensure t)

(defun my/org-visual-setup ()
  (setf visual-fill-column-width 100
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
;; PDF-TOOLS PACKAGE
;; --------------------------------------------------------------------------------
(use-package pdf-tools
  :config
  (pdf-tools-install))


;; --------------------------------------------------------------------------------
;; THEME SETUP
;; --------------------------------------------------------------------------------
(use-package cyberpunk-theme
  :config
  (load-theme 'cyberpunk t))


;; --------------------------------------------------------------------------------
;; VTERM SETUP
;; --------------------------------------------------------------------------------
(use-package vterm
  :ensure t
  :commands vterm
  :config
  (setf vterm-shell "/bin/bash"))
