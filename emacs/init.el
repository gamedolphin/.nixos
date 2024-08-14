;;; package --- Summary - My minimal Emacs init file -*- lexical-binding: t -*-

;;; Commentary:
;;; Simple Emacs setup I carry everywhere

(load custom-file 'noerror)

(require 'package)
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/") t)
(add-to-list 'package-archives '("nongnu" . "https://elpa.nongnu.org/nongnu/") t)
(package-initialize)

;;; Code:
(use-package emacs
  :ensure t
  :demand t
  :init
  (global-auto-revert-mode t)          ;; revert automatically on external file changes
  (savehist-mode)                      ;; save minibuffer history

  (add-hook 'before-save-hook 'whitespace-cleanup) ;; always cleanup whitespace on save

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
  (recentf-mode)                       ;; keep track of recently opened files

  (set-frame-font "Iosevka Semibold 12" nil t) ;; font of the century

  :bind
  (("C-<wheel-up>"   . pixel-scroll-precision) ; dont zoom in please, just scroll
   ("C-<wheel-down>" . pixel-scroll-precision) ; dont zoom in either, just scroll
   ("C-x k"          . kill-current-buffer))   ; kill the buffer, dont ask
  )

(use-package nerd-icons
  :defer t
  :custom
  (nerd-icons-color-icons nil) ;; disable bright icon colors
  )

(use-package doom-modeline
  :custom
  (inhibit-compacting-font-caches t)    ;; speed
  (doom-modeline-buffer-file-name-style 'relative-from-project)
  (doom-modeline-major-mode-icon nil)   ;; distracting icons, no thank you
  (doom-modeline-buffer-encoding nil)   ;; everything is utf-8 anyway
  (doom-modeline-buffer-state-icon nil) ;; the filename already shows me
  (doom-modeline-lsp nil)               ;; lsp state is too distracting, too often
  :hook (after-init . doom-modeline-mode))

(use-package doom-themes
  :commands doom-themes-visual-bell-config
  :custom
  (doom-themes-enable-bold t)
  (doom-themes-enable-italic t)
  :init
  (load-theme 'doom-nord t)
  (doom-themes-visual-bell-config))

(use-package diminish :defer t)                   ;; declutter the modeline
(use-package eldoc :defer t :diminish eldoc-mode) ;; docs for everything

(use-package pulsar
  :commands pulsar-global-mode pulsar-recenter-top pulsar-reveal-entry
  :init
  (defface pulsar-nord
    '((default :extend t)
      (((class color) (min-colors 88) (background light))
       :background "#2e3440")
      (((class color) (min-colors 88) (background dark))
       :background "#81a1c1")
      (t :inverse-video t))
    "Alternative nord face for `pulsar-face'."
    :group 'pulsar-faces)
  (pulsar-global-mode)
  :custom
  (pulsar-face 'pulsar-nord)
  )

(use-package which-key
  :commands which-key-mode
  :diminish which-key-mode
  :config
  (which-key-mode))

(use-package expreg
  :defer t
  :bind ("M-m" . expreg-expand))

(use-package vundo :defer t) ;; undo tree

(use-package puni ;; better paranthesis handling
  :commands puni-global-mode
  :defer t
  :init
  (puni-global-mode))

(use-package avy
  :defer t
  :bind
  ("M-i" . avy-goto-char-2)
  :custom
  (avy-background t))

(use-package consult
  :defer t
  :bind
  ("C-x b"   . consult-buffer)     ;; orig. switch-to-buffer
  ("M-y"     . consult-yank-pop)   ;; orig. yank-pop
  ("M-g M-g" . consult-goto-line)  ;; orig. goto-line
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
  :commands vertico-mode
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

(use-package marginalia
  :commands marginalia-mode
  :defer t
  :init (marginalia-mode))

(use-package crux
  :defer t
  :bind
  ("C-c M-e" . crux-find-user-init-file)
  ("C-c C-w" . crux-transpose-windows)
  ("C-a"     . crux-move-beginning-of-line))

(use-package magit
  :defer t
  :bind (("C-M-g" . magit-status)))

(use-package nerd-icons-corfu
  :commands nerd-icons-corfu-formatter
  :defines corfu-margin-formatters)

(use-package corfu
  :commands global-corfu-mode
  :custom
  (corfu-cycle t)
  (corfu-auto t)
  (corfu-auto-delay  1)
  (corfu-auto-prefix 3)
  (corfu-separator ?_)
  :init
  (global-corfu-mode)
  :config
  (add-to-list 'corfu-margin-formatters #'nerd-icons-corfu-formatter))

(use-package cape :defer t)

(use-package orderless
  :init
  (setq completion-styles '(orderless partial-completion basic)
        completion-category-defaults nil
        completion-category-overrides nil))

(use-package treesit-auto :defer t
  :ensure t
  :functions global-treesit-auto-mode
  :mode
  ("\\.rs\\'" . rust-ts-mode)
  ("\\.ts\\'" . typescript-ts-mode)
  ("\\.go\\'" . go-ts-mode)
  ("\\.cs\\'" . csharp-ts-mode)
  ("\\.cpp\\'" . c++-ts-mode)
  ("\\.h\\'" . c++-ts-mode)
  ("\\.hpp\\'" . c++-ts-mode)
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

(use-package ag :defer t)

(use-package exec-path-from-shell
  :commands exec-path-from-shell-initialize
  :custom
  (exec-path-from-shell-arguments nil)
  :config
  (exec-path-from-shell-initialize))

(use-package flycheck
  :defer t
  :commands global-flycheck-mode
  :diminish
  :init (global-flycheck-mode))

(use-package lsp-mode
  :commands (lsp lsp-deferred lsp-format-buffer lsp-organize-imports orderless-dispatch-flex-first cape-capf-buster lsp-completion-at-point)
  :defines lsp-file-watch-ignored-directories
  :diminish lsp-lens-mode
  :bind-keymap
  ("C-c l" . lsp-command-map)
  :custom
  (lsp-lens-enable nil)
  (lsp-idle-delay 0.500)
  (lsp-modeline-code-actions-enable t)
  (lsp-modeline-diagnostics-enable t)
  (lsp-csharp-omnisharp-roslyn-binary-path "OmniSharp")
  (lsp-completion-provider :none) ;; we use Corfu!
  (lsp-eldoc-render-all t)
  :init
  (defun orderless-dispatch-flex-first (_pattern index _total)
    (and (eq index 0) 'orderless-flex))

  ;; Configure the first word as flex filtered.
  (add-hook 'orderless-style-dispatchers #'orderless-dispatch-flex-first nil 'local)

  (defun lsp-mode-setup-completion ()
    (setf (alist-get 'styles (alist-get 'lsp-capf completion-category-defaults))
          '(orderless)))

  ;; Optionally configure the cape-capf-buster.
  (setq-local completion-at-point-functions (list (cape-capf-buster #'lsp-completion-at-point)))
  :config
  (add-to-list 'lsp-file-watch-ignored-directories "[/\\\\]\\Temp\\'")
  (add-to-list 'lsp-file-watch-ignored-directories "[/\\\\]\\Logs\\'")
  (defun lsp-cleanup ()
    (lsp-format-buffer)
    (lsp-organize-imports)
    (whitespace-cleanup))
  :hook
  (lsp-completion-mode . lsp-mode-setup-completion)
  (lsp-mode . lsp-enable-which-key-integration)
  (before-save . lsp-cleanup)
  (c++-ts-mode . lsp-deferred)
  (rust-ts-mode . lsp-deferred)
  (go-ts-mode . lsp-deferred)
  (typescript-ts-mode . lsp-deferred)
  (csharp-ts-mode . lsp-deferred))

(use-package lsp-ui :commands lsp-ui-mode
  :custom
  (lsp-ui-doc-enable t)
  (lsp-ui-sideline-diagnostic-max-lines 4)
  (lsp-ui-doc-show-with-mouse nil)
  (lsp-ui-doc-position 'bottom)
  (lsp-ui-doc-show-with-cursor t)
  (lsp-eldoc-enable-hover nil)
  )

(use-package rust-ts-mode
  :defer t
  :custom
  (lsp-rust-analyzer-cargo-watch-command "clippy")
  (lsp-rust-analyzer-exclude-dirs ["Temp/**"])
  )

(use-package typescript-ts-mode
  :defer t
  :custom
  (lsp-javascript-preferences-import-module-specifier :relative)
  (typescript-indent-level 2)
  (typescript-ts-mode-indent-offset 2))

(use-package nix-mode)
(use-package eat)
(use-package hcl-mode)
(use-package jinja2-mode)

(use-package envrc
  :commands envrc-global-mode
  :config (envrc-global-mode))

(use-package nix-mode
  :hook (nix-mode . lsp-deferred)
  :ensure t)

(provide 'init)
;;; init.el ends here
