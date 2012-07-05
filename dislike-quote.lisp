(in-package :quacks)

(defclass dislike ()
  ((user :initarg :user
         :reader user)
   (quote :initarg :quote
          :reader qquote)))

(defun dislike-quote (quote-id user-id db)
  (let* ((quote (get-quote db quote-id))
         (user (get-user db user-id)))
    (unless (member quote (dislikes user) :key #'qquote :test #'eql)
      (let ((dislike (make-instance 'dislike
                                    :user user
                                    :quote quote)))
        (push dislike (dislikes quote))
        (push dislike (dislikes user))))))
