;; js2-mode and smart-tab-mode installed
(require 'js2-mode)

;;(add-hook 'js2-mode-hook 'js2-minor-mode)
;;(smart-tabs-advice js2-indent-line js2-basic-offset)
(add-to-list 'auto-mode-alist '("\\.js\\'" . js2-mode))
(message "added js2-mode")

(define-key js-mode-map "{" 'paredit-open-curly)
(define-key js-mode-map "}" 'paredit-close-curly-and-newline)

(defun paredit-nonlisp ()
  "Turn on paredit mode for non-lisps."
  (interactive)
  (set (make-local-variable 'paredit-space-for-delimiter-predicates)
       '((lambda (endp delimiter) nil)))
  (paredit-mode 1))

(add-hook 'js2-mode-hook 'paredit-nonlisp)
