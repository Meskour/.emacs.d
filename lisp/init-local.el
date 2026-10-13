;;; init-local.el --- -*- lexical-binding: t; -*-
;;; Package -- Summary
;;; Commentary:
;;; Code:
(set-face-attribute 'default nil
                    ;; :family "JetBrainsMono Nerd Font"
                    ;; :family "Iosevka Nerd Font"
                    ;; :family "Hack"
                    :height 140)

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

;;; Vue / TypeScript LSP support via Eglot
(defun my/find-vue-typescript-plugin ()
  "Find the directory of @vue/typescript-plugin."
  (let* ((project-root (when (project-current) (project-root (project-current))))
         (dominating (locate-dominating-file (or (buffer-file-name) default-directory) "node_modules"))
         (candidates (delq nil
                           (list (when project-root
                                   (expand-file-name "node_modules/@vue/typescript-plugin" project-root))
                                 (when dominating
                                   (expand-file-name "node_modules/@vue/typescript-plugin" dominating))
                                 "/usr/lib/node_modules/@vue/typescript-plugin"
                                 "/usr/local/lib/node_modules/@vue/typescript-plugin"))))
    (seq-find #'file-directory-p candidates)))

(defun my/eglot-vue-contact (&optional _interactive _project)
  "Return server contact for Vue single-file components using typescript-language-server and @vue/typescript-plugin."
  (let ((plugin (my/find-vue-typescript-plugin)))
    (if plugin
        (list "typescript-language-server" "--stdio"
              :initializationOptions
              (list :plugins
                    (vector
                     (list :name "@vue/typescript-plugin"
                           :location plugin
                           :languages (vector "vue")))))
      (list "typescript-language-server" "--stdio"))))

(with-eval-after-load 'eglot
  (add-to-list 'eglot-server-programs
               '(((web-mode :language-id "vue")
                  (vue-mode :language-id "vue")
                  (vue-ts-mode :language-id "vue"))
                 . my/eglot-vue-contact)))

(add-hook 'web-mode-hook
          (lambda ()
            (when (string-match-p "\\.vue\\'" (or (buffer-file-name) ""))
              (eglot-ensure))))

(add-hook 'typescript-mode-hook #'eglot-ensure)
(add-hook 'typescript-ts-mode-hook #'eglot-ensure)
(add-hook 'tsx-ts-mode-hook #'eglot-ensure)
(add-hook 'js-mode-hook #'eglot-ensure)
(add-hook 'js2-mode-hook #'eglot-ensure)

;;; emmet-mode: fast HTML/template expansion in .vue templates
(use-package emmet-mode
  :ensure t
  :hook (web-mode . emmet-mode))

;;; Add local node_modules/.bin to exec-path (handles modern npm where 'npm bin' was removed)
(defun my/add-node-modules-bin-to-exec-path ()
  "Add local node_modules/.bin to buffer-local exec-path and PATH."
  (when-let* ((start (or (buffer-file-name) default-directory))
              (root (locate-dominating-file
                     start
                     (lambda (d) (file-directory-p (expand-file-name "node_modules/.bin" d))))))
    (let ((bin (expand-file-name "node_modules/.bin" root)))
      (make-local-variable 'exec-path)
      (cl-pushnew bin exec-path :test #'equal)
      (setenv "PATH" (concat bin path-separator (getenv "PATH"))))))

(dolist (hook '(web-mode-hook
                typescript-mode-hook
                typescript-ts-mode-hook
                tsx-ts-mode-hook
                js-mode-hook
                js2-mode-hook))
  (add-hook hook #'my/add-node-modules-bin-to-exec-path))

;;; prettier support (only format on save if prettier is available)
(use-package prettier-js
  :ensure t
  :hook ((web-mode . my/enable-prettier-if-available)
         (typescript-mode . my/enable-prettier-if-available)
         (typescript-ts-mode . my/enable-prettier-if-available)
         (tsx-ts-mode . my/enable-prettier-if-available))
  :init
  (defun my/enable-prettier-if-available ()
    (my/add-node-modules-bin-to-exec-path)
    (when (executable-find "prettier")
      (prettier-js-mode 1))))

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

;; Set vulkanite-gruvbox background to #1e1e1e (matching the screenshot)
(defun my/vulkanite-gruvbox-apply-background (&optional _theme)
  "Ensure `vulkanite-gruvbox' uses #1e1e1e background when it is the active theme."
  (when (eq (car custom-enabled-themes) 'vulkanite-gruvbox)
    (set-face-attribute 'default nil :background "#1e1e1e")))

(add-hook 'enable-theme-functions #'my/vulkanite-gruvbox-apply-background)
(add-hook 'disable-theme-functions #'my/vulkanite-gruvbox-apply-background)
(add-hook 'after-make-frame-functions
          (lambda (frame)
            (when (eq (car custom-enabled-themes) 'vulkanite-gruvbox)
              (set-face-attribute 'default frame :background "#1e1e1e"))))

;; Apply immediately if vulkanite-gruvbox is already active
(my/vulkanite-gruvbox-apply-background)
;; ─────────────────────────────────────────────────────────────────────────

(use-package gptel
  :ensure t
  :config
  (setq gptel-model 'gemini-2.5-flash)

  (setq gptel-backend
        (gptel-make-gemini
            "Gemini"
          :stream t)))

(add-to-list 'custom-theme-load-path "~/.emacs.d/themes/")
(load-theme 'raddebugger t)

(provide 'init-local)
;;; init-local.el ends here
