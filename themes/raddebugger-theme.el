;;; raddebugger-theme.el --- RAD Debugger source view color theme -*- lexical-binding: t; no-byte-compile: t -*-

(deftheme raddebugger
  "Color theme inspired by the RAD Debugger source code view (Default Dark).")

(let ((bg           "#1f1f1f")
      (bg-alt       "#222222")
      (bg-hl        "#2a2a2a")
      (bg-select    "#31393d")
      (bg-search    "#675331")
      (fg           "#cccccc") ;; #ececec
      (fg-weak      "#a4a4a4")
      (border       "#404040")
      (cursor       "#8aff00")
      ;; RAD Debugger code color slots:
      (code-keyword "#838b8f")
      (code-symbol  "#ceaf64")
      (code-type    "#ceaf64")
      (code-local   "#a7dae8")
      (code-string  "#9cb198")
      (code-num     "#9cb198")
      (code-meta    "#b9819a")
      (code-comment "#627b5e")
      (code-op      "#838b8f")
      ;; Status colors:
      (good         "#32a852")
      (neutral      "#3a90bb")
      (bad          "#cf5242")
      (gold         "#ebb624"))

  (custom-theme-set-faces
   'raddebugger

   ;; Basic editor UI
   `(default ((t (:background ,bg :foreground ,fg))))
   `(cursor ((t (:background ,cursor))))
   `(region ((t (:background ,bg-select :extend t))))
   `(highlight ((t (:background ,bg-hl))))
   `(hl-line ((t (:background ,bg-hl :extend t))))
   `(fringe ((t (:background ,bg :foreground ,fg-weak))))
   `(line-number ((t (:background ,bg-alt :foreground ,fg-weak))))
   `(line-number-current-line ((t (:background ,bg-alt :foreground ,fg :weight bold))))
   `(vertical-border ((t (:foreground ,border))))
   `(minibuffer-prompt ((t (:foreground ,code-symbol :weight bold))))

   ;; Mode line
   `(mode-line ((t (:background ,bg-alt :foreground ,fg :box (:line-width -1 :color ,border)))))
   `(mode-line-inactive ((t (:background ,bg :foreground ,fg-weak :box (:line-width -1 :color ,border)))))

   ;; Search
   `(isearch ((t (:background ,bg-search :foreground "#ffffff" :weight bold))))
   `(lazy-highlight ((t (:background ,bg-select :foreground ,fg))))

   ;; Standard Font Lock
   `(font-lock-comment-face ((t (:foreground ,code-comment :slant italic))))
   `(font-lock-comment-delimiter-face ((t (:foreground ,code-comment :slant italic))))
   `(font-lock-doc-face ((t (:foreground ,code-comment))))
   `(font-lock-string-face ((t (:foreground ,code-string))))
   `(font-lock-constant-face ((t (:foreground ,code-num))))
   `(font-lock-number-face ((t (:foreground ,code-num))))
   `(font-lock-keyword-face ((t (:foreground ,code-keyword :weight semi-bold))))
   `(font-lock-function-name-face ((t (:foreground ,code-symbol :weight bold))))
   `(font-lock-variable-name-face ((t (:foreground ,code-local))))
   `(font-lock-type-face ((t (:foreground ,code-type))))
   `(font-lock-preprocessor-face ((t (:foreground ,code-meta))))
   `(font-lock-builtin-face ((t (:foreground ,code-meta))))
   `(font-lock-warning-face ((t (:foreground ,gold :weight bold))))
   `(font-lock-negation-char-face ((t (:foreground ,code-op))))
   `(font-lock-operator-face ((t (:foreground ,code-op))))
   `(font-lock-delimiter-face ((t (:foreground ,code-op))))
   `(font-lock-bracket-face ((t (:foreground ,code-op))))
   `(font-lock-misc-punctuation-face ((t (:foreground ,code-op))))

   ;; Tree-Sitter Faces (Emacs 29+)
   `(font-lock-function-call-face ((t (:foreground ,code-symbol))))
   `(font-lock-variable-use-face ((t (:foreground ,code-local))))
   `(font-lock-property-name-face ((t (:foreground ,code-local))))
   `(font-lock-property-use-face ((t (:foreground ,code-local))))

   ;; Parenthesis matching
   `(show-paren-match ((t (:background "#3d3631" :foreground ,cursor :weight bold))))
   `(show-paren-mismatch ((t (:background ,bad :foreground "#ffffff"))))

   ;; Diff / Magit
   `(diff-added ((t (:background "#2c5b36" :foreground "#e3f5d3" :extend t))))
   `(diff-removed ((t (:background "#803425" :foreground "#ffffff" :extend t))))
   `(diff-header ((t (:background ,bg-alt :foreground ,neutral))))))

(provide-theme 'raddebugger)
;;; raddebugger-theme.el ends here
