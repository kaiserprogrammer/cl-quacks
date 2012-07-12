(in-package :quacks)

(defclass like ()
  ((user :initarg :user
         :reader user)
   (quote :initarg :quote
          :reader qquote)))

(defun like-quote (quote-id user-id db)
  (let* ((quote (get-quote db quote-id))
         (user (get-user-db db user-id)))
    (unless (member quote (likes user) :key #'qquote :test #'eql)
      (let ((like (make-instance 'like
                                 :user user
                                 :quote quote)))
        (push like (likes quote))
        (push like (likes user))))))
