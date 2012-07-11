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

(test two-quotes
  (let* ((db (make-instance 'memory-db))
         (author (get-author db (add-author "Blub" db)))
         (user (get-user db (add-user "John" db)))
         (quote1-id (add-quote (id user) (id author) "blub1" db))
         (quote2-id (add-quote (id user) (id author) "blub2" db)))
    (is (= 2 (length (quotes author))))
    (is (= 2 (length (quotes user))))
    (let ((quote1 (find quote1-id (quotes author) :key #'id))
          (quote2 (find quote2-id (quotes author) :key #'id)))
      (is (equal quote1-id (id quote1)))
      (is (equal "blub1" (text quote1)))
      (is (equal quote2-id (id quote2)))
      (is (equal "blub2" (text quote2))))
    (let ((quote1 (find quote1-id (quotes user) :key #'id))
          (quote2 (find quote2-id (quotes user) :key #'id)))
      (is (equal quote1-id (id quote1)))
      (is (equal "blub1" (text quote1)))
      (is (equal quote2-id (id quote2)))
      (is (equal "blub2" (text quote2))))))

(run!)
