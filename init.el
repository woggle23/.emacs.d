;; ----------------------
;; Better dead than smeg.
;; ----------------------

;; Add .emacs.d to load-path
(setq dotfiles-dir (file-name-directory
                    (or (buffer-file-name) load-file-name)))
(add-to-list 'load-path dotfiles-dir)

;; speedbar config
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(custom-enabled-themes (quote (sanityinc-solarized-dark)))
 '(custom-safe-themes (quote ("4aee8551b53a43a883cb0b7f3255d6859d766b6c5e14bcb01bed572fcbef4328" default)))
 '(speedbar-frame-parameters (quote ((minibuffer) (width . 33) (border-width . 0) (menu-bar-lines . 0) (tool-bar-lines . 0) (unsplittable . t) (left-fringe . 0))))
 '(speedbar-frame-plist (quote (minibuffer nil width 30 border-width 0 internal-border-width 0 unsplittable t default-toolbar-visible-p nil has-modeline-p nil menubar-visible-p nil default-gutter-visible-p nil)))
 '(speedbar-indentation-width 2)
 '(speedbar-show-unknown-files t)
 '(speedbar-use-images nil))

(defun set-frame-size-according-to-resolution ()
  (interactive)
  (if window-system
  (progn
    ;; use 120 char wide window for largeish displays
    ;; and smaller 80 column windows for smaller displays
    ;; pick whatever numbers make sense for you
    (if (> (x-display-pixel-width) 1280)
           (add-to-list 'default-frame-alist (cons 'width 121))
           (add-to-list 'default-frame-alist (cons 'width 81)))
    ;; for the height, subtract a couple hundred pixels
    ;; from the screen height (for panels, menubars and
    ;; whatnot), then divide by the height of a char to
    ;; get the height we want
    (add-to-list 'default-frame-alist
         (cons 'height (/ (- (x-display-pixel-height) 10)
                             (frame-char-height)))))))

;;(set-frame-size-according-to-resolution)

;; ELPA
(setq package-user-dir (concat dotfiles-dir "elpa"))
(require 'package)
(dolist (source '(("melpa" . "http://melpa.milkbox.net/packages/")
                  ("marmalade" . "http://marmalade-repo.org/packages/")
                  ("elpa" . "http://tromey.com/elpa/")))
  (add-to-list 'package-archives source t))
(package-initialize)

;; Sort out the $PATH for OSX
(require 'exec-path-from-shell)
(when (memq window-system '(mac ns))
  (exec-path-from-shell-initialize))

(defun cider-reset-app ()
  (interactive)
  (save-some-buffers)
  (cider-switch-to-current-repl-buffer)
  (goto-char (point-max))
  (insert (concat "("
  		  (let (line ns)
  		    (setq line (with-temp-buffer
  				 (insert-file-contents
  				  (concat (expand-file-name ".") "/dev/user.clj"))
  				 (buffer-string)))
  		    (setq ns (substring line (+ 1 (string-match "\\[" line))
  					(string-match " :refer" line)))
  		    ns)
  		  "/reset-dev)"))
  (cider-repl-return))

(defun cider-reset-cljs ()
  (interactive)
  (save-some-buffers)
  (cider-switch-to-current-repl-buffer)
  (goto-char (point-max))
  (insert (concat ":cljs/quit"))
  (cider-repl-return)
  (sit-for 1)
  (goto-char (point-max))
  (insert (concat "(create-cljs-repl)"))
  (cider-repl-return))

;; Key Bindings
(global-set-key (kbd "<C-f11>") 'cider-jack-in)
(global-set-key (kbd "<f11>") 'ns-toggle-fullscreen)
(global-set-key (kbd "C-x g") 'magit-status)
(global-set-key "\C-x\C-b" 'buffer-menu)
(global-set-key (kbd "C-c C-f") 'rgrep)
(global-set-key (kbd "<M-f11>") 'speedbar-get-focus)
;; current line ready for paste
(global-set-key "\C-c\C-w" "\C-a\C- \C-n\M-w")
;; duplicate current line
(global-set-key "\C-c\C-d" "\C-a\C- \C-n\M-w\C-y")
(global-set-key "\C-xnr" 'cider-reset-app)
(global-set-key "\C-xcr" 'cider-reset-cljs)
(global-set-key "\C-xns" 'cider-insert-ns-form-in-repl)

(setq backup-inhibited 'anyvaluebutnil )

;; C-c l/r to restore windows
(winner-mode 1)

(delete-selection-mode t)

;; add line numbers
(global-linum-mode t)

;; auto-complete-mode
(global-auto-complete-mode t)

(setq comment-start "#")
;; undo-tree
(require 'undo-tree)
(global-undo-tree-mode)

;; Shows the kill ring
(require 'browse-kill-ring)
(browse-kill-ring-default-keybindings)

;; expand region
(require 'expand-region)
(global-set-key (kbd "C-'") 'er/expand-region)

;; Minibuffer completion
(ido-mode)
(setq ido-enable-flex-matching t)

;; Parenthesis
(show-paren-mode)
;;(global-rainbow-delimiters-mode)

;; hl-sexp
(require 'hl-sexp)

(add-hook 'clojure-mode-hook 'hl-sexp-mode)
(add-hook 'lisp-mode-hook 'hl-sexp-mode)
(add-hook 'emacs-lisp-mode-hook 'hl-sexp-mode)

;; highlight symbols
(add-hook 'clojure-mode-hook 'idle-highlight-mode)
(add-hook 'emacs-lisp-mode 'idle-highlight-mode)

;; Paredit
(require 'paredit)
(add-hook 'lisp-mode-hook 'paredit-mode)
(add-hook 'emacs-lisp-mode-hook 'paredit-mode)
(add-hook 'clojure-mode-hook 'paredit-mode)
(add-hook 'cider-repl-mode-hook 'enable-paredit-mode)

(setq cider-repl-history-file "~/.emacs.d/nrepl-history")
;;(setq nrepl-use-pretty-printing t)

;; Markdown mode
(autoload 'markdown-mode "markdown-mode.el" "Major mode for editing Markdown files" t)
(setq auto-mode-alist (cons '("\\.markdown" . markdown-mode) auto-mode-alist))
(setq auto-mode-alist (cons '("\\.md" . markdown-mode) auto-mode-alist))

;; Clojure mode for ClojureScript
(add-to-list 'auto-mode-alist '("\.cljs$" . clojure-mode))
(add-to-list 'auto-mode-alist '("\.cljc$" . clojure-mode))

(require 'mustache-mode)
(add-to-list 'auto-mode-alist '("\.mustache$" . mustache-mode))

;; Dont like trailing whitespaces
(add-hook 'before-save-hook 'delete-trailing-whitespace)

(dolist (file '("jp-ace-jump-mode.el"
		"jp-multiple-cursors.el"
		"fb-cider.el"
		"fb-cljrefactor.el"
		"jp-html"
		"jp-lnf.el"
		"mf-js-mode.el"))
  (load (concat dotfiles-dir file)))

(global-auto-revert-mode t)
(put 'erase-buffer 'disabled nil)
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
