(in-package :quacks)

(defclass quote ()
  ((text :initarg :text
         :reader text)
   (author :initarg :author
           :reader author)
   (user :initarg :user
         :reader user)
   (id :accessor id)
   (likes :initform '()
          :accessor likes)))

(defun add-quote (user-id author-id text db)
  (let* ((user (get-user db user-id))
         (author (get-author db author-id))
         (quote (make-instance 'quote
                               :user user
                               :author author
                               :text text))
         (quote-id (add-quote-to-db db quote)))
    (setf (id quote) quote-id)
    (push quote (quotes user))
    (push quote (quotes author))
    (id quote)))
