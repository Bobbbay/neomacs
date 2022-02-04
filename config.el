;; Use-package is already installed in our global environment by Nix, but we
;; still need to load it here.
(require 'use-package)

;; The same goes for general.
(require 'general)

;; Now that we're ready, we can load our configurations.

;;; General.el configuration
;;; Before we start, we need to configure General for keymapping. Let's do so
;;; now.

;; Normal-mode map with a prefix of SPC.
(general-create-definer prefixed-nmap
  :states 'normal
  :prefix "SPC")

;;; Completion
;;; This configures Neomacs' completion. It encompasses completion frameworks
;;; for the minibuffer, text, and more.

;; Vertico is a minimal, fast completion package for Emacs. It's even cleaner
;; thank Ido mode!
(use-package vertico :config (vertico-mode 1))

;; Vertico is great, but its completion isn't the best. Orderless adds fuzzy
;; finding in searches with Vertico.
;; TODO: There seems to be a lot of config available for Oderless. Look into
;; it, and decide what to us (if anything).
(use-package orderless :custom (completion-styles '(orderless)))

;; Vertico needs to save history, too! This is built into Emacs, so we
;; :ensure nil in order to not confuse Nix (who will try to install it).
(use-package savehist :ensure nil :init (savehist-mode))

;; On another vein, which-key will show us which keys are bound and available
;; for use on the next selection.
(use-package which-key
  :config
  (which-key-mode)
  (which-key-setup-side-window-right-bottom)
  (which-key-setup-minibuffer))

;;; Themes

;; Doom themes is an all-encompassing package for themes. We load tokyo-night,
;; my favourite.
(use-package doom-themes
  :config
  (load-theme 'doom-tokyo-night t))

(prefixed-nmap
  :prefix "t"
  "l" 'load-theme)

;; Doom modeline is a nice and very customizable modeline for us.
(use-package doom-modeline
  :config (doom-modeline-mode 1)
  :custom (doom-modeline-hud t))

;; Yascroll is a cleaner scrollbar.
;; TODO: Look into alternatives, or customize this.
(use-package yascroll
  :config (yascroll-bar-mode 1))

;;; Navigation

;; Evil mode speaks for itself.
(use-package evil
  :config (evil-mode 1)
  :init (setq evil-want-keybinding nil))

;; Evil collection adds evil support to applications that it doesn't ship with.
(use-package evil-collection
  :after evil
  :config (evil-collection-init))

;;; Imports
;;; Anything under this line was imported from my previous config and is slowly
;;; being ported to this newer, cleaner config.

;; Leader key
(general-create-definer leader
  :prefix "SPC")

(leader
  :keymaps 'normal
  ;; Common
  "TAB" 'centaur-tabs-forward
  "q"   'centaur-tabs-backward
  "g"   'centaur-tabs-counsel-switch-group
  "n"   'centaur-tabs--create-new-tab

  ;; Programming-specific
  "f"   'format-all-buffer
  "d b" 'dap-breakpoint-toggle

  "l d" 'lsp-find-definition
  "l r" 'lsp-find-references
  "l o" 'lsp-describe-thing-at-point
  "l f" 'lsp-execute-code-action
  "l n" 'flymake-goto-next-error
  "l p" 'flymake-goto-prev-error
  "l d" 'flymake-show-diagnostic

  ;; Projectile
  "p"   '(:keymap projectile-command-map :wk "projectile prefix" :package projectile)
  "SPC" 'projectile-find-file
  "P"   'projectile-add-known-project

  ;; Bookmarks
  "b s" 'bookmark-set
  "b o" 'bookmark-jump
  "b l" 'list-bookmarks)

;; The best editor is...
(use-package evil
  :ensure t
  ;; For evil-collection
  :init (setq evil-want-keybinding nil)
  :config (evil-mode 1))

;; Fixes evil-mode
(use-package evil-collection
  :after evil
  :ensure t
  :config (evil-collection-init))

;; Creating custom cheat sheets
(use-package cheatsheet
  :ensure t
  :commands (cheatsheet-show)
  :config
  (cheatsheet-add-group 'Common
                        '(:key "C-x C-c" :description "Leave Emacs?!")
                        '(:key "SPC b s" :description "Set an Emacs bookmark")
                        '(:key "SPC b o" :description "Open an Emacs bookmark")
                        '(:key "SPC b l" :description "List all Emacs bookmarks"))

  (cheatsheet-add-group 'Navigation
                        '(:key "SPC TAB" :description "Forward tab")
                        '(:key "SPC q"   :description "Backwards tab")
                        '(:key "SPC g"   :description "Switch tab group")
                        '(:key "SPC n"   :description "New tab"))

  (cheatsheet-add-group 'Programming
                        '(:key "SPC f"   :description "Format current buffer")
                        '(:key "SPC d b" :description "Toggle DAP breakpoint")
                        '(:key "SPC l d" :description "LSP jump to definition"))

  (cheatsheet-add-group 'Projectile
                        '(:key "SPC SPC" :description "Find file in project"))

  :bind ("C-." . cheatsheet-show))

(use-package fira-code-mode
  :ensure t
  :config
  (set-face-attribute 'default nil :font "Fira Code" :height 90)
  (global-fira-code-mode 1))

;; Gotta do M-x fira-code-mode-install-fonts

(use-package projectile
  :ensure t
  :config
  (projectile-mode 1))

;; Remove the top bars :)
(menu-bar-mode -1)
(tool-bar-mode -1)

;; A custom scrollbar
(use-package yascroll
  :ensure t
  :config
  (global-yascroll-bar-mode 1)
  (toggle-scroll-bar -1))

;; Relative numbers
(use-package linum-relative
  :ensure t
  :hook (prog-mode . linum-relative-mode))

;; Icons!
(use-package all-the-icons
  :ensure t
  :if (display-graphic-p))

;; You need to `all-the-icons-install-fonts`.

;; Dashboard
(use-package dashboard
  :ensure t
  :config
  (dashboard-setup-startup-hook)
  (setq initial-buffer-choice (lambda () (get-buffer "*dashboard*"))
        dashboard-startup-banner 3
        dashboard-center-content t))

;; Tabs
(use-package centaur-tabs
  :ensure t
  :demand ;; If we don't demand, the tabs won't display!
  :init
  (setq centaur-tabs-style "bar"
        centaur-tabs-set-modified-marker t
        centaur-tabs-modified-marker "•"
        centaur-tabs-set-icons t
        centaur-tabs-gray-out-icons 'buffer
        centaur-tabs-cycle-scope 'tabs
        centaur-tabs-show-navigation-buttons t
        centaur-tabs-show-count t
        uniquify-separator "/"
        uniquify-buffer-name-style 'forward)
  :config
  (centaur-tabs-mode 1)
  (centaur-tabs-change-fonts "Fira Code" 0.9)
  (centaur-tabs-headline-match))

;; Modeline
(use-package doom-modeline
  :ensure t
  :init
  (setq doom-modeline-height 15)
  (setq doom-modeline-enable-word-count t)
  (setq doom-modeline-github t)
  (setq column-number-mode t)

  ;; Make the fonts smaller
  (custom-set-faces
   '(mode-line ((t (:family "Fira Code" :height 0.9))))
   '(mode-line-inactive ((t (:family "Fira Code" :height 0.9)))))
  :config (doom-modeline-mode 1))

(use-package minions
  :ensure t
  :config (minions-mode 1))

;; Helps configuration editing :)
(use-package free-keys :ensure t)

(use-package which-key
  :ensure t
  :config
  (define-globalized-minor-mode which-key-global-mode which-key-mode
    (lambda () (which-key-mode 1)))
  
  (which-key-global-mode 1))

(use-package company
  :ensure t
  :config
  (setq company-idle-delay 0
	company-show-numbers t)
  :hook (after-init . global-company-mode))

(use-package yasnippet
  :ensure t
  :after company
  :config
  (yas-global-mode 1)

  ;; Add yasnippet support for all company backends
  ;; https://github.com/syl20bnr/spacemacs/pull/179
  (defvar company-mode/enable-yas t
    "Enable yasnippet for all backends.")

  (defun company-mode/backend-with-yas (backend)
    (if (or (not company-mode/enable-yas) (and (listp backend) (member 'company-yasnippet backend)))
        backend
      (append (if (consp backend) backend (list backend))
              '(:with company-yasnippet))))

  (setq company-backends (mapcar #'company-mode/backend-with-yas company-backends)))

(use-package yasnippet-snippets
  :ensure t
  :after yasnippet)

(use-package crux
  :ensure t)

(use-package pdf-tools
  :ensure t
  :magic ("%PDF" . pdf-view-mode)
  :config
  (pdf-tools-install :no-query))

;;; Programming-specific configuration

;; LSP
(use-package lsp-mode
  :ensure t
  :init (setq lsp-keymap-prefix "C-c l")
  :hook (rustic-mode . lsp))

(use-package lsp-ui
  :after lsp-mode
  :ensure t)

;; Rust integration
(use-package rustic
  :after lsp-mode
  :ensure t
  :config (setq lsp-rust-analyzer-server-display-inlay-hints t))

;; Haskell integration
(use-package haskell-mode
  :after lsp-mode
  :ensure t)

(use-package shakespeare-mode
  :ensure t)

;; Racket integration
(use-package racket-mode
  :ensure t)

(use-package prop-menu
  :ensure t
  :config)

(use-package dap-mode
  :after lsp-mode
  :ensure t
  ;; Rust debug configuration based off of gagbo.net/post/dap-mode-rust
  :config
  (setq dap-cpptools-extension-version "1.5.1")

  (with-eval-after-load 'lsp-rust (require 'dap-cpptools))

  (with-eval-after-load 'dap-cpptools
    ;; This is a template for Rust debugging. It's used for new projects, but
    ;; is edited before running.

    ;; Run M-x dap-cpptools-setup, please!
    (dap-register-debug-template "Rust::CppTools Run Configuration" (list :type "cppdbg"
                                                                          :request "launch"
                                                                          :name "Rust::Run"
                                                                          :MIMode "gdb"
                                                                          :miDebuggerPath "rust-gdb"
                                                                          :environment []
                                                                          :program "${workspaceFolder}/target/debug/hello / replace with binary"
                                                                          :cwd "${workspaceFolder}"
                                                                          :console "external"
                                                                          :dap-compilation "cargo build"
                                                                          :dap-compilation-dir "${workspaceFolder}")))

  (with-eval-after-load 'dap-mode
    (setq dap-default-terminal-kind "integrated")
    (dap-auto-configure-mode +1)))

(use-package apheleia
  :ensure t
  :config (apheleia-global-mode 1))

(use-package aggressive-indent
  :ensure t
  :config (global-aggressive-indent-mode 1))

(use-package smartparens
  :ensure t
  :config
  (smartparens-global-mode 1)
  (electric-pair-mode 1))

(use-package company-tabnine
  :after company
  :ensure t
  :config (add-to-list 'company-backends #'company-tabnine))

(use-package focus
  :ensure t
  :config
  (add-to-list 'focus-mode-to-thing '(rustic-mode . lsp-folding-range)))

(use-package magit
  :ensure t)

;; Definition from https://github.com/suonlight/multi-vterm#for-evil-users
(use-package multi-vterm
  :ensure t
  :config
  (add-hook 'vterm-mode-hook
      (lambda (
  )      (setq-local evil-insert-state-cursor 'bo
  )      (evil-insert-stat)))
  (define-key vterm-mode-map [return]                      #'vterm-send-return)

  (setq vterm-keymap-exceptions nil)
  (evil-define-key 'insert vterm-mode-map (kbd "C-e")      #'vterm--self-insert)
  (evil-define-key 'insert vterm-mode-map (kbd "C-f")      #'vterm--self-insert)
  (evil-define-key 'insert vterm-mode-map (kbd "C-a")      #'vterm--self-insert)
  (evil-define-key 'insert vterm-mode-map (kbd "C-v")      #'vterm--self-insert)
  (evil-define-key 'insert vterm-mode-map (kbd "C-b")      #'vterm--self-insert)
  (evil-define-key 'insert vterm-mode-map (kbd "C-w")      #'vterm--self-insert)
  (evil-define-key 'insert vterm-mode-map (kbd "C-u")      #'vterm--self-insert)
  (evil-define-key 'insert vterm-mode-map (kbd "C-d")      #'vterm--self-insert)
  (evil-define-key 'insert vterm-mode-map (kbd "C-n")      #'vterm--self-insert)
  (evil-define-key 'insert vterm-mode-map (kbd "C-m")      #'vterm--self-insert)
  (evil-define-key 'insert vterm-mode-map (kbd "C-p")      #'vterm--self-insert)
  (evil-define-key 'insert vterm-mode-map (kbd "C-j")      #'vterm--self-insert)
  (evil-define-key 'insert vterm-mode-map (kbd "C-k")      #'vterm--self-insert)
  (evil-define-key 'insert vterm-mode-map (kbd "C-r")      #'vterm--self-insert)
  (evil-define-key 'insert vterm-mode-map (kbd "C-t")      #'vterm--self-insert)
  (evil-define-key 'insert vterm-mode-map (kbd "C-g")      #'vterm--self-insert)
  (evil-define-key 'insert vterm-mode-map (kbd "C-c")      #'vterm--self-insert)
  (evil-define-key 'insert vterm-mode-map (kbd "C-SPC")    #'vterm--self-insert)
  (evil-define-key 'normal vterm-mode-map (kbd "C-d")      #'vterm--self-insert)
  (evil-define-key 'normal vterm-mode-map (kbd ",c")       #'multi-vterm)
  (evil-define-key 'normal vterm-mode-map (kbd ",n")       #'multi-vterm-next)
  (evil-define-key 'normal vterm-mode-map (kbd ",p")       #'multi-vterm-prev)
  (evil-define-key 'normal vterm-mode-map (kbd "i")        #'evil-insert-resume)
  (evil-define-key 'normal vterm-mode-map (kbd "o")        #'evil-insert-resume)
  (evil-define-key 'normal vterm-mode-map (kbd "<return>") #'evil-insert-resume))

;; Window management
(use-package e2wm :ensure t)
