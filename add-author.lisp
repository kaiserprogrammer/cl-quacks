(in-package :quacks)

(defclass author ()
  ((id :reader id
       :initarg :id)
   (name :accessor name
         :initarg :name)
   (quotes :accessor quotes
           :initform '())))

(defun add-author (name db)
  (let ((author (get-author db name)))
    (if (eql author 'author_does_not_exist)
        (add-author-to-db db
                          (make-instance 'author
                                         :name name))
        (id author))))
