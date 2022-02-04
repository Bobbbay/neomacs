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
  (load-theme 'doom-tokyo-night t)
  (doom-themes-visual-bell-config))

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
(use-package evil :config (evil-mode 1))

;; Evil collection adds evil support to applications that it doesn't ship with.
(use-package evil-collection
  :after evil
  :config (evil-collection-init))
