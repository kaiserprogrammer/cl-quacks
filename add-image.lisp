(in-package :quacks)

(defclass image ()
  ((src :initarg :src
        :accessor src)))

(defun add-image (author-id path db)
  (let ((author (get-author db author-id)))
    (setf (image author)
          (make-instance 'image
                         :src path))))
