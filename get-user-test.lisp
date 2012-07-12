(defpackage :get-user-test
  (:use :cl :fiveam :quacks))
(in-package :get-user-test)

(def-suite get-user)
(in-suite get-user)

(test get-user
  (let* ((db (make-instance 'memory-db))
         (user (get-user-db db (add-user "John" db))))
    (let ((data (get-user (id user) db)))
      (is (equal "John" (cdr (assoc :name data))))
      (is (equal (id user) (cdr (assoc :id data))))
      (is (equal 0 (cdr (assoc :score data)))))))

(test one-quote
  (let* ((db (make-instance 'memory-db))
         (user (get-user-db db (add-user "John" db)))
         (author (get-author-db db (add-author "Bob" db)))
         (quote (get-quote db (add-quote (id user) (id author) "blub" db))))
    (let ((qdata (cdr (assoc :quotes-added (get-user (id user) db)))))
      (is (= 1 (length qdata)))
      (is (equal "blub" (cdr (assoc :text (first qdata)))))
      (is (= (id quote) (cdr (assoc :id (first qdata)))))
      (is (= 0 (cdr (assoc :likes (first qdata)))))
      (is (= 0 (cdr (assoc :dislikes (first qdata)))))
      (is (equal "Bob" (cdr (assoc :author-name (first qdata)))))
      (is (= (id author) (cdr (assoc :author-id (first qdata))))))
    (like-quote (id quote) (id user) db)
    (dislike-quote (id quote) (id user) db)
    (let ((qdata2 (cdr (assoc :quotes-added (get-user (id user) db)))))
      (is (= 1 (cdr (assoc :likes (first qdata2)))))
      (is (= 1 (cdr (assoc :dislikes (first qdata2)))))
      (is (= 1 (cdr (assoc :score (get-user (id user) db))))))))

(run!)
