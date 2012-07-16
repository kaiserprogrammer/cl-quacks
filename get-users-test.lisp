(defpackage :get-users-test
  (:use :cl :fiveam :quacks))
(in-package :get-users-test)

(def-suite get-users)
(in-suite get-users)

(test no-quote
  (let* ((db (make-instance 'memory-db)))
    (add-user "John" db)
    (let ((data (get-users db)))
      (is (null (cdr (assoc :quote (first data)))))
      (is (equal "John" (cdr (assoc :name (first data))))))))

(test get-users
  (let* ((db (make-instance 'memory-db))
         (user (get-user-db db (add-user "John" db)))
         (author (get-author-db db (add-author "Bob" db)))
         (quote (get-quote db (add-quote (id user) (id author) "blub" db))))
    (let ((data (get-users db)))
      (is (= 1 (length data)))
      (is (equal "John" (cdr (assoc :name (first data)))))
      (is (= (id user) (cdr (assoc :id (first data)))))
      (is (= 0 (cdr (assoc :score (first data)))))
      (let ((qdata (cdr (assoc :quote (first data)))))
        (is (equal "blub" (cdr (assoc :text qdata))))
        (is (= (id quote) (cdr (assoc :id qdata))))
        (is (equal "Bob" (cdr (assoc :author-name qdata))))
        (is (= (id author) (cdr (assoc :author-id qdata))))))
    (add-quote (id user) (id author) "second" db)
    (like-quote (id quote) (id user) db)
    (let ((qdata (cdr (assoc :quote (first (get-users db))))))
      (is (= (id quote) (cdr (assoc :id qdata)))))))

(run!)
