(in-package :quacks)

(defclass user ()
  ((id :accessor id)
   (name :accessor name
         :initarg :name)
   (quotes :accessor quotes
           :initform '())
   (likes :initform '()
          :accessor likes)
   (dislikes :initform '()
          :accessor dislikes)))

(defun add-user (name db)
  (let ((user (get-user-db db name)))
    (if (eql user 'user-does-not-exist)
        (let* ((user (make-instance 'user :name name))
               (user-id (add-user-to-db db user)))
          (setf (id user) user-id)
          user-id)
        (id user))))
