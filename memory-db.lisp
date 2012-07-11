(in-package :quacks)

(defvar *ids* 0)

(defclass memory-db ()
  ((authors :initform (make-hash-table))
   (authors-by-name :initform (make-hash-table :test #'equal))
   (users :initform (make-hash-table))
   (users-by-name :initform (make-hash-table :test #'equal))
   (quotes :initform (make-hash-table))))

(defgeneric get-author (db id))
(defmethod get-author ((db memory-db) (id number))
  (gethash id (slot-value db 'authors) 'author_does_not_exist))

(defgeneric add-author-to-db (db author))

(defmethod add-author-to-db ((db memory-db) (author author))
  (let ((author-id (incf *ids*)))
    (setf (slot-value author 'id) author-id)
    (setf (gethash author-id (slot-value db 'authors))
          author)
    (setf (gethash (name author) (slot-value db 'authors-by-name))
          author)
    author-id))

(defmethod get-author ((db memory-db) (name string))
  (gethash name (slot-value db 'authors-by-name) 'author_does_not_exist))

(defgeneric get-user (db id))

(defmethod get-user ((db memory-db) (id number))
  (gethash id (slot-value db 'users)))
(defmethod get-user ((db memory-db) (name string))
  (gethash name (slot-value db 'users-by-name) 'user-does-not-exist))

(defgeneric add-user-to-db (db user))
(defmethod add-user-to-db ((db memory-db) (user user))
  (let ((user-id (incf *ids*)))
    (setf (gethash user-id (slot-value db 'users)) user)
    (setf (gethash (name user) (slot-value db 'users-by-name)) user)
    user-id))

(defgeneric get-quote (db id))
(defmethod get-quote ((db memory-db) (id number))
  (gethash id (slot-value db 'quotes) 'quote-does-not-exist))

(defgeneric add-quote-to-db (db quote))
(defmethod add-quote-to-db ((db memory-db) (quote qquote))
  (let ((id (incf *ids*)))
    (setf (gethash id (slot-value db 'quotes))
          quote)
    id))

(defun get-all-authors (db)
  (loop for author being the hash-values in (slot-value db 'authors)
       collect author))
