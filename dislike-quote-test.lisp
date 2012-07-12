(defpackage :dislike-quote-test
  (:use :cl :fiveam :quacks))
(in-package :dislike-quote-test)

(def-suite dislike-quote)
(in-suite dislike-quote)

(test dislike-quote
  (let* ((db (make-instance 'memory-db))
         (author (get-author-db db (add-author "Kent" db)))
         (user (get-user-db db (add-user "John" db)))
         (quote (get-quote
                 db
                 (add-quote (id user) (id author) "blub" db))))
    (dislike-quote (id quote) (id user) db)
    (is (= 1 (length (dislikes quote))))
    (is (= 1 (length (dislikes user))))
    (is (eql (first (dislikes quote))
             (first (dislikes user))))))

(test two-dislikes-counts-only-as-one
  (let* ((db (make-instance 'memory-db))
         (author-id (add-author "Bob" db))
         (user (get-user-db db (add-user "Jim" db)))
         (quote (get-quote
                 db
                 (add-quote (id user) author-id "blub" db))))
    (dislike-quote (id quote) (id user) db)
    (dislike-quote (id quote) (id user) db)
    (is (= 1 (length (dislikes quote))))
    (is (= 1 (length (dislikes user))))
    (is (eql (first (dislikes quote))
             (first (dislikes user))))))

(test two-different-dislikes
  (let* ((db (make-instance 'memory-db))
         (author-id (add-author "Jürgen" db))
         (user1 (get-user-db db (add-user "John" db)))
         (user2 (get-user-db db (add-user "Jim" db)))
         (quote (get-quote
                 db
                 (add-quote (id user1) author-id "blub" db))))
    (dislike-quote (id quote) (id user1) db)
    (dislike-quote (id quote) (id user2) db)
    (is (= 2 (length (dislikes quote))))
    (is (= 1 (length (dislikes user1))))
    (is (= 1 (length (dislikes user2))))))


(run!)
