(defpackage :add-author-test
  (:use :cl :fiveam :quacks))
(in-package :add-author-test)

(def-suite add-author)
(in-suite add-author)

(test add-author
  (let* ((db (make-instance 'quacks:memory-db))
         (author-id (add-author "Kent Beck" db))
         (author (get-author db author-id)))
    (is (equal "Kent Beck" (name author)))))

(test add-second-author
  (let* ((db (make-instance 'memory-db))
         (first-author-id (add-author "Kent Beck" db))
         (second-author-id (add-author "Uncle Bob" db))
         (first-author (get-author db first-author-id))
         (second-author (get-author db second-author-id)))
    (is (equal "Kent Beck" (name first-author)))
    (is (equal "Uncle Bob" (name second-author)))))

(test adding-an-existing-author
  (let* ((db (make-instance 'memory-db))
         (author-id (add-author "Uncle Bob" db))
         (author-id2 (add-author "Uncle Bob" db)))
    (is (eql author-id author-id2))))

(run!)
