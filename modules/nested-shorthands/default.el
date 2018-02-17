(defun generate-hydra:main (prefix json-file)
  (let* ((data (generate-hydra:read-json json-file))
         (forms (generate-hydra:get-hydra-forms prefix () data)))
    (dolist (elem forms)
      (eval elem))))


(defun generate-hydra:read-json (path)
  (let ((json-object-type 'hash-table)
        (json-array-type 'list)
        (json-key-type 'string))
    (json-read-file path)))


(defun generate-hydra:make-name (prefix path)
  (string-join (append prefix (reverse path)) "-"))


(defun generate-hydra:get-item-form (prefix path x)
  (let* ((name (gethash "name" x))
         (kbd (gethash "kbd" x))
         (next-path (cons name path)))
    (or (when-let ((pkg (gethash "pkg" x)))
          `(,kbd
            (shell-command ,(generate-hydra:make-name () next-path))
            ,name
            :exit
            t))
        (when-let ((pkg (gethash "children" x)))
          `(,kbd
            ,(intern (concat (generate-hydra:make-name prefix next-path)
                             "/body"))
            ,name
            :exit
            t)))))


(defun generate-hydra:get-hydra-forms (prefix path xs)
  (let ((qual-name (generate-hydra:make-name prefix path)))
    (cons `(defhydra ,(make-symbol qual-name) () ,qual-name
             ,@(mapcar (lambda (x)
                         (generate-hydra:get-item-form prefix path x))
                       xs))
          (seq-mapcat
           (lambda (x)
             (let* ((children (gethash "children" x))
                    (name (gethash "name" x))
                    (next-path (cons name path)))
               (generate-hydra:get-hydra-forms prefix next-path children)))
           (seq-filter (lambda (x)
                         (gethash "children" x))
                       xs)))))
