(defpackage :get-authors-test
  (:use :cl :fiveam :quacks))
(in-package :get-authors-test)

(def-suite get-authors)
(in-suite get-authors)

(test no-authors
  (let ((db (make-instance 'memory-db)))
    (is (equal '() (get-authors db)))))

(test one-author
  (let* ((db (make-instance 'memory-db))
         (author (get-author-db db (add-author "Kent Beck" db))))
    (let ((author-data (first (get-authors db))))
      (is (equal "Kent Beck" (cdr (assoc :name author-data))))
      (is (equal (id author) (cdr (assoc :id author-data)))))))

(test two-authors
  (let* ((db (make-instance 'memory-db))
         (author1 (get-author-db db (add-author "Kent Beck" db)))
         (author2 (get-author-db db (add-author "Uncle Bob" db))))
    (let ((authors (get-authors db)))
      (is (equal 2 (length authors)))
      (let ((author1-data (find (id author1)
                                authors
                                :key (lambda (author)
                                       (cdr (assoc :id author)))))
            (author2-data (find (id author2)
                                authors
                                :key (lambda (author)
                                       (cdr (assoc :id author))))))
        (is (equal "Kent Beck" (cdr (assoc :name author1-data))))
        (is (= (id author1) (cdr (assoc :id author1-data))))
        (is (equal "Uncle Bob" (cdr (assoc :name author2-data))))
        (is (= (id author2) (cdr (assoc :id author2-data))))))))

(test image
  (let* ((db (make-instance 'memory-db))
         (author (get-author-db db (add-author "Kent Beck" db))))
    (add-image (id author) "/path/to/image" db)
    (let ((author-data (first (get-authors db))))
      (is (equal "/path/to/image" (cdr (assoc :image author-data)))))))

(test quote
  (let* ((db (make-instance 'memory-db))
         (author (get-author-db db (add-author "Uncle Bob" db)))
         (user (get-user-db db (add-user "John" db)))
         (quote-id (add-quote (id user) (id author) "blub" db)))
    (let ((quote (cdr (assoc :qquote (first (get-authors db))))))
      (is (equal quote-id (cdr (assoc :id quote))))
      (is (equal "blub" (cdr (assoc :text quote))))
      (is (= 0 (cdr (assoc :likes quote))))
      (is (= 0 (cdr (assoc :dislikes quote))))
      (is (equal "John" (cdr (assoc :user-name quote))))
      (is (= (id user) (cdr (assoc :user-id quote)))))))

(test favorite-quote
  (let* ((db (make-instance 'memory-db))
         (author (get-author-db db (add-author "Mc" db)))
         (user1 (get-user-db db (add-user "Jim" db)))
         (user2 (get-user-db db (add-user "John" db)))
         (quote1-id (add-quote (id user1) (id author) "blub" db))
         (quote2-id (add-quote (id user1) (id author) "blub" db)))
    (like-quote quote1-id (id user1) db)
    (like-quote quote1-id (id user2) db)
    (like-quote quote2-id (id user2) db)
    (dislike-quote quote1-id (id user1) db)
    (let ((quote (cdr (assoc :qquote (first (get-authors db))))))
      (is (= 2 (cdr (assoc :likes quote))))
      (is (= 1 (cdr (assoc :dislikes quote)))))))

(run!)
