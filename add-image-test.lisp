(defpackage :add-image-test
  (:use :cl :fiveam :quacks))
(in-package :add-image-test)

(def-suite add-image)
(in-suite add-image)

(test no-image
  (let* ((db (make-instance 'memory-db))
         (author (get-author db (add-author "Kent" db))))
    (is (equal "" (src (image author))))))

(test add-image
  (let* ((db (make-instance 'memory-db))
         (author (get-author db (add-author "Kent" db))))
    (add-image (id author) "url_path" db)
    (is (equal "url_path" (src (image author))))))

(test overriding-an-image
  (let* ((db (make-instance 'memory-db))
         (author (get-author db (add-author "Bob" db))))
    (add-image (id author) "wrong" db)
    (add-image (id author) "right" db)
    (is (equal "right" (src (image author))))))

(run!)
