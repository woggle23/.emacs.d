(defun read-lines (filePath)
  "Return a list of lines of a file at filePath."
  (with-temp-buffer
    (insert-file-contents filePath)
    (split-string (buffer-string) "\n" t)))

(defun match-strings-all (&optional string)
  "Return the list of all expressions matched in last search.
  <string> is optionally what was given to `string-match'."
    (let ((n-matches (1- (/ (length (match-data)) 2))))
      (mapcar (lambda (i) (match-string i string))
              (number-sequence 0 n-matches))))

(defun find-in-file (puppeteer-dir f)
  "Read/Return ip and nrepl-port in yml file provided"
  (let ((result ()))
    (push (replace-regexp-in-string ".yml" "" f) result)
    (dolist (line (read-lines (concat puppeteer-dir f)))
	   (when
	       (save-match-data
		 (and (or (string-match "ip: \\(.+\\)$" line) (string-match "nrepl-port: \\(.+\\)$" line))
		      (setq m (match-string 1 line))
		      (push m result)))))
    (if (= (length result) 3) (reverse result) nil)))

(defun find-nrepl-targets (default-dir)
  "Read all ips and nrepl params from matching yml files in given dir"
  (let (target-nodes results match-pattern)
    (setq match-pattern (if (getenv "PUPPETEER_MATCH_PATTERN") (getenv "PUPPETEER_MATCH_PATTERN") "*")
	  target-nodes (directory-files default-dir (not 'absolute)
					match-pattern))
    (dolist (f target-nodes)
      (push (find-in-file default-dir f) results))
    (delq nil results)))

;; complete with Control-tab
(global-set-key [C-tab] 'cider-repl-indent-and-complete-symbol)

;; cider result with nice prefix
(setq cider-repl-result-prefix "=> ")

;; nicer font lock in repl
(setq cider-repl-use-clojure-font-lock t)

;; never ending history
(setq cider-repl-wrap-history t)

;; show port on remote repl
;;(setq nrepl-buffer-name-show-port t)

;; looong history
(setq cider-repl-history-size 3000)

(if (getenv "PUPPETEER_NODES")
    (setq cider-known-endpoints (find-nrepl-targets (getenv "PUPPETEER_NODES"))))

(global-set-key (kbd "C-c n c") 'nrepl-close)
;; closes *all* REPLs
(global-set-key (kbd "C-c n q") 'cider-quit)

(global-set-key (kbd "C-c k e") 'cider-connect)
