;; package manager
(require 'package)
(setq package-enable-at-startup nil)
(setq package-archives '(("gnu" . "https://mirrors.sjtug.sjtu.edu.cn/emacs-elpa/gnu/")
			 ("melpa" . "https://mirrors.sjtug.sjtu.edu.cn/emacs-elpa/melpa/")))
(package-initialize)
;; install and set use-package
(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))
(require 'use-package-ensure)
(setq use-package-always-ensure t)
(setq use-package-always-defer t)

(use-package auto-package-update
  :defer nil
  :config
  (setq auto-package-update-delete-old-versions t
	auto-package-update-hide-results t)
  (auto-package-update-maybe))

;; auto complete framework
(use-package company
  :hook
  ((text-mode prog-mode) . company-mode))

(use-package orderless
  :init
  (setq completion-styles '(orderless)
        completion-category-defaults nil
        completion-category-overrides '((file (styles partial-completion)))))

(use-package savehist
  :init
  (savehist-mode))

(use-package vertico
  :init
  (vertico-mode))

;; ebook reader
(use-package nov			; epub reader
  :mode ("\\.epub\\'" . nov-mode))
(use-package pdf-tools			; pdf  reader, replace pdf view
  :init
  (pdf-loader-install))

;; files
(use-package dired
  :ensure nil
  :config
  (setq dired-dwim-target t ;; the defalt target of file operating become the most recently window with a Dired buffer
	dired-auto-revert-buffer t
	dired-listing-switches "-alh --group-directories-first")
  (put 'dired-find-alternate-file 'disabled nil)
  (define-key dired-mode-map (kbd "RET") 'dired-find-alternate-file)
  (define-key dired-mode-map (kbd "^") (lambda() (interactive) (find-alternate-file ".."))))

(setq find-file-visit-truename t) 	;  make find-file follow soft link

;; interface setting
(setq inhibit-startup-message t)
(tool-bar-mode -1) ;; hide toolbar
(menu-bar-mode -1) ;; hide menu bar
(fset 'yes-or-no-p 'y-or-n-p)
(add-to-list 'default-frame-alist '(font . "Source Han Serif CN-20")) ; set the default font
(global-visual-line-mode 1)

(use-package solarized-theme
  :defer nil
  :config
  (load-theme 'solarized-dark t))

;; language environment 
(set-language-environment "UTF-8")
(set-default buffer-file-coding-system 'utf-8-unix)
(set-default-coding-systems 'utf-8-unix)
(prefer-coding-system 'cp950)
(prefer-coding-system 'gb2312)
(prefer-coding-system 'cp936)
;; (prefer-coding-system 'gb18030)
;; (prefer-coding-system 'utf-16le-with-signature)
(prefer-coding-system 'utf-16)
(prefer-coding-system 'utf-8-dos)
(prefer-coding-system 'utf-8-unix)

(use-package rime
  :init  (setq default-input-method "rime"))

;; Navigation
(use-package ace-window
  :bind ("C-x o" . ace-window))

(use-package ibuffer
  :init
  (defalias 'list-buffers 'ibuffer))

(use-package avy
  :bind ("C-;" . avy-goto-char-timer))

;;
;; org mode ecosystem
;; 
(use-package org
  :config
  (setq org-directory "~/org"
	org-startup-folded t            ; overview
        org-startup-indented t          ; auto startup org-indent-mode
        org-id-link-to-org-use-id t ; org-sort-line awalys generate id link
	org-return-follows-link t
        org-src-fontify-natively t  ; code highlight in code highlight
	org-log-into-drawer t
	org-agenda-files '("~/netdisk/dropbox/gtd.org")
	org-agenda-custom-commands '(("ci" tags "CATEGORY=\"inbox\"&LEVEL=2")
				     ("ct" tags "CATEGORY=\"todo\"&LEVEL=2"))
	org-capture-templates '(("i" "inbox items" entry (file+headline "~/netdisk/dropbox/gtd.org" "inbox") "* %?"))
	)
  :bind (("C-c o c" . org-capture)
	 ("C-c o a" . org-agenda)
	 ("C-c o s" . org-store-link)
	 :map org-mode-map
	 ("C-c o i" . org-id-get-create))
  )

(use-package org-noter) ; org-pdftools use this package to create org link

(use-package org-pomodoro)

(use-package org-roam
  :init (setq org-roam-v2-ack t) 	; disable warning 
  :config
  (setq org-roam-directory "~/org"
	org-roam-capture-templates '(("f" "file node" plain "%?" :if-new (file+head "${slug}.org" "#+title: ${title}"))))
  (org-roam-setup)
  ;; showing-node-hierarchy when finding node
  ;; https://github.com/org-roam/org-roam/wiki/Hitchhiker's-Rough-Guide-to-Org-roam-V2#showing-node-hierarchy
  (cl-defmethod org-roam-node-filetitle ((node org-roam-node))
  "Return the file TITLE for the node."
  (org-roam-get-keyword "TITLE" (org-roam-node-file node)))
  (cl-defmethod org-roam-node-hierarchy ((node org-roam-node))
  "Return the hierarchy for the node."
  (let ((title (org-roam-node-title node))
        (olp (org-roam-node-olp node))
        (level (org-roam-node-level node))
        (filetitle (org-roam-node-filetitle node)))
    (concat
     (if (> level 0) (concat filetitle " > "))
     (if (> level 1) (concat (string-join olp " > ") " > "))
     title))
  )
  (setq org-roam-node-display-template "${hierarchy:*}${tags:20}")
  
  :bind (("C-c r l" . org-roam-buffer-toggle)
             ("C-c r f" . org-roam-node-find)
             ("C-c r g" . org-roam-graph)
             ("C-c r c" . org-roam-capture)
	     :map org-mode-map
             ("C-c r i" . org-roam-node-insert)
	     ("C-c r r" . org-roam-ref-add)
	     ("C-c r a" . org-roam-alias-add)))

;; 
;; programing environment
;;
(use-package elec-pair
  :hook (prog-mode . electric-pair-local-mode))
(use-package rainbow-delimiters
  :hook
  (prog-mode . rainbow-delimiters-mode))

(use-package yasnippet
  :hook (lsp-mode . yas-minor-mode)
  :hook (yas-minor-mode . (lambda () (add-to-list 'company-backends 'company-yasnippet))))

(use-package lsp-mode
  :init
  (setq lsp-keymap-prefix "C-c l")
  :config
  (dap-mode 1)
  (dap-ui-mode 1)
  (add-to-list 'lsp-language-id-configuration '(".*-k8s\\.yaml$" . "spring-boot-properties-yaml"))
  :commands (lsp lsp-deferred))

(use-package dap-mode
  :commands dap-mode)

;; python 
(use-package lsp-pyright
  :hook (python-mode . (lambda () (require 'lsp-pyright) (lsp-deferred)))
  :config
  (require 'dap-python)
  (setq dap-python-debugger "debugpy"))

;; kubernetes
(use-package k8s-mode
  :mode ("\\-k8s.yaml" . k8s-mode))

;; yaml
(use-package yaml-mode
  :hook (yaml-mode . lsp-deferred))

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(package-selected-packages
   '(orderless vertico k8s-mode use-package solarized-theme selectrum-prescient rime rainbow-delimiters pdf-tools org-roam org-pomodoro org-noter nov lsp-pyright dap-mode company auto-package-update))
 '(warning-suppress-types '((comp) (comp))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
