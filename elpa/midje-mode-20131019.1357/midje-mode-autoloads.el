;;; midje-mode-autoloads.el --- automatically extracted autoloads
;;
;;; Code:


;;;### (autoloads (midje-mode) "midje-mode" "midje-mode.el" (21258
;;;;;;  29655))
;;; Generated autoloads from midje-mode.el

(autoload 'midje-mode "midje-mode" "\
A minor mode for running Midje tests when using cider.

\\{midje-mode-map}

\(fn &optional ARG)" t nil)

(defun midje-mode-maybe-enable nil "\
Enable midje-mode if the current buffer contains a \"midje.\" string." (let ((regexp "midje\\.")) (save-excursion (when (or (re-search-backward regexp nil t) (re-search-forward regexp nil t)) (midje-mode t)))))

(add-hook 'clojure-mode-hook 'midje-mode-maybe-enable)

;;;***

;;;### (autoloads nil nil ("clojure-jump-to-file.el" "midje-mode-pkg.el"
;;;;;;  "midje-mode-praise.el") (21258 29655 444017))

;;;***

(provide 'midje-mode-autoloads)
;; Local Variables:
;; version-control: never
;; no-byte-compile: t
;; no-update-autoloads: t
;; coding: utf-8
;; End:
;;; midje-mode-autoloads.el ends here
