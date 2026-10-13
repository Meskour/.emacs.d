;;; raddbg-theme.el --- Dark theme inspired by the RAD Debugger UI -*- lexical-binding: t; -*-

;; Colors are estimated by eye from a screenshot, so tweak freely.
;;
;; Install:
;;   1. Put this file in ~/.emacs.d/themes/
;;   2. Add to init.el:
;;        (add-to-list 'custom-theme-load-path "~/.emacs.d/themes/")
;;        (load-theme 'raddbg t)
;;   3. Optional font (pick any monospace you have installed):
;;        (set-face-attribute 'default nil :family "Consolas" :height 110)

(deftheme raddbg
  "Dark blue-gray theme with muted syntax colors, inspired by the RAD Debugger.")

(let* ((bg        "#1f252a")
       (bg-alt    "#262d33")
       (bg-hl     "#2d353c")
       (bg-gutter "#1b2125")
       (fg        "#b9c0c5")
       (fg-dim    "#6f7d85")
       (fg-bright "#dfe4e7")
       (orange    "#e0793a")
       (yellow    "#d3b46c")
       (tan       "#bda98a")
       (green     "#6fae4e")
       (green-bg  "#2c3d2a")
       (blue      "#4f8fc4")
       (cyan      "#59b3b3")
       (red       "#d9534f")
       (select    "#34556b"))

  (custom-theme-set-faces
   'raddbg
   ;; Basics
   `(default             ((t (:background ,bg :foreground ,fg))))
   `(cursor              ((t (:background ,orange))))
   `(region              ((t (:background ,select))))
   `(highlight           ((t (:background ,bg-hl))))
   `(hl-line             ((t (:background ,bg-alt))))
   `(fringe              ((t (:background ,bg-gutter :foreground ,fg-dim))))
   `(vertical-border     ((t (:foreground ,bg-hl))))
   `(minibuffer-prompt   ((t (:foreground ,orange :weight bold))))
   `(shadow              ((t (:foreground ,fg-dim))))
   `(link                ((t (:foreground ,blue :underline t))))
   `(error               ((t (:foreground ,red))))
   `(warning             ((t (:foreground ,yellow))))
   `(success             ((t (:foreground ,green))))

   ;; Line numbers
   `(line-number              ((t (:background ,bg-gutter :foreground ,fg-dim))))
   `(line-number-current-line ((t (:background ,bg-hl :foreground ,fg-bright))))

   ;; Mode line (looks like the debugger's status bar: green for active)
   `(mode-line           ((t (:background ,green-bg :foreground ,fg-bright :box nil))))
   `(mode-line-inactive  ((t (:background ,bg-alt :foreground ,fg-dim :box nil))))
   `(mode-line-buffer-id ((t (:foreground ,fg-bright :weight bold))))

   ;; Syntax
   `(font-lock-keyword-face         ((t (:foreground ,tan))))
   `(font-lock-type-face            ((t (:foreground ,yellow))))
   `(font-lock-function-name-face   ((t (:foreground ,orange))))
   `(font-lock-function-call-face   ((t (:foreground ,orange))))
   `(font-lock-variable-name-face   ((t (:foreground ,fg))))
   `(font-lock-constant-face        ((t (:foreground ,cyan))))
   `(font-lock-builtin-face         ((t (:foreground ,tan))))
   `(font-lock-string-face          ((t (:foreground ,fg-bright))))
   `(font-lock-comment-face         ((t (:foreground ,fg-dim :slant italic))))
   `(font-lock-comment-delimiter-face ((t (:foreground ,fg-dim))))
   `(font-lock-preprocessor-face    ((t (:foreground ,blue))))
   `(font-lock-number-face          ((t (:foreground ,fg-bright))))
   `(font-lock-warning-face         ((t (:foreground ,red))))

   ;; Search
   `(isearch             ((t (:background ,orange :foreground ,bg))))
   `(lazy-highlight      ((t (:background ,select :foreground ,fg-bright))))
   `(show-paren-match    ((t (:background ,select :foreground ,fg-bright))))
   `(show-paren-mismatch ((t (:background ,red :foreground ,bg))))))

(provide-theme 'raddbg)

;;; raddbg-theme.el ends here
