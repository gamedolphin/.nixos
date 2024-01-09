;;; package --- Summary - My minimal Emacs init file

;;; Commentary:
;;; Simple Emacs setup I carry everywhere

(setq custom-file (concat user-emacs-directory "custom.el")) ;; keep this file pristine
(load custom-file 'noerror)

(require 'package)
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/") t)
(package-initialize)

;;; Code:
(use-package emacs
  :ensure t
  :demand t
  :custom
  ;; ME!
  (user-full-name "Sandeep Nambiar")
  ;; memory configuration
  (gc-cons-threshold 10000000 "Higher garbage collection threshold, prevents frequent gc locks.")
  (byte-compile-warnings '(not obsolete) "Ignore warnings for (obsolete) elisp compilations.")
  (warning-suppress-log-types '((comp) (bytecomp)) "And other log types completely.")
  (large-file-warning-threshold 100000000 "Large files are okay in the new millenium.")
  (read-process-output-max (max (* 1024 1024) read-process-output-max) "Read upto 1mb (or max) based on system pipe capacity")
  ;; scrolling configuration
  (scroll-margin 0 "Lets scroll to the end of the margin.")
  (scroll-conservatively 100000 "Never recenter the window.")
  (scroll-preserve-screen-position 1 "Scrolling back and forth between the same points.")
  ;; frame configuration
  (frame-inhibit-implied-resize t "Improve emacs startup time by not resizing to adjust for custom settings.")
  (frame-resize-pixelwise t "Dont resize based on character height / width but to exact pixels.")
  ;; backups
  (backup-directory-alist '(("." . "~/.backups/")) "Don't clutter.")
  (backup-by-copying t "Don't clobber symlinks.")
  (create-lockfiles nil "Don't have temp files that trip the language servers.")
  (delete-old-versions t "Cleanup automatically.")
  (kept-new-versions 6 "Update every few times.")
  (kept-old-versions 2 "And cleanup even more.")
  (version-control t "Version them backups")
  (inhibit-startup-screen t "I have already done the tutorial. Twice.")
  (inhibit-startup-message t "I know I am ready")
  (inhibit-startup-echo-area-message t "Yep, still know it")
  (initial-scratch-message nil "I know it is the scratch buffer where I can write anything!")
  ;; packages
  (package-install-upgrade-built-in t)
  (use-package-always-ensure t)
  ;; tabs
  (tab-width 4 "Always tab 4 spaces.")
  (indent-tabs-mode nil "Never use actual tabs.")

  :init
  (global-auto-revert-mode t)          ;; revert automatically on external file changes
  (savehist-mode)                      ;; save minibuffer history
                                       ;; base visual
  (menu-bar-mode -1)                   ;; no menu bar
  (toggle-scroll-bar -1)               ;; no scroll bar
  (tool-bar-mode -1)                   ;; no tool bar either
  (global-hl-line-mode +1)             ;; always highlight current line
  (blink-cursor-mode -1)               ;; stop blinking
  (global-display-line-numbers-mode 1) ;; always show line numbers
  (column-number-mode t)               ;; column number in the mode line
  (size-indication-mode t)             ;; file size in the mode line
  (pixel-scroll-precision-mode)        ;; smooth mouse scroll
  (fset 'yes-or-no-p 'y-or-n-p)        ;; dont ask me to type yes/no everytime, y/n is good enough
  (electric-pair-mode)                 ;; i mean ... parens should auto create

  ;; UTF-8 EVERYWHERE
  (prefer-coding-system       'utf-8)
  (set-default-coding-systems 'utf-8)
  (set-terminal-coding-system 'utf-8)
  (set-keyboard-coding-system 'utf-8)
  (set-language-environment   'utf-8)

  (set-frame-font "Iosevka Semibold 12" nil t) ;; font of the century

  :bind
  (("C-<wheel-up>"   . nil)                  ; dont zoom in please
   ("C-<wheel-down>" . nil)                  ; dont zoom in either
   ("C-x k"          . kill-this-buffer))    ; kill the buffer, dont ask

  :mode ; all the special files
  ("\\.rs\\'" . rust-ts-mode)
  ("\\.go\\'" . go-ts-mode)
  ("\\.ts\\'" . typescript-ts-mode)
  ("\\.tsx\\'" . tsx-ts-mode)
  ("\\.cs\\'" . csharp-ts-mode)
  ("\\.cpp\\'" . c++-ts-mode)
  ("\\.h\\'" . c++-ts-mode)
  ("\\.hpp\\'" . c++-ts-mode))

(use-package diminish :defer t) ;; declutter the modeline
(use-package eldoc :defer t :diminish eldoc-mode) ;; docs for everything

(use-package nerd-icons
  :defer t
  :custom
  (nerd-icons-color-icons nil) ;; disable bright icon colors
  )

(use-package doom-modeline
  :custom
  (inhibit-compacting-font-caches t) ;; speed
  (doom-modeline-buffer-file-name-style 'relative-from-project)
  (doom-modeline-major-mode-icon nil) ;; distracting icons, no thank you
  (doom-modeline-buffer-encoding nil) ;; everything is utf-8 anyway
  (doom-modeline-buffer-state-icon nil) ;; the filename already shows me
  (doom-modeline-lsp nil) ;; lsp state is too distracting, too often
  :hook (after-init . doom-modeline-mode))

(use-package doom-themes
  :commands doom-themes-visual-bell-config
  :custom
  (doom-themes-enable-bold t)
  (doom-themes-enable-italic t)
  :init
  (load-theme 'doom-nord t)
  (doom-themes-visual-bell-config))

(use-package which-key
  :commands which-key-mode
  :diminish which-key-mode
  :config
  (which-key-mode))

(use-package expand-region
  :defer t
  :bind ("M-m" . er/expand-region))

(use-package puni
  :commands puni-global-mode
  :defer t
  :init
  (puni-global-mode))

(use-package avy
  :defer t
  :bind
  ("M-i" . avy-goto-char)
  :custom
  (avy-background t))

(use-package orderless
  :init
  ;; Tune the global completion style settings to your liking!
  ;; This affects the minibuffer and non-lsp completion at point.
  (setq completion-styles '(orderless partial-completion basic)
        completion-category-defaults nil
        completion-category-overrides nil))

(use-package ag :defer t)

(use-package consult
  :defer t
  :bind
  ("C-x b" . consult-buffer)                ;; orig. switch-to-buffer
  ("M-y" . consult-yank-pop)                ;; orig. yank-pop
  ("M-g M-g" . consult-goto-line)           ;; orig. goto-line
  :custom
  (consult-narrow-key "<"))

(use-package embark
  :commands embark-prefix-help-command
  :bind
  ("C-'" . embark-act)
  ("C-;" . embark-dwim)
  ("C-h B" . embark-bindings)
  :init
  (setq prefix-help-command #'embark-prefix-help-command)
  :config
  (add-to-list 'display-buffer-alist
               '("\\`\\*Embark Collect \\(Live\\|Completions\\)\\*"
                 nil
                 (window-parameters (mode-line-format . none)))))

(use-package embark-consult
  :defer t
  :hook
  (embark-collect-mode . consult-preview-at-point-mode))

(use-package vertico
  :defer t
  :custom
  (read-file-name-completion-ignore-case t)
  (read-buffer-completion-ignore-case t)
  (completion-ignore-case t)
  (enable-recursive-minibuffers t)
  :init
  (vertico-mode)
  :config
  (setq minibuffer-prompt-properties
        '(read-only t cursor-intangible t face minibuffer-prompt))
  (add-hook 'minibuffer-setup-hook #'cursor-intangible-mode))

(use-package marginalia :defer t :init (marginalia-mode))

(use-package crux
  :defer t
  :bind
  ("C-c M-e" . crux-find-user-init-file)
  ("C-c C-w" . crux-transpose-windows)
  ("C-a" . crux-move-beginning-of-line))

(use-package magit :defer t :bind (("C-M-g" . magit-status)))

(use-package apheleia
  :defer t
  :config
  (add-to-list 'apheleia-formatters '(rustfmt . ("rustfmt" "--quiet" "--emit" "stdout" "--edition" "2021")))
  (apheleia-global-mode +1))

(use-package flycheck
  :defer t
  :diminish
  :init (global-flycheck-mode))

(use-package corfu
  :custom
  (corfu-cycle t)
  (corfu-auto nil)
  (corfu-separator ?_)
  :init
  (global-corfu-mode))

(use-package kind-icon
  :defer t
  :after corfu
  :custom
  (kind-icon-use-icons nil)
  (kind-icon-default-face 'corfu-default) ; to compute blended backgrounds correctly
  :config
  (add-to-list 'corfu-margin-formatters #'kind-icon-margin-formatter))

(use-package cape :defer t)

(use-package treesit-auto :defer t
  :ensure t
  :functions global-treesit-auto-mode
  :config
  (global-treesit-auto-mode))

(use-package yasnippet
  :commands yas-global-mode
  :defer t
  :diminish yas-minor-mode
  :config
  (yas-global-mode 1))

(use-package yasnippet-snippets :defer t :after yasnippet)

(use-package projectile
  :commands projectile-mode
  :diminish projectile-mode
  :custom
  (projectile-globally-ignored-directories (append '("node_modules")))
  :bind-keymap ("C-c p" . projectile-command-map)
  :config
  (projectile-mode +1))

(use-package exec-path-from-shell
  :commands exec-path-from-shell-initialize
  :custom
  (exec-path-from-shell-arguments nil)
  :config
  (exec-path-from-shell-initialize))

(use-package rust-ts-mode
  :defer t
  :custom
  (lsp-rust-analyzer-cargo-watch-command "clippy")
  (lsp-rust-analyzer-macro-expansion-method 'lsp-rust-analyzer-macro-expansion-default)
  (lsp-rust-analyzer-exclude-dirs ["Temp/**"])
  (lsp-eldoc-render-all t))

(use-package typescript-ts-mode
  :defer t
  :custom
  (lsp-javascript-preferences-import-module-specifier :relative)
  (typescript-indent-level 2)
  (typescript-ts-mode-indent-offset 2))

(use-package lsp-mode
  :commands (lsp lsp-deferred lsp-format-buffer lsp-organize-imports)
  :diminish lsp-lens-mode
  :bind-keymap
  ("C-c l" . lsp-command-map)
  :custom
  (lsp-lens-enable nil)
  (lsp-idle-delay 0.500)
  (lsp-modeline-code-actions-enable nil)
  (lsp-modeline-diagnostics-enable nil)
  (lsp-csharp-omnisharp-roslyn-binary-path "OmniSharp")
  (lsp-completion-provider :none) ;; we use Corfu!
  :init
   (defun my/orderless-dispatch-flex-first (_pattern index _total)
    (and (eq index 0) 'orderless-flex))

  (defun my/lsp-mode-setup-completion ()
    (setf (alist-get 'styles (alist-get 'lsp-capf completion-category-defaults))
          '(orderless)))

  ;; Optionally configure the first word as flex filtered.
  (add-hook 'orderless-style-dispatchers #'my/orderless-dispatch-flex-first nil 'local)

  ;; Optionally configure the cape-capf-buster.
  (setq-local completion-at-point-functions (list (cape-capf-buster #'lsp-completion-at-point)))
  :config
  (add-to-list 'lsp-file-watch-ignored-directories "[/\\\\]\\Temp\\'")
  (add-to-list 'lsp-file-watch-ignored-directories "[/\\\\]\\Logs\\'")
  (defun lsp-cleanup ()
    (lsp-format-buffer)
    (lsp-organize-imports))
  :hook
  (lsp-completion-mode . my/lsp-mode-setup-completion)
  ((go-ts-mode
    rust-ts-mode
    csharp-ts-mode
    typescript-ts-mode
    c++-ts-mode) . lsp-deferred)
  (lsp-mode . lsp-enable-which-key-integration)
  (before-save . lsp-cleanup))

(use-package lsp-ui :commands lsp-ui-mode
  :custom
  (lsp-ui-doc-enable t)
  (lsp-ui-sideline-diagnostic-max-lines 4)
  (lsp-ui-doc-show-with-mouse nil)
  (lsp-ui-doc-position 'bottom)
  (lsp-ui-doc-show-with-cursor t)
  (lsp-eldoc-enable-hover nil)
  )

(use-package whitespace-cleanup-mode
  :commands global-whitespace-cleanup-mode
  :config
  (global-whitespace-cleanup-mode))

(use-package nix-mode)
(use-package eat)
(use-package hcl-mode)
(use-package jinja2-mode)


(provide 'init)
;;; init.el ends here
