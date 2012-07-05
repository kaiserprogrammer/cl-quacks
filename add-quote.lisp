(in-package :quacks)

(defclass quote ()
  ((text :initarg :text
         :reader text)
   (author :initarg :author
           :reader author)
   (user :initarg :user
         :reader user)))

(defun add-quote (user-id author-id text db)
  (let* ((user (get-user db user-id))
         (author (get-author db author-id))
         (quote (make-instance 'quote
                               :user user
                               :author author
                               :text text)))
    (push quote (quotes user))
    (push quote (quotes author))))
