;;; early-init.el --- Emacs 27+ pre-initialisation config  -*- lexical-binding: t; -*-

;;; Commentary:

;; Emacs 27+ loads this file before (normally) calling
;; `package-initialize'.  We use this file to suppress that automatic
;; behaviour so that startup is consistent across Emacs versions.

;;; Code:

(setq package-enable-at-startup nil)

(add-to-list 'default-frame-alist '(background-color . "#1e1e1e"))
(add-to-list 'default-frame-alist '(foreground-color . "#ffffff"))
(add-to-list 'initial-frame-alist '(background-color . "#1e1e1e"))
(add-to-list 'initial-frame-alist '(foreground-color . "#ffffff"))

;; Optional: also suppress the fringe/mode-line flashing white
(set-face-attribute 'default nil :background "#1e1e1e" :foreground "#ffffff")

;; So we can detect this having been loaded
(provide 'early-init)

;;; early-init.el ends here
