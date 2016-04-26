(defun find-nrepl-targets (file-path)
  (mapcar 'list
	  (with-temp-buffer (insert-file-contents file-path)
			    (split-string (buffer-string) "\n" t))))

;; complete with Control-tab
(global-set-key [C-tab] 'cider-repl-indent-and-complete-symbol)

;; cider result with nice prefix
(setq cider-repl-result-prefix "=> ")

;; nicer font lock in repl
(setq cider-repl-use-clojure-font-lock t)

;; never ending history
(setq cider-repl-wrap-history t)

(setq cider-known-endpoints (find-nrepl-targets (concat (file-name-directory (or load-file-name buffer-file-name)) "cider-nodes.el")))

(global-set-key (kbd "C-c n c") 'nrepl-close)
;; closes *all* REPLs
(global-set-key (kbd "C-c n q") 'cider-quit)

(global-set-key (kbd "C-c k e") 'cider-connect)
