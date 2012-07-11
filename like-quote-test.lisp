(defpackage :like-quote-test
  (:use :cl :fiveam :quacks))
(in-package :like-quote-test)

(def-suite like-quote)
(in-suite like-quote)

(test like-quote
  (let* ((db (make-instance 'memory-db))
         (author (get-author-db db (add-author "Kent" db)))
         (user (get-user db (add-user "John" db)))
         (quote (get-quote
                 db
                 (add-quote (id user) (id author) "blub" db))))
    (like-quote (id quote) (id user) db)
    (is (= 1 (length (likes quote))))
    (is (= 1 (length (likes user))))
    (is (eql (first (likes quote))
             (first (likes user))))))

(test two-likes-counts-only-as-one
  (let* ((db (make-instance 'memory-db))
         (author-id (add-author "Bob" db))
         (user (get-user db (add-user "Jim" db)))
         (quote (get-quote
                 db
                 (add-quote (id user) author-id "blub" db))))
    (like-quote (id quote) (id user) db)
    (like-quote (id quote) (id user) db)
    (is (= 1 (length (likes quote))))
    (is (= 1 (length (likes user))))
    (is (eql (first (likes quote))
             (first (likes user))))))

(test two-different-likes
  (let* ((db (make-instance 'memory-db))
         (author-id (add-author "Jürgen" db))
         (user1 (get-user db (add-user "John" db)))
         (user2 (get-user db (add-user "Jim" db)))
         (quote (get-quote
                 db
                 (add-quote (id user1) author-id "blub" db))))
    (like-quote (id quote) (id user1) db)
    (like-quote (id quote) (id user2) db)
    (is (= 2 (length (likes quote))))
    (is (= 1 (length (likes user1))))
    (is (= 1 (length (likes user2))))))

(run!)
