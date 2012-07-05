(defpackage :add-quote-test
  (:use :cl :fiveam :quacks))
(in-package :add-quote-test)

(def-suite add-quote)
(in-suite add-quote)

(test add-quote
  (let* ((db (make-instance 'memory-db))
         (author (get-author db (add-author "Kent Beck" db)))
         (user (get-user db (add-user "Jim" db))))
    (add-quote (id user) (id author) "blub" db)
    (let ((user-quotes (quotes (get-user db "Jim")))
          (author-quotes (quotes (get-author db "Kent Beck"))))
      (is (equal "blub" (text (first user-quotes))))
      (is (eql (first user-quotes) (first author-quotes)))
      (is (eql user (user (first author-quotes))))
      (is (eql author (author (first user-quotes)))))))

(run!)
