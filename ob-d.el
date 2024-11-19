(defcustom org-babel-d-command "dmd"
  "Command that evaluates D.")

(defun org-babel-expand-body:d (body params)
  ""
  (let-alist params
    (format "void main() {\n%s\n}"
	    body)))

(defun org-babel-execute:d (body params)
  "Execute a block of D code BODY according to PARAMS.
This function is called by `org-babel-execute-src-block'."
  (let* ((full-body (org-babel-expand-body:d body params))
	 (tmp-file (org-babel-temp-file "d"))
	 (result (progn
		   (with-temp-file tmp-file
		     (insert full-body))
		   (org-babel-eval (format "%s -run %s" org-babel-d-command tmp-file) ""))))
    (let-alist params
      (when (and .:session (not (equal .:session "none")))
	(error "ob-d does not support sessions"))
      (cond ((member "verbatim" .:result-params) result)
	    (t result)))))

(provide 'ob-d)
