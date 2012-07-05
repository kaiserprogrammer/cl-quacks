(in-package :quacks)

(defvar *author-ids* 0)

(defclass memory-db ()
  ((authors :initform (make-hash-table))
   (authors-by-name :initform (make-hash-table :test #'equal))))

(defgeneric get-author (db id))
(defmethod get-author ((db memory-db) (id number))
  (gethash id (slot-value db 'authors) 'author_does_not_exist))

(defgeneric add-author-to-db (db author))

(defmethod add-author-to-db ((db memory-db) (author author))
  (let ((author-id (incf *author-ids*)))
    (setf (slot-value author 'id) author-id)
    (setf (gethash author-id (slot-value db 'authors))
          author)
    (setf (gethash (name author) (slot-value db 'authors-by-name))
          author)
    author-id))

(defgeneric get-author-by-name (db name))
(defmethod get-author-by-name ((db memory-db) (name string))
  (gethash name (slot-value db 'authors-by-name) 'author_does_not_exist))
