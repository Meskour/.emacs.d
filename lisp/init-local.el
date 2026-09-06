;;; init-local.el --- -*- lexical-binding: t; -*-
;;; Package -- Summary
;;; Commentary:
;;; Code:
(set-face-attribute 'default nil
                    :family "JetBrainsMono Nerd Font"
                    :height 120)
;;; init-local.el --- Nuxt/Vue setup -*- lexical-binding: t -*-

;;; web-mode: handle .vue single-file components
(use-package web-mode
  :ensure t
  :mode "\\.vue\\'"
  :config
  (setq web-mode-script-padding 0
        web-mode-style-padding 0
        web-mode-code-indent-offset 2
        web-mode-css-indent-offset 2
        web-mode-markup-indent-offset 2
        web-mode-attr-indent-offset 2
        web-mode-enable-auto-closing t
        web-mode-enable-auto-pairing t))

;;; typescript-mode: Nuxt projects are almost always TS
(use-package typescript-mode
  :ensure t
  :mode "\\.ts\\'")

;;; lsp-mode: explicit autoload declarations so lsp-deferred exists
;;; before lsp-mode is actually loaded
(use-package lsp-mode
  :ensure t
  :commands (lsp lsp-deferred)
  :config
  (require 'lsp-volar))

(add-hook 'web-mode-hook
          (lambda ()
            (when (string-match-p "\\.vue\\'" (or (buffer-file-name) ""))
              (lsp-deferred))))

(add-hook 'typescript-mode-hook #'lsp-deferred)
(add-hook 'js-mode-hook #'lsp-deferred)
(add-hook 'js2-mode-hook #'lsp-deferred)

(add-hook 'typescript-ts-mode-hook #'lsp-deferred)
(add-hook 'tsx-ts-mode-hook #'lsp-deferred)

;;; emmet-mode: fast HTML/template expansion in .vue templates
(use-package emmet-mode
  :ensure t
  :hook (web-mode . emmet-mode))

;;; prettier support (optional, Nuxt projects almost always use it)
(use-package prettier-js
  :ensure t
  :hook ((web-mode . prettier-js-mode)
         (typescript-mode . prettier-js-mode)))

(setq major-mode-remap-alist
      '((typescript-mode . typescript-ts-mode)
        (js-mode . typescript-ts-mode)
        (json-mode . json-ts-mode)))

(add-to-list 'auto-mode-alist '("\\.tsx\\'" . tsx-ts-mode))
(add-to-list 'auto-mode-alist '("\\.ts\\'" . typescript-ts-mode))

;; Disable dimmer-mode (and prevent after-init-hook from re-enabling it)
(remove-hook 'after-init-hook 'dimmer-mode)
(with-eval-after-load 'dimmer
  (dimmer-mode -1)
  ;; Guard against upstream dimmer bug with symbol 'foreground-color in face attributes
  (advice-add 'dimmer--dim-face-attribute :around
              (lambda (orig-fun face attr target frac)
                (condition-case nil
                    (apply orig-fun face attr target frac)
                  (wrong-type-argument nil)))))

;; ── Vulkanite theme engine ───────────────────────────────────────────────
;; Add to both load-path (for require) and custom-theme-load-path (for load-theme)
(add-to-list 'load-path
             (expand-file-name "site-lisp/vulkanite-theme" user-emacs-directory))
(add-to-list 'custom-theme-load-path
             (expand-file-name "site-lisp/vulkanite-theme" user-emacs-directory))

;; Load the engine so sync functions are available immediately
(require 'vulkanite-theme)

;; On startup: load whichever vulkanite variant matches the current omarchy theme.
;; Falls back silently if theme.name is missing (non-omarchy machine).
(vulkanite-sync-omarchy-theme)

;; After init: watch theme.name so Super+Alt+Space changes auto-sync to Emacs.
(add-hook 'after-init-hook #'vulkanite-watch-omarchy-theme)
;; ─────────────────────────────────────────────────────────────────────────

(provide 'init-local)
;;; init-local.el ends here
