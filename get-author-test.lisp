(defpackage :get-author-test
  (:use :cl :fiveam :quacks))
(in-package :get-author-test)

(def-suite get-author)
(in-suite get-author)

(test get-author-db
  (let* ((db (make-instance 'memory-db))
         (author (get-author-db db (add-author "Kent" db)))
         (data (get-author (id author) db)))
    (is (equal "Kent" (cdr (assoc :name data))))
    (is (equal (id author) (cdr (assoc :id data))))))

(test image
  (let* ((db (make-instance 'memory-db))
         (author (get-author-db db (add-author "Bob" db))))
    (let ((data (get-author (id author) db)))
      (is (equal "" (cdr (assoc :image data)))))
    (add-image (id author) "path/to/image" db)
    (let ((data (get-author (id author) db)))
      (is (equal "path/to/image" (cdr (assoc :image data)))))))

(test one-quote
  (let* ((db (make-instance 'memory-db))
         (author (get-author-db db (add-author "Jim" db)))
         (user (get-user-db db (add-user "John" db)))
         (quote (get-quote db (add-quote (id user) (id author) "blub" db))))
    (let ((qdata (first (cdr (assoc :quotes (get-author (id author) db))))))
      (is (equal (id quote) (cdr (assoc :id qdata))))
      (is (equal (text quote) (cdr (assoc :text qdata))))
      (is (equal (name user) (cdr (assoc :user-name qdata))))
      (is (equal (id user) (cdr (assoc :user-id qdata))))
      (is (= 0 (cdr (assoc :likes qdata))))
      (is (= 0 (cdr (assoc :dislikes qdata)))))))

(test likes-for-quotes
  (let* ((db (make-instance 'memory-db))
         (author (get-author-db db (add-author "Me" db)))
         (user (get-user-db db (add-user "John" db)))
         (quote (get-quote db (add-quote (id user) (id author) "blub" db))))
    (like-quote (id quote) (id user) db)
    (dislike-quote (id quote) (id user) db)
    (let ((qdata (first (cdr (assoc :quotes (get-author (id author) db))))))
      (is (= 1 (cdr (assoc :likes qdata))))
      (is (= 1 (cdr (assoc :dislikes qdata)))))))

(run!)
